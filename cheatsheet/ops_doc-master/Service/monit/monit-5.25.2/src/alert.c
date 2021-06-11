/*
 * Copyright (C) Tildeslash Ltd. All rights reserved.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * In addition, as a special exception, the copyright holders give
 * permission to link the code of portions of this program with the
 * OpenSSL library under certain conditions as described in each
 * individual source file, and distribute linked combinations
 * including the two.
 *
 * You must obey the GNU Affero General Public License in all respects
 * for all of the code used other than OpenSSL.
 */

#include "config.h"

#ifdef HAVE_STDIO_H
#include <stdio.h>
#endif

#ifdef HAVE_STDLIB_H
#include <stdlib.h>
#endif

#ifdef HAVE_STDARG_H
#include <stdarg.h>
#endif

#ifdef HAVE_STRING_H
#include <string.h>
#endif

#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif

#ifdef HAVE_SIGNAL_H
#include <signal.h>
#endif

#include "monit.h"
#include "event.h"
#include "net.h"
#include "alert.h"
#include "SMTP.h"

// libmonit
#include "system/Time.h"
#include "util/Str.h"
#include "exceptions/IOException.h"


/**
 *  Implementation of the alert module
 *
 *  @file
 */


/* ----------------------------------------------------------------- Private */


// If the host is not set already (cached), translate system hostname to FQDN or fallback to plain system hostname if failed
static char *_getFQDNhostname(char host[256]) {
        assert(host);
        if (STR_UNDEF(host)) {
                struct addrinfo *result = NULL, hints = {
                        .ai_family = AF_UNSPEC,
                        .ai_flags = AI_CANONNAME,
                        .ai_socktype = SOCK_STREAM
                };
                int status = getaddrinfo(Run.system->name, NULL, &hints, &result);
                if (status == 0) {
                        for (struct addrinfo *r = result; r; r = r->ai_next) {
                                if (Str_startsWith(r->ai_canonname, Run.system->name)) {
                                        strncpy(host, r->ai_canonname, 255);
                                        break;
                                }
                        }
                        freeaddrinfo(result);
                } else {
                        LogWarning("Cannot translate '%s' to FQDN name, please set a sender address using 'set mail-format' -- %s\n", Run.system->name, status == EAI_SYSTEM ? STRERROR : gai_strerror(status));
                }
                if (STR_UNDEF(host)) {
                        // Fallback
                        strncpy(host, Run.system->name, 255);
                }
        }
        return host;
}


static void _substitute(Mail_T m, Event_T e) {
        ASSERT(m);
        ASSERT(e);

        // If the sender address contains a $HOST macro, expand it to FQDN hostname, otherwise it was overriden via a mail-format "from" option
        if (Str_sub(m->from->address, "$HOST"))
                Util_replaceString(&m->from->address, "$HOST", _getFQDNhostname(m->host));

        Util_replaceString(&m->subject, "$HOST", Run.system->name);
        Util_replaceString(&m->message, "$HOST", Run.system->name);

        char timestamp[26];
        Time_string(e->collected.tv_sec, timestamp);
        Util_replaceString(&m->subject, "$DATE", timestamp);
        Util_replaceString(&m->message, "$DATE", timestamp);

        Util_replaceString(&m->subject, "$SERVICE", e->source->name);
        Util_replaceString(&m->message, "$SERVICE", e->source->name);

        const char *description = Event_get_description(e);
        Util_replaceString(&m->subject, "$EVENT", description);
        Util_replaceString(&m->message, "$EVENT", description);

        const char *message = NVLSTR(e->message);
        Util_replaceString(&m->subject, "$DESCRIPTION", message);
        Util_replaceString(&m->message, "$DESCRIPTION", message);

        const char *action = Event_get_action_description(e);
        Util_replaceString(&m->subject, "$ACTION", action);
        Util_replaceString(&m->message, "$ACTION", action);
}


static void _escape(Mail_T m) {
        // replace bare linefeed
        Util_replaceString(&m->message, "\r\n", "\n");
        Util_replaceString(&m->message, "\n", "\r\n");
        // escape ^.
        Util_replaceString(&m->message, "\n.", "\n..");
        // drop any CR|LF from the subject
        Str_chomp(m->subject);
}


static void _copyMail(Mail_T n, Mail_T o) {
        ASSERT(n);
        ASSERT(o);

        n->to = Str_dup(o->to);
        if (o->from) {
                n->from = Address_copy(o->from);
        } else if (Run.MailFormat.from) {
                n->from = Address_copy(Run.MailFormat.from);
        } else {
                n->from = Address_new();
                n->from->address = Str_dup(ALERT_FROM);
        }
        n->replyto = o->replyto ? Address_copy(o->replyto) : Run.MailFormat.replyto ? Address_copy(Run.MailFormat.replyto) : NULL;
        n->subject = o->subject ? Str_dup(o->subject) : Run.MailFormat.subject ? Str_dup(Run.MailFormat.subject) : Str_dup(ALERT_SUBJECT);
        n->message = o->message ? Str_dup(o->message) : Run.MailFormat.message ? Str_dup(Run.MailFormat.message) : Str_dup(ALERT_MESSAGE);
}


// Append the alert to a notification list IFF:
// 1) is the given event type allowed for this recipient?
// 2a) state change notifications is always delivered
// 2b) failure notification is sent only of it matches reminder settings
static void _appendMail(List_T list, Mail_T m, Event_T e, char *host) {
        if (IS_EVENT_SET(m->events, e->id) && (e->state_changed || (e->state && m->reminder && e->count % m->reminder == 0))) {
                Mail_T tmp = NULL;
                NEW(tmp);
                tmp->host = host;
                _copyMail(tmp, m);
                _substitute(tmp, e);
                _escape(tmp);
                List_append(list, tmp);
                DEBUG("Sending %s notification to %s\n", Event_get_description(e), m->to);
        }
}


static MailServer_T _connectMTA() {
        if (! Run.mailservers)
                THROW(IOException, "No mail servers are defined -- please see the 'set mailserver' statement in the manual");
        MailServer_T mta = NULL;
        for (mta = Run.mailservers; mta; mta = mta->next) {
                DEBUG("Trying to send mail via %s:%i\n", mta->host, mta->port);
                if (mta->ssl.flags == SSL_Enabled)
                        mta->socket = Socket_create(mta->host, mta->port, Socket_Tcp, Socket_Ip, &(mta->ssl), Run.mailserver_timeout);
                else
                        mta->socket = Socket_new(mta->host, mta->port, Socket_Tcp, Socket_Ip, false, Run.mailserver_timeout);
                if (mta->socket)
                        break;
                else
                        LogError("Cannot open a connection to the mailserver %s:%i -- %s\n", mta->host, mta->port, STRERROR);
        }
        if (! mta || ! mta->socket)
                THROW(IOException, "Delivery failed -- no mail server is available");
        return mta;
}


static boolean_t _send(List_T list) {
        boolean_t failed = false;
        if (List_length(list)) {
                volatile Mail_T m = NULL;
                volatile SMTP_T smtp = NULL;
                volatile MailServer_T mta = NULL;
                TRY
                {
                        mta = _connectMTA();
                        smtp = SMTP_new(mta->socket);
                        SMTP_greeting(smtp);
                        SMTP_helo(smtp, Run.mail_hostname ? Run.mail_hostname : Run.system->name);
                        if (mta->ssl.flags == SSL_StartTLS)
                                SMTP_starttls(smtp, &(mta->ssl));
                        if (mta->username && mta->password)
                                SMTP_auth(smtp, mta->username, mta->password);
                        char now[STRLEN];
                        Time_gmtstring(Time_now(), now);
                        while ((m = List_pop(list))) {
                                SMTP_from(smtp, m->from->address);
                                SMTP_to(smtp, m->to);
                                SMTP_dataBegin(smtp);
                                if (
                                        (m->replyto && ((m->replyto->name ? Socket_print(mta->socket, "Reply-To: \"%s\" <%s>\r\n", m->replyto->name, m->replyto->address) : Socket_print(mta->socket, "Reply-To: %s\r\n", m->replyto->address)) <= 0))
                                        ||
                                        ((m->from->name ? Socket_print(mta->socket, "From: \"%s\" <%s>\r\n", m->from->name, m->from->address) : Socket_print(mta->socket, "From: %s\r\n", m->from->address)) <= 0)
                                        ||
                                        Socket_print(mta->socket,
                                                "To: %s\r\n"
                                                "Subject: %s\r\n"
                                                "Date: %s\r\n"
                                                "X-Mailer: Monit %s\r\n"
                                                "MIME-Version: 1.0\r\n"
                                                "Content-Type: text/plain; charset=utf-8\r\n"
                                                "Content-Transfer-Encoding: 8bit\r\n"
                                                "Message-Id: <%lld.%"PRIx64"@%s>\r\n"
                                                "\r\n"
                                                "%s",
                                                m->to,
                                                m->subject,
                                                now,
                                                VERSION,
                                                (long long)Time_now(), System_randomNumber(), Run.mail_hostname ? Run.mail_hostname : Run.system->name,
                                                m->message) <= 0
                                   )
                                {
                                        THROW(IOException, "Error sending data to mail server %s -- %s", mta->host, STRERROR);
                                }
                                SMTP_dataCommit(smtp);
                                gc_mail_list((Mail_T *)&m);
                        }
                        SMTP_quit(smtp);
                }
                ELSE
                {
                        failed = true;
                        LogError("Mail: %s\n", Exception_frame.message);
                }
                FINALLY
                {
                        if (m)
                                gc_mail_list((Mail_T *)&m);
                        if (smtp)
                                SMTP_free((SMTP_T *)&smtp);
                        if (mta && mta->socket)
                                Socket_free(&(mta->socket));
                }
                END_TRY;
        }
        return failed;
}


boolean_t _hasRecipient(Mail_T list, const char *recipient) {
        for (Mail_T l = list; l; l = l->next)
                if (IS(recipient, l->to))
                        return true;
        return false;
}


/* ------------------------------------------------------------------ Public */


/**
 * Notify registered users about the event
 * @param E An Event object
 * @return If failed, return Handler_Alert flag or Handler_Succeeded if succeeded
 */
Handler_Type handle_alert(Event_T E) {
        ASSERT(E);

        Handler_Type rv = Handler_Succeeded;
        Service_T s = E->source;
        if (s->maillist || Run.maillist) {
                char host[256] = {};
                List_T list = List_new();
                // Build a mail-list with local recipients that has registered interest for this event
                for (Mail_T m = s->maillist; m; m = m->next)
                        _appendMail(list, m, E, host);
                // Build a mail-list with global recipients that has registered interest for this event. Recipients which are defined in the service localy overrides the same recipient events which are registered globaly.
                for (Mail_T m = Run.maillist; m; m = m->next)
                        if (! _hasRecipient(s->maillist, m->to))
                                _appendMail(list, m, E, host);
                if (List_length(list))
                        if (_send(list))
                                rv = Handler_Alert;
                List_free(&list);
        }
        return rv;
}


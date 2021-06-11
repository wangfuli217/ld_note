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


#ifdef HAVE_OPENSSL


#ifdef HAVE_STDIO_H
#include <stdio.h>
#endif

#ifdef HAVE_MEMORY_H
#include <memory.h>
#endif

#ifdef HAVE_SYS_TYPES_H
#include <sys/types.h>
#endif

#ifdef HAVE_SYS_SOCKET_H
#include <sys/socket.h>
#endif

#ifdef HAVE_NETINET_IN_H
#include <netinet/in.h>
#endif

#ifdef HAVE_ARPA_INET_H
#include <arpa/inet.h>
#endif

#ifdef HAVE_NETDB_H
#include <netdb.h>
#endif

#ifdef HAVE_UNISTD_H
#include <unistd.h>
#endif

#ifdef HAVE_ERRNO_H
#include <errno.h>
#endif

#ifdef HAVE_STRING_H
#include <string.h>
#endif

#include <openssl/crypto.h>
#include <openssl/x509.h>
#include <openssl/x509_vfy.h>
#include <openssl/pem.h>
#include <openssl/ssl.h>
#include <openssl/err.h>
#include <openssl/rand.h>

#include "monit.h"
#include "Ssl.h"
#include "SslServer.h"

// libmonit
#include "io/File.h"
#include "system/Net.h"
#include "system/Time.h"
#include "exceptions/AssertException.h"
#include "exceptions/IOException.h"


/**
 *  SSL implementation
 *
 *  @file
 */
//FIXME: refactor Ssl_connect(), Ssl_write() and Ssl_read() + SslServer_accept (and the whole network layer) to be really non-blocking


/* ------------------------------------------------------------- Definitions */


/**
 * Number of random bytes to obtain
 */
#define RANDOM_BYTES 1024


/**
 * The PRIMARY random device selected for seeding the PRNG. We use a non-blocking pseudo random device, to generate pseudo entropy.
 */
#define URANDOM_DEVICE "/dev/urandom"


/**
 * If a non-blocking device is not found on the system a blocking entropy producer is tried instead.
 */
#define RANDOM_DEVICE "/dev/random"


#define SSLERROR ERR_error_string(ERR_get_error(),NULL)


#define T Ssl_T
struct T {
        boolean_t accepted;
        int socket;
        SslOptions_T options;
        SSL *handler;
        SSL_CTX *ctx;
        X509 *certificate;
        char error[128];
};


struct SslServer_T {
        int socket;
        SSL_CTX *ctx;
        SslOptions_T options;
};


#if (OPENSSL_VERSION_NUMBER < 0x10100000L) || defined(LIBRESSL_VERSION_NUMBER)
static Mutex_T *instanceMutexTable;
#endif


static int session_id_context = 1;


/* ----------------------------------------------------------------- Private */


static Ssl_Version _optionsVersion(int version) {
        return version != -1 ? version : Run.ssl.version != -1 ? Run.ssl.version : SSL_Auto;
}


static boolean_t _optionsVerify(short verify) {
        return verify != -1 ? verify : Run.ssl.verify != -1 ? Run.ssl.verify : false;
}


static boolean_t _optionsAllowSelfSigned(short allowSelfSigned) {
        return allowSelfSigned != -1 ? allowSelfSigned : Run.ssl.allowSelfSigned != -1 ? Run.ssl.allowSelfSigned : false;
}


static const char *_optionsCiphers(const char *ciphers) {
        return ciphers ? ciphers : Run.ssl.ciphers ? Run.ssl.ciphers: CIPHER_LIST;
}


static const char *_optionsCACertificateFile(const char *CACertificateFile) {
        return CACertificateFile ? CACertificateFile : Run.ssl.CACertificateFile ? Run.ssl.CACertificateFile: NULL;
}


static const char *_optionsCACertificatePath(const char *CACertificatePath) {
        return CACertificatePath ? CACertificatePath : Run.ssl.CACertificatePath ? Run.ssl.CACertificatePath: NULL;
}


static const char *_optionsServerPEMFile(const char *pemfile) {
        return pemfile ? pemfile : Run.ssl.pemfile ? Run.ssl.pemfile: NULL;
}


static const char *_optionsClientPEMFile(const char *clientpemfile) {
        return clientpemfile ? clientpemfile : Run.ssl.clientpemfile ? Run.ssl.clientpemfile: NULL;
}


static const char *_optionsChecksum(const char *checksum) {
        return STR_DEF(checksum) ? checksum : STR_DEF(Run.ssl.checksum) ? Run.ssl.checksum : NULL;
}


static Hash_Type _optionsChecksumType(Hash_Type checksumType) {
        return checksumType ? checksumType : Run.ssl.checksumType ? Run.ssl.checksumType : Hash_Unknown;
}


static boolean_t _setVersion(SSL_CTX *ctx, SslOptions_T options) {
        long version = SSL_OP_NO_SSLv2 | SSL_OP_NO_SSLv3 | SSL_OP_NO_TLSv1;
#if defined HAVE_TLSV1_1
        version |= SSL_OP_NO_TLSv1_1;
#endif
#if defined HAVE_TLSV1_2
        version |= SSL_OP_NO_TLSv1_2;
#endif
#if defined HAVE_TLSV1_3
        version |= SSL_OP_NO_TLSv1_3;
#endif
        switch (_optionsVersion(options->version)) {
                case SSL_V2:
#if defined OPENSSL_NO_SSL2 || ! defined HAVE_SSLV2
                        LogError("SSL: SSLv2 not supported\n");
                        return false;
#else
                        if (Run.flags & Run_FipsEnabled) {
                                LogError("SSL: SSLv2 is not allowed in FIPS mode -- use TLS\n");
                                return false;
                        }
                        version &= ~SSL_OP_NO_SSLv2;
#endif
                        break;
                case SSL_V3:
#if defined OPENSSL_NO_SSL3
                        LogError("SSL: SSLv3 not supported\n");
                        return false;
#else
                        if (Run.flags & Run_FipsEnabled) {
                                LogError("SSL: SSLv3 is not allowed in FIPS mode -- use TLS\n");
                                return false;
                        }
                        version &= ~SSL_OP_NO_SSLv3;
#endif
                        break;
                case SSL_TLSV1:
#if defined OPENSSL_NO_TLS1_METHOD
                        LogError("SSL: TLSv1.0 not supported\n");
                        return false;
#else
                        version &= ~SSL_OP_NO_TLSv1;
#endif
                        break;
                case SSL_TLSV11:
#if defined OPENSSL_NO_TLS1_1_METHOD || ! defined HAVE_TLSV1_1
                        LogError("SSL: TLSv1.1 not supported\n");
                        return false;
#else
                        version &= ~SSL_OP_NO_TLSv1_1;
#endif
                        break;
                case SSL_TLSV12:
#if defined OPENSSL_NO_TLS1_2_METHOD || ! defined HAVE_TLSV1_2
                        LogError("SSL: TLSv1.2 not supported\n");
                        return false;
#else
                        version &= ~SSL_OP_NO_TLSv1_2;
#endif
                        break;
                case SSL_TLSV13:
#if defined OPENSSL_NO_TLS1_3_METHOD || ! defined HAVE_TLSV1_3
                        LogError("SSL: TLSv1.3 not supported\n");
                        return false;
#else
                        version &= ~SSL_OP_NO_TLSv1_3;
#endif
                        break;
                case SSL_Auto:
                default:
                        // Enable TLS protocols by default
                        version &= ~SSL_OP_NO_TLSv1;
#if defined HAVE_TLSV1_1
                        version &= ~SSL_OP_NO_TLSv1_1;
#endif
#if defined HAVE_TLSV1_2
                        version &= ~SSL_OP_NO_TLSv1_2;
#endif
#if defined HAVE_TLSV1_3
                        version &= ~SSL_OP_NO_TLSv1_3;
#endif
                        break;
        }
        SSL_CTX_set_options(ctx, version);
        return true;
}


static boolean_t _retry(int socket, int *timeout, int (*callback)(int socket, time_t milliseconds)) {
        long long start = Time_milli();
        if (callback(socket, *timeout)) {
                long long stop = Time_milli();
                if (stop >= start && (*timeout -= stop - start) > 0) // Reduce timeout with guard against backward clock jumps
                        return true;
        }
        errno = ETIMEDOUT;
        return false;
}


#if (OPENSSL_VERSION_NUMBER < 0x10100000L) || defined(LIBRESSL_VERSION_NUMBER)
static unsigned long _threadID() {
        return (unsigned long)Thread_self();
}


static void _mutexLock(int mode, int n, const char *file, int line) {
        if (mode & CRYPTO_LOCK)
                Mutex_lock(instanceMutexTable[n]);
        else
                Mutex_unlock(instanceMutexTable[n]);
}
#endif


static int _checkChecksum(T C, X509_STORE_CTX *ctx, X509 *certificate) {
        Hash_Type checksumType = _optionsChecksumType(C->options->checksumType);
        const char *checksum = _optionsChecksum(C->options->checksum);
        if (checksumType != Hash_Unknown && STR_DEF(checksum) && X509_STORE_CTX_get_error_depth(ctx) == 0) {
                const EVP_MD *hash = NULL;
                switch (checksumType) {
                        case Hash_Md5:
                                if (Run.flags & Run_FipsEnabled) {
                                        X509_STORE_CTX_set_error(ctx, X509_V_ERR_APPLICATION_VERIFICATION);
                                        snprintf(C->error, sizeof(C->error), "SSL certificate MD5 checksum is not supported in FIPS mode, please use SHA1");
                                        return 0;
                                } else {
                                        hash = EVP_md5();
                                }
                                break;
                        case Hash_Sha1:
                                hash = EVP_sha1();
                                break;
                        default:
                                X509_STORE_CTX_set_error(ctx, X509_V_ERR_APPLICATION_VERIFICATION);
                                snprintf(C->error, sizeof(C->error), "Invalid SSL certificate checksum type (0x%x)", checksumType);
                                return 0;
                }
                unsigned int len, i = 0;
                unsigned char realChecksum[EVP_MAX_MD_SIZE];
                X509_digest(certificate, hash, realChecksum, &len);
                while ((i < len) && (checksum[2 * i] != '\0') && (checksum[2 * i + 1] != '\0')) {
                        unsigned char c = (checksum[2 * i] > 57 ? checksum[2 * i] - 87 : checksum[2 * i] - 48) * 0x10 + (checksum[2 * i + 1] > 57 ? checksum[2 * i + 1] - 87 : checksum[2 * i + 1] - 48);
                        if (c != realChecksum[i]) {
                                X509_STORE_CTX_set_error(ctx, X509_V_ERR_APPLICATION_VERIFICATION);
                                snprintf(C->error, sizeof(C->error), "SSL server certificate checksum failed");
                                return 0;
                        }
                        i++;
                }
        }
        return 1;
}


static int _saveAndCheckServerCertificates(T C, X509_STORE_CTX *ctx) {
        if ((C->certificate = X509_STORE_CTX_get_current_cert(ctx))) {
                return _checkChecksum(C, ctx, C->certificate);
        }
        X509_STORE_CTX_set_error(ctx, X509_V_ERR_APPLICATION_VERIFICATION);
        snprintf(C->error, sizeof(C->error), "cannot get SSL server certificate");
        return 0;
}


static int _verifyServerCertificates(int preverify_ok, X509_STORE_CTX *ctx) {
        T C = SSL_get_app_data(X509_STORE_CTX_get_ex_data(ctx, SSL_get_ex_data_X509_STORE_CTX_idx()));
        if (! C) {
                LogError("SSL: cannot get application data");
                return 0;
        }
        *C->error = 0;
        if (! preverify_ok && _optionsVerify(C->options->verify)) {
                int error = X509_STORE_CTX_get_error(ctx);
                switch (error) {
                        case X509_V_ERR_DEPTH_ZERO_SELF_SIGNED_CERT:
                                if (_optionsAllowSelfSigned(C->options->allowSelfSigned)) {
                                        X509_STORE_CTX_set_error(ctx, X509_V_OK);
                                        return _saveAndCheckServerCertificates(C, ctx);
                                }
                                snprintf(C->error, sizeof(C->error), "self signed certificate is not allowed, please use a trusted certificate or use the 'selfsigned: allow' SSL option");
                                break;
                        default:
                                break;
                }
        } else {
                return _saveAndCheckServerCertificates(C, ctx);
        }
        return 0;
}


static int _verifyClientCertificates(int preverify_ok, X509_STORE_CTX *ctx) {
        T C = SSL_get_app_data(X509_STORE_CTX_get_ex_data(ctx, SSL_get_ex_data_X509_STORE_CTX_idx()));
        if (! C) {
                LogError("SSL: cannot get application data");
                return 0;
        }
        if (! preverify_ok) {
                int error = X509_STORE_CTX_get_error(ctx);
                switch (error) {
                        case X509_V_ERR_DEPTH_ZERO_SELF_SIGNED_CERT:
                                if (! (_optionsAllowSelfSigned(C->options->allowSelfSigned))) {
                                        LogError("SSL: self-signed certificate is not allowed\n");
                                        return 0;
                                }
                                X509_STORE_CTX_set_error(ctx, X509_V_OK); // Reset error if we accept self-signed certificates
                                break;
                        case X509_V_ERR_INVALID_PURPOSE:
                                break;
                        default:
                                LogError("SSL: invalid certificate -- %s\n", X509_verify_cert_error_string(error));
                                return 0;
                }
        }
#if (OPENSSL_VERSION_NUMBER < 0x10100000L) || defined(LIBRESSL_VERSION_NUMBER)
        X509_OBJECT found_cert;
        if (X509_STORE_CTX_get_error_depth(ctx) == 0 && X509_STORE_get_by_subject(ctx, X509_LU_X509, X509_get_subject_name(X509_STORE_CTX_get_current_cert(ctx)), &found_cert) != 1) {
#else
        X509_OBJECT *found_cert = X509_OBJECT_new();
        if (X509_STORE_CTX_get_error_depth(ctx) == 0 && X509_STORE_CTX_get_by_subject(ctx, X509_LU_X509, X509_get_subject_name(X509_STORE_CTX_get_current_cert(ctx)), found_cert) != 1) {
#endif
                LogError("SSL: no matching certificate found -- %s\n", SSLERROR);
                X509_STORE_CTX_set_error(ctx, X509_V_ERR_CERT_REJECTED);
#if OPENSSL_VERSION_NUMBER >= 0x10100000L && ! defined(LIBRESSL_VERSION_NUMBER)
                X509_OBJECT_free(found_cert);
#endif
                return 0;
        }
#if OPENSSL_VERSION_NUMBER >= 0x10100000L && ! defined(LIBRESSL_VERSION_NUMBER)
        X509_OBJECT_free(found_cert);
#endif
        return 1;
}


static boolean_t _setServerNameIdentification(T C, const char *hostname) {
#ifdef SSL_CTRL_SET_TLSEXT_HOSTNAME
        struct sockaddr_storage addr;
        // If the name is set and we use TLS protocol, enable the SNI extension (provided the hostname value is not an IP address)
        if (hostname && C->options->version != SSL_V2 && C->options->version != SSL_V3 && ! inet_pton(AF_INET, hostname, &(((struct sockaddr_in *)&addr)->sin_addr)) &&
#ifdef HAVE_IPV6
                ! inet_pton(AF_INET6, hostname, &(((struct sockaddr_in6 *)&addr)->sin6_addr)) &&
#endif
                ! SSL_set_tlsext_host_name(C->handler, hostname)) {
                        DEBUG("SSL: unable to set the SNI extension to %s\n", hostname);
                        return false;
                }
#endif
        return true;
}


static boolean_t _setClientCertificate(T C, const char *file) {
        if (SSL_CTX_use_certificate_chain_file(C->ctx, file) != 1) {
                LogError("SSL client certificate chain loading failed: %s\n", SSLERROR);
                return false;
        }
        if (SSL_CTX_use_PrivateKey_file(C->ctx, file, SSL_FILETYPE_PEM) != 1) {
                LogError("SSL client private key loading failed: %s\n", SSLERROR);
                return false;
        }
        if (SSL_CTX_check_private_key(C->ctx) != 1) {
                LogError("SSL client private key doesn't match the certificate: %s\n", SSLERROR);
                return false;
        }
        return true;
}


/* ------------------------------------------------------------------ Public */


void Ssl_start() {
#if (OPENSSL_VERSION_NUMBER < 0x10100000L) || defined(LIBRESSL_VERSION_NUMBER)
        SSL_library_init();
        SSL_load_error_strings();
        int locks = CRYPTO_num_locks();
        instanceMutexTable = CALLOC(locks, sizeof(Mutex_T));
        for (int i = 0; i < locks; i++)
                Mutex_init(instanceMutexTable[i]);
        CRYPTO_set_id_callback(_threadID);
        CRYPTO_set_locking_callback(_mutexLock);
#endif
        if (File_exist(URANDOM_DEVICE))
                RAND_load_file(URANDOM_DEVICE, RANDOM_BYTES);
        else if (File_exist(RANDOM_DEVICE))
                RAND_load_file(RANDOM_DEVICE, RANDOM_BYTES);
        else
                THROW(AssertException, "SSL: cannot find %s nor %s on the system", URANDOM_DEVICE, RANDOM_DEVICE);
}


void Ssl_stop() {
#if (OPENSSL_VERSION_NUMBER < 0x10100000L) || defined(LIBRESSL_VERSION_NUMBER)
        CRYPTO_set_id_callback(NULL);
        CRYPTO_set_locking_callback(NULL);
        for (int i = 0; i < CRYPTO_num_locks(); i++)
                Mutex_destroy(instanceMutexTable[i]);
        FREE(instanceMutexTable);
        RAND_cleanup();
        ERR_free_strings();
#endif
        Ssl_threadCleanup();
}


void Ssl_threadCleanup() {
#if (OPENSSL_VERSION_NUMBER < 0x10100000L) || defined(LIBRESSL_VERSION_NUMBER)
        ERR_remove_state(0);
#endif
}


void Ssl_setFipsMode(boolean_t enabled) {
#ifdef OPENSSL_FIPS
        if (enabled && ! FIPS_mode() && ! FIPS_mode_set(1))
                THROW(AssertException, "SSL: cannot enter FIPS mode -- %s", SSLERROR);
        else if (! enabled && FIPS_mode() && ! FIPS_mode_set(0))
                THROW(AssertException, "SSL: cannot exit FIPS mode -- %s", SSLERROR);
#endif
}


T Ssl_new(SslOptions_T options) {
        ASSERT(options);
        T C;
        NEW(C);
        C->options = options;
#if (OPENSSL_VERSION_NUMBER < 0x10100000L) || defined(LIBRESSL_VERSION_NUMBER)
        const SSL_METHOD *method = SSLv23_client_method();
#else
        const SSL_METHOD *method = TLS_client_method();
#endif
        if (! method) {
                LogError("SSL: client method initialization failed -- %s\n", SSLERROR);
                goto sslerror;
        }
        if (! (C->ctx = SSL_CTX_new(method))) {
                LogError("SSL: client context initialization failed -- %s\n", SSLERROR);
                goto sslerror;
        }
        if (! _setVersion(C->ctx, options)) {
                goto sslerror;
        }
        SSL_CTX_set_default_verify_paths(C->ctx);
        const char *CACertificateFile = _optionsCACertificateFile(options->CACertificateFile);
        const char *CACertificatePath = _optionsCACertificatePath(options->CACertificatePath);
        if (CACertificateFile || CACertificatePath) {
                if (! SSL_CTX_load_verify_locations(C->ctx, CACertificateFile, CACertificatePath)) {
                        LogError("SSL: CA certificates loading failed -- %s\n", SSLERROR);
                        goto sslerror;
                }
        }
        const char *ClientPEMFile = _optionsClientPEMFile(options->clientpemfile);
        if (ClientPEMFile && ! _setClientCertificate(C, ClientPEMFile))
                goto sslerror;
#ifdef SSL_OP_NO_COMPRESSION
        SSL_CTX_set_options(C->ctx, SSL_OP_NO_COMPRESSION);
#endif
        const char *ciphers = _optionsCiphers(options->ciphers);
        if (SSL_CTX_set_cipher_list(C->ctx, ciphers) != 1) {
                LogError("SSL: client cipher list [%s] error -- no valid ciphers\n", ciphers);
                goto sslerror;
        }
        if (! (C->handler = SSL_new(C->ctx))) {
                LogError("SSL: cannot create client handler -- %s\n", SSLERROR);
                goto sslerror;
        }
        SSL_set_verify(C->handler, SSL_VERIFY_PEER, _verifyServerCertificates);
        SSL_set_mode(C->handler, SSL_MODE_ENABLE_PARTIAL_WRITE | SSL_MODE_ACCEPT_MOVING_WRITE_BUFFER);
        SSL_set_app_data(C->handler, C);
        return C;
sslerror:
        Ssl_free(&C);
        return NULL;
}


void Ssl_free(T *C) {
        ASSERT(C && *C);
        if ((*C)->handler)
                SSL_free((*C)->handler);
        if ((*C)->ctx && ! (*C)->accepted)
                SSL_CTX_free((*C)->ctx);
        FREE(*C);
}


void Ssl_close(T C) {
        ASSERT(C);
        boolean_t retry = false;
        int timeout = Run.limits.networkTimeout;
        do {
                int rv = SSL_shutdown(C->handler);
                if (rv == 0) {
                        // close notify sent
                        retry = _retry(C->socket, &timeout, Net_canRead);
                        continue;
                } else if (rv == 1) {
                        // shutdown finished
                        break;
                } else if (rv < 0) {
                        switch (SSL_get_error(C->handler, rv)) {
                                case SSL_ERROR_WANT_READ:
                                        retry = _retry(C->socket, &timeout, Net_canRead);
                                        break;
                                case SSL_ERROR_WANT_WRITE:
                                        retry = _retry(C->socket, &timeout, Net_canWrite);
                                        break;
                                default:
                                        retry = false;
                                        break;
                        }
                }
        } while (retry);
        Net_shutdown(C->socket, SHUT_RDWR);
        Net_close(C->socket);
}


void Ssl_connect(T C, int socket, int timeout, const char *name) {
        ASSERT(C);
        ASSERT(socket >= 0);
        C->socket = socket;
        SSL_set_connect_state(C->handler);
        SSL_set_fd(C->handler, C->socket);
        _setServerNameIdentification(C, name);
        boolean_t retry = false;
        do {
                int rv = SSL_connect(C->handler);
                if (rv < 0) {
                        switch (SSL_get_error(C->handler, rv)) {
                                case SSL_ERROR_NONE:
                                        break;
                                case SSL_ERROR_WANT_READ:
                                        retry = _retry(C->socket, &timeout, Net_canRead);
                                        break;
                                case SSL_ERROR_WANT_WRITE:
                                        retry = _retry(C->socket, &timeout, Net_canWrite);
                                        break;
                                default:
					rv = (int)SSL_get_verify_result(C->handler);
					if (rv != X509_V_OK)
                                                THROW(IOException, "SSL server certificate verification error: %s", *C->error ? C->error : X509_verify_cert_error_string(rv));
					else
                                                THROW(IOException, "SSL connection error: %s", SSLERROR);
                                        break;
                        }
                } else {
                        break;
                }
        } while (retry);
}


int Ssl_write(T C, void *b, int size, int timeout) {
        ASSERT(C);
        int n = 0;
        if (size > 0) {
                boolean_t retry = false;
                do {
                        switch (SSL_get_error(C->handler, (n = SSL_write(C->handler, b, size)))) {
                                case SSL_ERROR_NONE:
                                case SSL_ERROR_ZERO_RETURN:
                                        return n;
                                case SSL_ERROR_WANT_READ:
                                        n = 0;
                                        errno = EWOULDBLOCK;
                                        retry = _retry(C->socket, &timeout, Net_canRead);
                                        break;
                                case SSL_ERROR_WANT_WRITE:
                                        n = 0;
                                        errno = EWOULDBLOCK;
                                        retry = _retry(C->socket, &timeout, Net_canWrite);
                                        break;
                                case SSL_ERROR_SYSCALL:
                                        {
                                                unsigned long error = ERR_get_error();
                                                if (error)
                                                        LogError("SSL: write error -- %s\n", ERR_error_string(error, NULL));
                                                else if (n == 0)
                                                        LogError("SSL: write error -- EOF\n");
                                                else if (n == -1)
                                                        LogError("SSL: write I/O error -- %s\n", STRERROR);
                                        }
                                        return -1;
                                default:
                                        LogError("SSL: write error -- %s\n", SSLERROR);
                                        return -1;
                        }
                } while (retry);
        }
        return n;
}


int Ssl_read(T C, void *b, int size, int timeout) {
        ASSERT(C);
        int n = 0;
        if (size > 0) {
                boolean_t retry = false;
                do {
                        switch (SSL_get_error(C->handler, (n = SSL_read(C->handler, b, size)))) {
                                case SSL_ERROR_NONE:
                                case SSL_ERROR_ZERO_RETURN:
                                        return n;
                                case SSL_ERROR_WANT_READ:
                                        n = 0;
                                        errno = EWOULDBLOCK;
                                        retry = _retry(C->socket, &timeout, Net_canRead);
                                        break;
                                case SSL_ERROR_WANT_WRITE:
                                        n = 0;
                                        errno = EWOULDBLOCK;
                                        retry = _retry(C->socket, &timeout, Net_canWrite);
                                        break;
                                case SSL_ERROR_SYSCALL:
                                        {
                                                unsigned long error = ERR_get_error();
                                                if (error)
                                                        LogError("SSL: read error -- %s\n", ERR_error_string(error, NULL));
                                                else if (n == 0)
                                                        LogError("SSL: read error -- EOF\n");
                                                else if (n == -1)
                                                        LogError("SSL: read I/O error -- %s\n", STRERROR);
                                        }
                                        return -1;
                                default:
                                        LogError("SSL: read error -- %s\n", SSLERROR);
                                        return -1;
                        }
                } while (retry);
        }
        return n;
}


int Ssl_getCertificateValidDays(T C) {
        if (C && C->certificate) {
                // Certificates which expired already are catched in preverify => we don't need to handle them here
                int deltadays = 0;
#ifdef HAVE_ASN1_TIME_DIFF
                int deltaseconds;
#if (OPENSSL_VERSION_NUMBER < 0x10100000L) || defined(LIBRESSL_VERSION_NUMBER)
                if (! ASN1_TIME_diff(&deltadays, &deltaseconds, NULL, X509_get_notAfter(C->certificate))) {
#else
                if (! ASN1_TIME_diff(&deltadays, &deltaseconds, NULL, X509_get0_notAfter(C->certificate))) {
#endif
                        THROW(IOException, "invalid time format in certificate's notAfter field");
                }
#else
                ASN1_GENERALIZEDTIME *t = ASN1_TIME_to_generalizedtime(X509_get_notAfter(C->certificate), NULL);
                if (! t) {
                        THROW(IOException, "invalid time format (in certificate's notAfter field)");
                }
                TRY
                {
                        deltadays = (double)(Time_toTimestamp((const char *)t->data) - Time_now()) / 86400.;
                }
                ELSE
                {
                        THROW(IOException, "invalid time format in certificate's notAfter field -- %s", t->data);
                }
                FINALLY
                {
                        ASN1_STRING_free(t);
                }
                END_TRY;
#endif
                return deltadays > 0 ? deltadays : 0;
        }
        return -1;
}


char *Ssl_printOptions(SslOptions_T options, char *b, int size) {
        ASSERT(b);
        ASSERT(size > 0);
        *b = 0;
        if (options->flags) {
                int count = 0;
                if (options->version != -1) {
                        snprintf(b + strlen(b), size - strlen(b) - 1, "version: %s", sslnames[options->version]);
                        count++;
                }
                if (options->verify == true)
                        snprintf(b + strlen(b), size - strlen(b) - 1, "%sverify: enable", count++ ? ", " : "");
                if (options->allowSelfSigned == true)
                        snprintf(b + strlen(b), size - strlen(b) - 1, "%sselfsigned: allow", count++ ? ", " : "");
                if (options->pemfile)
                        snprintf(b + strlen(b), size - strlen(b) - 1, "%spemfile: %s", count ++ ? ", " : "", options->pemfile);
                if (options->clientpemfile)
                        snprintf(b + strlen(b), size - strlen(b) - 1, "%sclientpemfile: %s", count ++ ? ", " : "", options->clientpemfile);
                if (options->CACertificateFile)
                        snprintf(b + strlen(b), size - strlen(b) - 1, "%sCACertificateFile: %s", count ++ ? ", " : "", options->CACertificateFile);
                if (options->CACertificatePath)
                        snprintf(b + strlen(b), size - strlen(b) - 1, "%sCACertificatePath: %s", count ++ ? ", " : "", options->CACertificatePath);
                if (options->ciphers)
                        snprintf(b + strlen(b), size - strlen(b) - 1, "%sciphers: \"%s\"", count ++ ? ", " : "", options->ciphers);
        }
        return b;
}


/* -------------------------------------------------------------- SSL Server */


SslServer_T SslServer_new(int socket, SslOptions_T options) {
        ASSERT(socket >= 0);
        ASSERT(options);
        SslServer_T S;
        NEW(S);
        S->socket = socket;
        S->options = options;
#if (OPENSSL_VERSION_NUMBER < 0x10100000L) || defined(LIBRESSL_VERSION_NUMBER)
        const SSL_METHOD *method = SSLv23_server_method();
#else
        const SSL_METHOD *method = TLS_server_method();
#endif
        if (! method) {
                LogError("SSL: server method initialization failed -- %s\n", SSLERROR);
                goto sslerror;
        }
        if (! (S->ctx = SSL_CTX_new(method))) {
                LogError("SSL: server context initialization failed -- %s\n", SSLERROR);
                goto sslerror;
        }
        if (! _setVersion(S->ctx, options)) {
                goto sslerror;
        }
        if (SSL_CTX_set_session_id_context(S->ctx, (void *)&session_id_context, sizeof(session_id_context)) != 1) {
                LogError("SSL: server session id context initialization failed -- %s\n", SSLERROR);
                goto sslerror;
        }
        const char *ciphers = _optionsCiphers(options->ciphers);
        if (SSL_CTX_set_cipher_list(S->ctx, ciphers) != 1) {
                LogError("SSL: server cipher list [%s] error -- no valid ciphers\n", ciphers);
                goto sslerror;
        }
        SSL_CTX_set_options(S->ctx, SSL_OP_CIPHER_SERVER_PREFERENCE);
#ifdef SSL_MODE_RELEASE_BUFFERS
        SSL_CTX_set_mode(S->ctx, SSL_MODE_RELEASE_BUFFERS);
#endif
#ifdef SSL_OP_NO_SESSION_RESUMPTION_ON_RENEGOTIATION
        SSL_CTX_set_options(S->ctx, SSL_OP_NO_SESSION_RESUMPTION_ON_RENEGOTIATION);
#endif
#ifdef SSL_CTRL_SET_ECDH_AUTO
        SSL_CTX_set_options(S->ctx, SSL_OP_SINGLE_ECDH_USE);
        SSL_CTX_set_ecdh_auto(S->ctx, 1);
#elif defined HAVE_EC_KEY
        SSL_CTX_set_options(S->ctx, SSL_OP_SINGLE_ECDH_USE);
        EC_KEY *key = EC_KEY_new_by_curve_name(NID_X9_62_prime256v1);
        if (key) {
                SSL_CTX_set_tmp_ecdh(S->ctx, key);
                EC_KEY_free(key);
        }
#endif
        SSL_CTX_set_options(S->ctx, SSL_OP_NO_SSLv2 | SSL_OP_NO_SSLv3);
#ifdef SSL_OP_NO_COMPRESSION
        SSL_CTX_set_options(S->ctx, SSL_OP_NO_COMPRESSION);
#endif
        SSL_CTX_set_session_cache_mode(S->ctx, SSL_SESS_CACHE_OFF);
        const char *pemfile = _optionsServerPEMFile(options->pemfile);
        if (SSL_CTX_use_certificate_chain_file(S->ctx, pemfile) != 1) {
                LogError("SSL: server certificate chain loading failed -- %s\n", SSLERROR);
                goto sslerror;
        }
        if (SSL_CTX_use_PrivateKey_file(S->ctx, pemfile, SSL_FILETYPE_PEM) != 1) {
                LogError("SSL: server private key loading failed -- %s\n", SSLERROR);
                goto sslerror;
        }
        if (SSL_CTX_check_private_key(S->ctx) != 1) {
                LogError("SSL: server private key do not match the certificate -- %s\n", SSLERROR);
                goto sslerror;
        }
        const char *clientpemfile = _optionsClientPEMFile(options->clientpemfile);
        if (clientpemfile) {
                struct stat sb;
                if (stat(clientpemfile, &sb) == -1) {
                        LogError("SSL: client PEM file %s error -- %s\n", clientpemfile, STRERROR);
                        goto sslerror;
                }
                if (! S_ISREG(sb.st_mode)) {
                        LogError("SSL: client PEM file %s is not a file\n", clientpemfile);
                        goto sslerror;
                }
                if (! SSL_CTX_load_verify_locations(S->ctx, clientpemfile, NULL)) {
                        LogError("SSL: client PEM file CA certificates %s loading failed -- %s\n", clientpemfile, SSLERROR);
                        goto sslerror;
                }
                SSL_CTX_set_client_CA_list(S->ctx, SSL_load_client_CA_file(clientpemfile));
                if (! SSL_CTX_load_verify_locations(S->ctx, pemfile, NULL)) {
                        LogError("SSL: server certificate CA certificates %s loading failed -- %s\n", pemfile, SSLERROR);
                        goto sslerror;
                }
                SSL_CTX_set_verify(S->ctx, SSL_VERIFY_PEER | SSL_VERIFY_FAIL_IF_NO_PEER_CERT, _verifyClientCertificates);
        } else {
                SSL_CTX_set_verify(S->ctx, SSL_VERIFY_NONE, NULL);
        }
        return S;
sslerror:
        SslServer_free(&S);
        return NULL;
}


void SslServer_free(SslServer_T *S) {
        ASSERT(S && *S);
        if ((*S)->ctx)
                SSL_CTX_free((*S)->ctx);
        FREE(*S);
}


T SslServer_newConnection(SslServer_T S) {
        ASSERT(S);
        T C;
        NEW(C);
        C->accepted = true;
        C->ctx = S->ctx;
        if (! (C->handler = SSL_new(C->ctx))) {
                LogError("SSL: server cannot create handler -- %s\n", SSLERROR);
                Ssl_free(&C);
                return NULL;
        }
        SSL_set_mode(C->handler, SSL_MODE_ENABLE_PARTIAL_WRITE | SSL_MODE_ACCEPT_MOVING_WRITE_BUFFER);
        C->options = S->options;
        return C;
}


void SslServer_freeConnection(SslServer_T S, T *C) {
        ASSERT(S);
        ASSERT(C && *C);
        Ssl_close(*C);
        Ssl_free(C);
}


boolean_t SslServer_accept(T C, int socket, int timeout) {
        ASSERT(C);
        ASSERT(socket >= 0);
        C->socket = socket;
        SSL_set_accept_state(C->handler);
        SSL_set_fd(C->handler, C->socket);
        boolean_t retry = false;
        do {
                int rv = SSL_accept(C->handler);
                if (rv < 0) {
                        switch (SSL_get_error(C->handler, rv)) {
                                case SSL_ERROR_NONE:
                                        break;
                                case SSL_ERROR_WANT_READ:
                                        retry = _retry(C->socket, &timeout, Net_canRead);
                                        break;
                                case SSL_ERROR_WANT_WRITE:
                                        retry = _retry(C->socket, &timeout, Net_canWrite);
                                        break;
                                default:
                                        rv = (int)SSL_get_verify_result(C->handler);
                                        if (rv != X509_V_OK)
                                                LogError("SSL client certificate verification error: %s\n", *C->error ? C->error : X509_verify_cert_error_string(rv));
                                        else
                                                LogError("SSL accept error: %s\n", SSLERROR);
                                        return false;
                        }
                } else {
                        break;
                }
        } while (retry);
        return true;
}

#endif

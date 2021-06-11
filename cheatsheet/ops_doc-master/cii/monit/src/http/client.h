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

#ifndef HTTPCLIENT_H
#define HTTPCLIENT_H


/**
 * Do service action
 * @param action A string representation of Action_Type
 * @param services List of services
 * @return true if succeeded otherwise false
 */
boolean_t HttpClient_action(const char *action, List_T services);


/**
 * Print service report
 * @param type Report type or NULL
 * @return true if succeeded otherwise false
 */
boolean_t HttpClient_report(const char *type);


/**
 * Print service status
 * @param group Service group or NULL
 * @param service Service name or NULL
 * @return true if succeeded otherwise false
 */
boolean_t HttpClient_status(const char *group, const char *service);


/**
 * Print service summary
 * @param group Service group or NULL
 * @param service Service name or NULL
 * @return true if succeeded otherwise false
 */
boolean_t HttpClient_summary(const char *group, const char *service);


#endif

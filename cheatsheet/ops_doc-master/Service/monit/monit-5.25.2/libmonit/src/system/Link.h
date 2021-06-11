/*
 * Copyright (C) Tildeslash Ltd. All rights reserved.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License version 3.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
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


#ifndef LINK_INCLUDED
#define LINK_INCLUDED


/**
 * Facade for system specific network link data
 *
 * @author http://www.tildeslash.com/
 * @see http://www.mmonit.com/
 * @file
 */


#define T Link_T
typedef struct T *T;


/**
 * Test if Link by IP address is supported.
 * @return true if supported, false if not
 */
int Link_isGetByAddressSupported(void);


/**
 * Get a Link object for the given IP address.
 * @param address IP address (e.g. "127.0.0.1" or "::1")
 * @return Link object. Use Link_update() to populate with data.
 */
T Link_createForAddress(const char *address);


/**
 * Get a Link object for the given interface name.
 * @param interface Network interface name (e.g. "eth0")
 * @return Link object. Use Link_update() to populate with data.
 */
T Link_createForInterface(const char *interface);


/**
 * Destroy a Link object and release allocated resources.
 * @param L A Link object reference
 */
void Link_free(T *L);


/**
 * Reset Link object data.
 * @param L A Link object
 */
void Link_reset(T L);


/**
 * Update network statistics for object.
 * @param L A Link object
 * @exception AssertException If statistics cannot be gathered or 
 * the address/interface is invalid.
 */
void Link_update(T L);


/**
 * Get incoming bytes per second.
 * @param L A Link object
 * @return Incoming bytes per second or -1 if not available.
 */
long long Link_getBytesInPerSecond(T L);


/**
 * Get incoming bytes per minute.
 * @param L A Link object
 * @param count Number of minutes, the returned number will be for the 
 * range given by 'now - count' (count max = 60m)
 * @return Incoming bytes per minute or -1 if not available.
 */
long long Link_getBytesInPerMinute(T L, int count);


/**
 * Get total incoming bytes.
 * @param L A Link object
 * @return Incoming bytes total or -1 if not available.
 */
long long Link_getBytesInTotal(T L);


/**
 * Get incoming link saturation.
 * @param L A Link object
 * @return Incoming link saturation percent or -1 the link has unknown speed.
 */
double Link_getSaturationInPerSecond(T L);


/**
 * Get incoming bytes per hour.
 * @param L A Link object
 * @param count Number of hours, the returned number will be for 
 * range given by 'now - count' (count max = 24h)
 * @return Incoming bytes per hour or -1 if not available.
 */
long long Link_getBytesInPerHour(T L, int count);


/**
 * Get incoming packets per second.
 * @param L A Link object
 * @return Incoming packets per second or -1 if not available.
 */
long long Link_getPacketsInPerSecond(T L);


/**
 * Get incoming packets per minute.
 * @param L A  object
 * @param count Number of minutes, the returned statistics will be for 
 * the range given by 'now - count' (count max = 60m)
 * @return Incoming packets per minute statistics or -1 if not available.
 */
long long Link_getPacketsInPerMinute(T L, int count);


/**
 * Get incoming packets per hour statistics.
 * @param L A Link object
 * @param count Number of hours, the returned statistics will be for 
 * the range given by 'now - count' (count max = 24h)
 * @return Incoming packets per hour statistics or -1 if not available.
 */
long long Link_getPacketsInPerHour(T L, int count);


/**
 * Get total incoming packets statistics.
 * @param L A Link object
 * @return Incoming packets total or -1 if not available.
 */
long long Link_getPacketsInTotal(T L);


/**
 * Get incoming errors per second.
 * @param L A Link object
 * @return Incoming errors per second or -1 if not available.
 */
long long Link_getErrorsInPerSecond(T L);


/**
 * Get incoming errors per minute.
 * @param L A Link object
 * @param count Number of minutes, the returned statistics will be for
 * the range given by 'now - count' (count max = 60m)
 * @return Incoming errors per minute or -1 if not available.
 */
long long Link_getErrorsInPerMinute(T L, int count);


/**
 * Get incoming errors per hour.
 * @param L A Link object
 * @param count Number of hours, the returned statistics will be for 
 * the range given by 'now - count' (count max = 24h)
 * @return Incoming errors per hour or -1 if not available.
 */
long long Link_getErrorsInPerHour(T L, int count);


/**
 * Get total incoming errors.
 * @param L A Link object
 * @return Incoming errors total or -1 if not available.
 */
long long Link_getErrorsInTotal(T L);


/**
 * Get outgoing bytes per second.
 * @param L A Link object
 * @return Outgoing bytes per second or -1 if not available.
 */
long long Link_getBytesOutPerSecond(T L);


/**
 * Get outgoing bytes per minute.
 * @param L A Link object
 * @param count Number of minutes, the returned statistics will be for
 * the range given by 'now - count' (count max = 60m)
 * @return Outgoing bytes per minute or -1 if not available.
 */
long long Link_getBytesOutPerMinute(T L, int count);


/**
 * Get outgoing bytes per hour.
 * @param L A Link object
 * @param count Number of hours, the returned statistics will be for 
 * the range given by 'now - count' (count max = 24h)
 * @return Outgoing bytes per hour or -1 if not available.
 */
long long Link_getBytesOutPerHour(T L, int count);


/**
 * Get total outgoing bytes.
 * @param L A Link object
 * @return Outgoing bytes total or -1 if not available.
 */
long long Link_getBytesOutTotal(T L);


/**
 * Get outgoing link saturation.
 * @param L A Link object
 * @return Outgoing link saturation percent or -1 the link has unknown speed.
 */
double Link_getSaturationOutPerSecond(T L);


/**
 * Get outgoing packets per second.
 * @param L A Link object
 * @return Outgoing packets per second or -1 if not available.
 */
long long Link_getPacketsOutPerSecond(T L);


/**
 * Get outgoing packets per minute.
 * @param L A Link object
 * @param count Number of minutes, the returned statistics will be for 
 * the range given by 'now - count' (count max = 60m)
 * @return Outgoing packets per minute or -1 if not available.
 */
long long Link_getPacketsOutPerMinute(T L, int count);


/**
 * Get outgoing packets per hour.
 * @param L A Link object
 * @param count Number of hours, the returned statistics will be for
 * the range given by 'now - count' (count max = 24h)
 * @return Outgoing packets per hour or -1 if not available.
 */
long long Link_getPacketsOutPerHour(T L, int count);


/**
 * Get total outgoing packets.
 * @param L A Link object
 * @return Outgoing packets total or -1 if not available.
 */
long long Link_getPacketsOutTotal(T L);


/**
 * Get outgoing errors per second.
 * @param L A Link object
 * @return Outgoing errors per second or -1 if not available.
 */
long long Link_getErrorsOutPerSecond(T L);


/**
 * Get outgoing errors per minute.
 * @param L A Link object
 * @param count Number of minutes, the returned statistics will be for
 * the range given by 'now - count' (count max = 60m)
 * @return Outgoing errors per minute or -1 if not available.
 */
long long Link_getErrorsOutPerMinute(T L, int count);


/**
 * Get outgoing errors per hour.
 * @param L A Link object
 * @param count Number of hours, the returned statistics will be for
 * the range given by 'now - count' (count max = 24h)
 * @return Outgoing errors per hour or -1 if not available.
 */
long long Link_getErrorsOutPerHour(T L, int count);


/**
 * Get total outgoing errors.
 * @param L A Link object
 * @return Outgoing errors total or -1 if not available
 */
long long Link_getErrorsOutTotal(T L);


/**
 * Get interface state.
 * @param L A Link object
 * @return Interface state (-1 = N/A, 0 = down, 1 = up)
 */
int Link_getState(T L);


/**
 * Get interface speed (note: not all interface types support speed)
 * @param L A Link object
 * @return Interface speed [bps] (-1 = N/A)
 */
long long Link_getSpeed(T L);


/**
 * Get interface duplex state (note: not all interface types support duplex)
 * @param L A Link object
 * @return Duplex state (-1 = N/A, 0 = half, 1 = full)
 */
int Link_getDuplex(T L);


#undef T
#endif

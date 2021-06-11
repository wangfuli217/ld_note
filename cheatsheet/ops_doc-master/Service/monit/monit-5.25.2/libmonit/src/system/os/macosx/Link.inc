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


/**
 * Implementation of the Network Statistics for MacOSX.
 *
 * @author http://www.tildeslash.com/
 * @see http://www.mmonit.com/
 * @file
 */


static boolean_t _update(T L, const char *interface) {
        size_t len;
        int mib[6] = {CTL_NET, PF_ROUTE, 0, 0, NET_RT_IFLIST2, 0};
        if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0)
                THROW(AssertException, "Cannot get link statistics -- %s", System_getError(errno));
        struct if_msghdr2 *buf = CALLOC(1, len);
        if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
                FREE(buf);
                THROW(AssertException, "Cannot get link statistics -- %s", System_getError(errno));
        }
        for (struct if_msghdr2 *ifm = buf; (void *)ifm < (void *)buf + len; ifm = (void *)ifm + ifm->ifm_msglen) {
                if (ifm->ifm_type == RTM_IFINFO2) {
                        char name[STRLEN];
                        struct sockaddr_dl *sdl = (struct sockaddr_dl *)(ifm + 1);
                        strncpy(name, sdl->sdl_data, sdl->sdl_nlen);
                        name[sdl->sdl_nlen] = 0;
                        if (Str_isEqual(interface, name)) {
                                int s = socket(AF_INET, SOCK_DGRAM, 0);
                                if (s > 0) {
                                        struct ifmediareq ifmr;
                                        memset(&ifmr, 0, sizeof(ifmr));
                                        strncpy(ifmr.ifm_name, interface, sizeof(ifmr.ifm_name));
                                        // try SIOCGIFMEDIA - if not supported, assume the interface is UP (loopback or other virtual interface)
                                        if (ioctl(s, SIOCGIFMEDIA, (caddr_t)&ifmr) >= 0) {
                                                if (ifmr.ifm_status & IFM_AVALID && ifmr.ifm_status & IFM_ACTIVE) {
                                                        L->state = 1LL;
                                                        L->duplex = ifmr.ifm_active & 0x00100000 ? 1LL : 0LL;
                                                } else {
                                                        L->state = 0LL;
                                                        L->duplex = -1LL;
                                                }
                                        } else {
                                                L->state = 1LL;
                                        }
                                        close(s);
                                } else {
                                        L->state = -1LL;
                                        L->duplex = -1LL;
                                }
                                L->timestamp.last = L->timestamp.now;
                                L->timestamp.now = Time_milli();
                                L->speed = ifm->ifm_data.ifi_baudrate;
                                _updateValue(&(L->ibytes), ifm->ifm_data.ifi_ibytes);
                                _updateValue(&(L->ipackets), ifm->ifm_data.ifi_ipackets);
                                _updateValue(&(L->ierrors), ifm->ifm_data.ifi_ierrors);
                                _updateValue(&(L->obytes), ifm->ifm_data.ifi_obytes);
                                _updateValue(&(L->opackets), ifm->ifm_data.ifi_opackets);
                                _updateValue(&(L->oerrors), ifm->ifm_data.ifi_oerrors);
                                FREE(buf);
                                return true;
                        }
                }
        }
        FREE(buf);
        return false;
}


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
 * Implementation of the Network Statistics for Linux.
 *
 * @author http://www.tildeslash.com/
 * @see http://www.mmonit.com/
 * @file
 */


static boolean_t _update(T L, const char *interface) {
        char buf[STRLEN];
        char path[PATH_MAX];
        char name[STRLEN];
        /*
         * Handle IP alias
         */
        snprintf(name, sizeof(name), "%s", interface);
        Str_replaceChar(name, ':', 0);
        /*
         * Get interface operation state (Optional: may not be present on older kernels).
         * $ cat /sys/class/net/eth0/operstate
         * up
         */
        snprintf(path, sizeof(path), "/sys/class/net/%s/operstate", name);
        FILE *f = fopen(path, "r");
        if (f) {
                if (fscanf(f, "%256s\n", buf) != 1) {
                        fclose(f);
                        THROW(AssertException, "Cannot parse %s -- %s", path, System_getError(errno));
                }
                L->state = Str_isEqual(buf, "down") ? 0LL : 1LL;
                fclose(f);
        } else {
                THROW(AssertException, "Cannot read %s -- %s", path, System_getError(errno));
        }
        /*
         * Get interface speed (Optional: may not be present on older kernels and readable for pseudo interface types).
         * $ cat /sys/class/net/eth0/speed
         * 1000
         * If the link is down the file either doesn't exist or contains UINT_MAX (depends on kernel version):
         * $ cat /sys/class/net/eth0/speed
         * 4294967295
         */
        snprintf(path, sizeof(path), "/sys/class/net/%s/speed", name);
        f = fopen(path, "r");
        if (f) {
                if (fscanf(f, "%lld\n", &(L->speed)) == 1 && L->speed != UINT_MAX)
                        L->speed *= 1000000; // mbps -> bps
                else
                        L->speed = -1LL;
                fclose(f);
        }
        /*
         * Get interface full/half duplex status (Optional: may not be present on older kernels and readable for pseudo interface types).
         * $ cat /sys/class/net/eth0/duplex
         * full
         * If the link is down the file either doesn't exist or contains "unknown" value (depends on kernel version):
         * $ cat /sys/class/net/eth0/duplex
         * unknown
         */
        snprintf(path, sizeof(path), "/sys/class/net/%s/duplex", name);
        f = fopen(path, "r");
        if (f) {
                if (fscanf(f, "%256s\n", buf) == 1 && ! Str_isEqual(buf, "unknown"))
                        L->duplex = Str_isEqual(buf, "full") ? 1LL : 0LL;
                else
                        L->duplex = -1;
                fclose(f);
        }
        /*
         * $ cat /sys/class/net/eth0/statistics/rx_bytes 
         * 239426
         */
        snprintf(path, sizeof(path), "/sys/class/net/%s/statistics/rx_bytes", name);
        f = fopen(path, "r");
        if (f) {
                long long ibytes;
                if (fscanf(f, "%lld\n", &ibytes) != 1) {
                        fclose(f);
                        THROW(AssertException, "Cannot parse %s -- %s", path, System_getError(errno));
                }
                _updateValue(&(L->ibytes), ibytes);
                fclose(f);
        } else {
                THROW(AssertException, "Cannot read %s -- %s", path, System_getError(errno));
        }
        /*
         * $ cat /sys/class/net/eth0/statistics/rx_packets 
         * 2706
         */
        snprintf(path, sizeof(path), "/sys/class/net/%s/statistics/rx_packets", name);
        f = fopen(path, "r");
        if (f) {
                long long ipackets;
                if (fscanf(f, "%lld\n", &ipackets) != 1) {
                        fclose(f);
                        THROW(AssertException, "Cannot parse %s -- %s", path, System_getError(errno));
                }
                _updateValue(&(L->ipackets), ipackets);
                fclose(f);
        } else {
                THROW(AssertException, "Cannot read %s -- %s", path, System_getError(errno));
        }
        /*
         * $ cat /sys/class/net/eth0/statistics/rx_errors 
         * 0
         */
        snprintf(path, sizeof(path), "/sys/class/net/%s/statistics/rx_errors", name);
        f = fopen(path, "r");
        if (f) {
                long long ierrors;
                if (fscanf(f, "%lld\n", &ierrors) != 1) {
                        fclose(f);
                        THROW(AssertException, "Cannot parse %s -- %s", path, System_getError(errno));
                }
                _updateValue(&(L->ierrors), ierrors);
                fclose(f);
        } else {
                THROW(AssertException, "Cannot read %s -- %s", path, System_getError(errno));
        }
        /*
         * $ cat /sys/class/net/eth0/statistics/tx_bytes 
         * 410775
         */
        snprintf(path, sizeof(path), "/sys/class/net/%s/statistics/tx_bytes", name);
        f = fopen(path, "r");
        if (f) {
                long long obytes;
                if (fscanf(f, "%lld\n", &obytes) != 1) {
                        fclose(f);
                        THROW(AssertException, "Cannot parse %s -- %s", path, System_getError(errno));
                }
                _updateValue(&(L->obytes), obytes);
                fclose(f);
        } else {
                THROW(AssertException, "Cannot read %s -- %s", path, System_getError(errno));
        }
        /*
         * $ cat /sys/class/net/eth0/statistics/tx_packets 
         * 1649
         */
        snprintf(path, sizeof(path), "/sys/class/net/%s/statistics/tx_packets", name);
        f = fopen(path, "r");
        if (f) {
                long long opackets;
                if (fscanf(f, "%lld\n", &opackets) != 1) {
                        fclose(f);
                        THROW(AssertException, "Cannot parse %s -- %s", path, System_getError(errno));
                }
                _updateValue(&(L->opackets), opackets);
                fclose(f);
        } else {
                THROW(AssertException, "Cannot read %s -- %s", path, System_getError(errno));
        }
        /*
         * $ cat /sys/class/net/eth0/statistics/tx_errors  
         * 0
         */
        snprintf(path, sizeof(path), "/sys/class/net/%s/statistics/tx_errors", name);
        f = fopen(path, "r");
        if (f) {
                long long oerrors;
                if (fscanf(f, "%lld\n", &oerrors) != 1) {
                        fclose(f);
                        THROW(AssertException, "Cannot parse %s -- %s", path, System_getError(errno));
                }
                _updateValue(&(L->oerrors), oerrors);
                fclose(f);
        } else {
                THROW(AssertException, "Cannot read %s -- %s", path, System_getError(errno));
        }
        L->timestamp.last = L->timestamp.now;
        L->timestamp.now = Time_milli();
        return true;
}


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

#ifndef MONIT_PROCESSTREE_H
#define MONIT_PROCESSTREE_H

#include "config.h"


typedef struct ProcessTree_T {
        boolean_t visited;
        boolean_t zombie;
        pid_t pid;
        pid_t ppid;
        int parent;
        struct {
                int uid;
                int euid;
                int gid;
        } cred;
        struct {
                struct {
                        float self;
                        float children;
                } usage;
                double time;
        } cpu;
        struct {
                int self;
                int children;
        } threads;
        struct {
                int count;
                int total;
                int *list;
        } children;
        struct {
                uint64_t usage;
                uint64_t usage_total;
        } memory;
        struct {
                uint64_t time;
                uint64_t bytes;
                uint64_t operations;
        } read;
        struct {
                uint64_t time;
                uint64_t bytes;
                uint64_t operations;
        } write;
        time_t uptime;
        char *cmdline;
        char *secattr;
} ProcessTree_T;


/**
 * Initialize the process tree
 * @param pflags Process engine flags
 * @return The process tree size or -1 if failed
 */
int ProcessTree_init(ProcessEngine_Flags pflags);


/**
 * Delete the process tree
 */
void ProcessTree_delete(void);


/**
 * Update the process infomation.
 * @param s A Service object
 * @param pid Process PID to update
 * @return true if succeeded otherwise false.
 */
boolean_t ProcessTree_updateProcess(Service_T s, pid_t pid);


/**
 * Get process uptime
 * @param pid Process PID
 * @return The PID of the running running process or 0 if the process is not running.
 */
time_t ProcessTree_getProcessUptime(pid_t pid);


/**
 * Find the process in the process tree
 * @param s The service being checked
 * @return The PID of the running running process or 0 if the process is not running.
 */
pid_t ProcessTree_findProcess(Service_T s);


/**
 * Print a table with all processes matching a given pattern
 * @param pattern The process pattern
 */
void ProcessTree_testMatch(char *pattern);


/**
 * Initialize the system information
 * @return true if succeeded otherwise false.
 */
boolean_t init_system_info(void);


/**
 * Update system statistic
 * @return true if successful, otherwise false
 */
boolean_t update_system_info(void);


#endif


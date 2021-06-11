/*
 *  Boa, an http server
 *  Copyright (C) 1995 Paul Phillips <paulp@go2net.com>
 *  Some changes Copyright (C) 1996 Charles F. Randall <crandall@goldsys.com>
 *  Some changes Copyright (C) 1996 Larry Doolittle <ldoolitt@boa.org>
 *  Some changes Copyright (C) 1996-2002 Jon Nelson <jnelson@boa.org>
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 1, or (at your option)
 *  any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 */



#include "boa.h"

static void fdset_update(void);
fd_set block_read_fdset;
fd_set block_write_fdset;
static struct timeval req_timeout;     

void select_loop(int server_s)
{
    FD_ZERO(&block_read_fdset);
    FD_ZERO(&block_write_fdset);
    
    req_timeout.tv_sec = (ka_timeout ? ka_timeout : REQUEST_TIMEOUT);
    req_timeout.tv_usec = 0l;   

    while (1) {
      
        if (sigterm_flag) {
            if (sigterm_flag == 1)
                sigterm_stage1_run(server_s);
            if (sigterm_flag == 2 && !request_ready && !request_block) {
                sigterm_stage2_run();
            }
        }

		max_fd = -1;
      
        time(&current_time);

        if (request_block)
            
            fdset_update();

        
        process_requests(server_s);

        if (!sigterm_flag && total_connections < (max_connections - 10)) {
                        
            event_add(server_event, NULL);
        }

        req_timeout.tv_sec = (request_ready ? 0 :
                              (ka_timeout ? ka_timeout : REQUEST_TIMEOUT));
        req_timeout.tv_usec = 0l;   


		
		FD_ZERO(&block_read_fdset);
		FD_ZERO(&block_write_fdset);
		if( (request_ready || request_block) )
			event_base_loopexit(boa_event_base, &req_timeout);
		event_base_loop(boa_event_base, EVLOOP_ONCE) ;
#if 0
    if ((request_ready || request_block)){
			event_base_loop(boa_event_base, EVLOOP_NONBLOCK) ;
			if (select(max_fd + 1, &block_read_fdset,
                   &block_write_fdset, NULL, 
                   ((request_ready || request_block) ? &req_timeout : NULL)
                    ) == -1) {
            
	            if (errno == EINTR)
    	            continue;   
    	        else if (errno != EBADF) {
    	            DIE("select");
    	        }
    	    }
        }else {
			event_base_loop(boa_event_base, EVLOOP_ONCE) ;
		}
#endif

    }
}

/*
 * Name: fdset_update
 *
 * Description: iterate through the blocked requests, checking whether
 * that file descriptor has been set by select.  Update the fd_set to
 * reflect current status.
 *
 * Here, we need to do some things:
 *  - keepalive timeouts simply close
 *    (this is special:: a keepalive timeout is a timeout where
       keepalive is active but nothing has been read yet)
 *  - regular timeouts close + error
 *  - stuff in buffer and fd ready?  write it out
 *  - fd ready for other actions?  do them
 */

static void fdset_update(void)
{
    request *current, *next;

    for(current = request_block;current;current = next) {
        time_t time_since = current_time - current->time_last;
        next = current->next;

        /* hmm, what if we are in "the middle" of a request and not
         * just waiting for a new one... perhaps check to see if anything
         * has been read via header position, etc... */
        if (current->kacount < ka_max && 
            (time_since >= ka_timeout) && 
            !current->logline)  
            current->status = DEAD; 
        else if (time_since > REQUEST_TIMEOUT) {
            log_error_doc(current);
            fputs("connection timed out\n", stderr);
            current->status = DEAD;
        }
        if (current->buffer_end && current->status < DEAD) {
            if (FD_ISSET(current->fd, &block_write_fdset))
                ready_request(current);
            else {
                BOA_FD_SET(current->fd, &block_write_fdset);
            }
        } else {
            switch (current->status) {
            case WRITE:
            case PIPE_WRITE:
                if (FD_ISSET(current->fd, &block_write_fdset))
                    ready_request(current);
                else {
                    BOA_FD_SET(current->fd, &block_write_fdset);
                }
                break;
            case BODY_WRITE:
                if (FD_ISSET(current->post_data_fd, &block_write_fdset))
                    ready_request(current);
                else {
                    BOA_FD_SET(current->post_data_fd, &block_write_fdset);
                }
                break;
            case PIPE_READ:
                if (FD_ISSET(current->data_fd, &block_read_fdset))
                    ready_request(current);
                else {
                    BOA_FD_SET(current->data_fd, &block_read_fdset);
                }
                break;
            case DONE:
                if (FD_ISSET(current->fd, &block_write_fdset))
                    ready_request(current);
                else {
                    BOA_FD_SET(current->fd, &block_write_fdset);
                }
                break;
            case DEAD:
                ready_request(current);
                break;
            default:
                if (FD_ISSET(current->fd, &block_read_fdset))
                    ready_request(current);
                else {
                    BOA_FD_SET(current->fd, &block_read_fdset);
                }
                break;
            }
        }
        current = next;
    }
}


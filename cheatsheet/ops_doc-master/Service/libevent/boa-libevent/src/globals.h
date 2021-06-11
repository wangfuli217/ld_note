/*
 *  Boa, an http server
 *  Copyright (C) 1995 Paul Phillips <paulp@go2net.com>
 *  Some changes Copyright (C) 1996,97 Larry Doolittle <ldoolitt@jlab.org>
 *  Some changes Copyright (C) 1997 Jon Nelson <jnelson@boa.org>
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



#ifndef _GLOBALS_H
#define _GLOBALS_H


struct mmap_entry {
    dev_t dev;
    ino_t ino;
    char *mmap;
    int use_count;
    size_t len;
};

struct alias {
    char *fakename;             
    char *realname;             
    int type;                   
    int fake_len;               
    int real_len;               
    struct alias *next;
};

typedef struct alias alias;

struct request {                
    int fd;                     
    int status;                 
    time_t time_last;           
    char *pathname;             
    int simple;                 
    int keepalive;              
    int kacount;                

    int data_fd;                
    unsigned long filesize;     
    unsigned long filepos;      
    char *data_mem;             
    int method;                 

    char *logline;              

    char *header_line;          
    char *header_end;           
    int parse_pos;              
    int client_stream_pos;      

    int buffer_start;           
    int buffer_end;             

    char *http_version;         
    int response_status;        

    char *if_modified_since;    
    time_t last_modified;       

    char local_ip_addr[NI_MAXHOST]; 

    

    int remote_port;            

    char remote_ip_addr[NI_MAXHOST]; 

    int is_cgi;                 
    int cgi_status;
    int cgi_env_index;          

    
    char *header_user_agent;
    char *header_referer;

    int post_data_fd;           

    char *path_info;            
    char *path_translated;      
    char *script_name;          
    char *query_string;         
    char *content_type;         
    char *content_length;       

    struct mmap_entry *mmap_entry_var;

    struct request *next;       
    struct request *prev;       

    
    char buffer[BUFFER_SIZE + 1]; 
    char request_uri[MAX_HEADER_LENGTH + 1]; 
    char client_stream[CLIENT_STREAM_SIZE]; 
    char *cgi_env[CGI_ENV_MAX + 4];             

#ifdef ACCEPT_ON
    char accept[MAX_ACCEPT_LENGTH]; 
#endif
};

typedef struct request request;

struct status {
    long requests;
    long errors;
};


extern struct status status;

extern char *optarg;            
extern FILE *yyin;              

extern request *request_ready;  
extern request *request_block;  
extern request *request_free;   

extern fd_set block_read_fdset; 
extern fd_set block_write_fdset; 



extern char *access_log_name;
extern char *error_log_name;
extern char *cgi_log_name;
extern int cgi_log_fd;
extern int use_localtime;

extern int server_port;
extern uid_t server_uid;
extern gid_t server_gid;
extern char *server_admin;
extern char *server_root;
extern char *server_name;
extern char *server_ip;
extern int max_fd;
extern int devnullfd;

extern char *document_root;
extern char *user_dir;
extern char *directory_index;
extern char *default_type;
extern char *dirmaker;
extern char *mime_types;
extern char *cachedir;

extern char *tempdir;

extern char *cgi_path;
extern int single_post_limit;

extern int ka_timeout;
extern int ka_max;

extern int sighup_flag;
extern int sigchld_flag;
extern int sigalrm_flag;
extern int sigterm_flag;
extern time_t start_time;

extern int pending_requests;
extern long int max_connections;

extern int verbose_cgi_logs;

extern int backlog;
extern time_t current_time;

extern int virtualhost;

extern int total_connections;

extern sigjmp_buf env;
extern int handle_sigbus;



struct event_entry{
    struct event_entry* prev;
    struct event_entry* next;
	struct event*		event;
}; 
extern struct event        *server_event;
extern struct event_base   *boa_event_base;
extern struct event_entry  *event_used;
extern struct event_entry  *event_unused;
#endif

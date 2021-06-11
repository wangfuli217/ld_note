#ifndef __WORKER_H__
#define __WORKER_H__

struct evhttp_request;

void deploy_show (struct evhttp_request *req, void *arg);
void deploy_create (struct evhttp_request *req, void *arg);
void fire_show (struct evhttp_request *req, void *arg);
void fire_create (struct evhttp_request *req, void *arg);
void log_show (struct evhttp_request *req, void *arg);
void status_show (struct evhttp_request *req, void *arg);

#endif

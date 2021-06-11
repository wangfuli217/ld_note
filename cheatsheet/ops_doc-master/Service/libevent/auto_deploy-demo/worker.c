#include <event.h>
#include <evhttp.h>
#include <string.h>
#include <stdlib.h>
#include <pthread.h>
#include "deploy.h"
#include "worker.h"
#include "smart_str.h"
#include "cJSON.h"
#include "utils.h"
#include "redis.h"
#include "process.h"

#define get_buffer_from_req(body, req) do { \
    smart_str *__str = (smart_str *)body; \
    struct evbuffer *__buff = evhttp_request_get_input_buffer(req); \
    size_t __size = evbuffer_get_length(__buff); \
    smart_str_appendl(__str, evbuffer_pullup(__buff, -1), __size); \
    smart_str_0(__str); \
 } while(0)

#define get_deploy_hash_key(s, id) do { \
    smart_str *__hash_key = (smart_str *)s; \
    char __deploy_id[16] = { 0 }; \
    sprintf(__deploy_id, "%d", id); \
    smart_str_appendl(__hash_key, DEPLOY_HASH_PREFIX, strlen(DEPLOY_HASH_PREFIX)); \
    smart_str_appendl(__hash_key, __deploy_id, strlen(__deploy_id)); \
    smart_str_0(__hash_key); \
} while(0)

#define push_deploy_to_list(id) do { \
    char __deploy_id[16] = { 0 }; \
    sprintf(__deploy_id, "%d", id); \
    redis_list_push(DEPLOY_LIST_KEY, __deploy_id); \
 } while(0)

static void output (struct evhttp_request *req, char *content, int code) {
    struct evbuffer *buf = evbuffer_new ();
    evbuffer_add_printf (buf, "%s", content);
    evhttp_add_header (req->output_headers, "Content-Type", "application/json; charset=utf-8");
    evhttp_send_reply (req, code, NULL, buf);
    evbuffer_free (buf);
}

#define send_bad_request(req, msg) \
    output(req, msg, HTTP_BADREQUEST)
#define send_normal_request(req, msg) \
    output(req, msg, HTTP_OK)
#define send_internal_request(req, msg) \
    output(req, msg, HTTP_INTERNAL)

struct deploy_create_params {
    char *author;
    char *version;
    int id;
};

static void deploy_show_all (struct evhttp_request *req) {
    cJSON *json_ret = cJSON_CreateArray ();
    redisReply *result = redis_list_get (DEPLOY_LIST_KEY, 0, -1);
    if (result != NULL) {
        for (int i = 0; i < result->elements; i++) {
            cJSON *item = cJSON_CreateObject ();
            cJSON_AddItemToObject (item, "id", cJSON_CreateString (result->element[i]->str));
            cJSON_AddItemToArray (json_ret, item);
        }
    }
    char *json_encoded = cJSON_Print (json_ret);
    send_normal_request (req, json_encoded);

    freeReplyObject (result);
    free (json_encoded);
    cJSON_Delete (json_ret);
}

static void deploy_show_single (struct evhttp_request *req, char *deploy_id) {
#define get_cache_to_json(field) do { \
        if (redis_hash_get(&(field), redis_key.c, #field)) { \
            cJSON_AddItemToObject(json_ret, #field, cJSON_CreateString((field).c)); \
        } \
    } while(0)

    cJSON *json_ret = cJSON_CreateObject ();
    smart_str redis_key = { 0 };
    smart_str version = { 0 };
    smart_str author = { 0 };
    smart_str created_at = { 0 };
    smart_str status = { 0 };

    get_deploy_hash_key (&redis_key, atoi (deploy_id));

    get_cache_to_json (version);
    get_cache_to_json (author);
    get_cache_to_json (created_at);
    get_cache_to_json (status);

    char *json_encoded = cJSON_Print (json_ret);
    send_normal_request (req, json_encoded);

    smart_str_free (&redis_key);
    smart_str_free (&version);
    smart_str_free (&author);
    smart_str_free (&created_at);
    smart_str_free (&status);
    cJSON_Delete (json_ret);
    free (json_encoded);
}

void deploy_show (struct evhttp_request *req, void *arg) {
    const char *orig_uri = "/api/deploy";
    int orig_uri_len = strlen (orig_uri);
    char *decode_uri = strdup ((char *) evhttp_request_uri (req));
    if (strcmp (decode_uri, orig_uri) == 0) {
        deploy_show_all (req);
    } else {
        if (decode_uri[orig_uri_len] != '/' || strlen (decode_uri) == orig_uri_len + 1) {
            send_bad_request (req, "bad request");
        }
        char *task_id = strdup (decode_uri + orig_uri_len + 1);
        deploy_show_single (req, task_id);
        free (task_id);
    }
    free (decode_uri);
}

static void deploy_create_callback (void *data, int size, void *addition) {
    struct deploy_create_params *params = (struct deploy_create_params *) addition;
    char deploy_id[16] = { 0 };
    sprintf (deploy_id, "%d", params->id);
    smart_str redis_key = { 0 };
    smart_str_appendl (&redis_key, DEPLOY_LOG_PREFIX, strlen (DEPLOY_LOG_PREFIX));
    smart_str_appendl (&redis_key, deploy_id, strlen (deploy_id));
    smart_str_0 (&redis_key);
    ((char *) data)[size] = '\0';
    redis_append (redis_key.c, (char *) data);
    smart_str_free (&redis_key);
}

static void *thread_deploy_create (void *arg) {
    struct deploy_create_params *params = (struct deploy_create_params *) arg;
    char *deploy_script;
    int status;
    smart_str command = { 0 };

    ini_read_str (setting->ini, NULL, "DEPLOY_SCRIPT", &deploy_script, NULL);
    if (NULL == deploy_script) {
        // todo write log
        return NULL;
    }
    // save to redis
    push_deploy_to_list (params->id);

    char fmt_time[20] = { 0 };
    get_format_timestamp (fmt_time, sizeof (fmt_time));

    smart_str redis_key = { 0 };
    get_deploy_hash_key (&redis_key, params->id);

    redis_hash_set (redis_key.c, "author", params->author);
    redis_hash_set (redis_key.c, "version", params->version);
    redis_hash_set (redis_key.c, "status", DEPLOY_STATUS_RUNNING);
    redis_hash_set (redis_key.c, "created_at", fmt_time);

    smart_str_appendl (&command, deploy_script, strlen (deploy_script));
    smart_str_appendl (&command, " ", 1);
    smart_str_appendl (&command, params->version, strlen (params->version));
    smart_str_0 (&command);
    status = run_process (command.c, MODE_CATCH_MERGE, deploy_create_callback, NULL, arg);

    if (WIFEXITED (status)) {
        redis_hash_set (redis_key.c, "status", DEPLOY_STATUS_SUCCESS);
    } else {
        redis_hash_set (redis_key.c, "status", DEPLOY_STATUS_FAILURE);
    }

    smart_str_free (&command);
    smart_str_free (&redis_key);
    free (deploy_script);
    free (params->author);
    free (params->version);
    free (params);
    params = NULL;
}

void deploy_create (struct evhttp_request *req, void *arg) {
    const char *orig_uri = "/api/deploy";
    int orig_uri_len = strlen (orig_uri);
    char *decode_uri = strdup ((char *) evhttp_request_uri (req));
    smart_str body = { 0 };
    if (strcmp (decode_uri, orig_uri) == 0) {
        get_buffer_from_req (&body, req);

        cJSON *json, *json_ver, *json_author;
        json = cJSON_Parse (body.c);
        if (!json) {
            send_bad_request (req, "params error");
            goto end;
        }

        json_ver = cJSON_GetObjectItem (json, "version");
        if (!json_ver) {
            send_bad_request (req, "params error");
            goto end;
        }

        json_author = cJSON_GetObjectItem (json, "author");
        if (!json_author) {
            send_bad_request (req, "params error");
            goto end;
        }
        // return json
        char fmt_time[20] = { 0 };
        get_format_timestamp (fmt_time, sizeof (fmt_time));

        int deploy_id = get_deploy_id ();
        if (-1 == deploy_id) {
            send_internal_request (req, "get deploy id failure");
            goto end;
        }

        cJSON *json_ret = cJSON_CreateObject ();
        cJSON_AddItemToObject (json_ret, "id", cJSON_CreateNumber (deploy_id));
        cJSON_AddItemToObject (json_ret, "version", cJSON_CreateString (json_ver->valuestring));
        cJSON_AddItemToObject (json_ret, "author", cJSON_CreateString (json_author->valuestring));
        cJSON_AddItemToObject (json_ret, "log_url", cJSON_CreateString ("http://xxx.xx"));
        cJSON_AddItemToObject (json_ret, "create_at", cJSON_CreateString (fmt_time));
        cJSON_AddItemToObject (json_ret, "status", cJSON_CreateString ("running"));
        char *json_encoded = cJSON_Print (json_ret);

        struct deploy_create_params *thread_params = malloc (sizeof (struct deploy_create_params));
        thread_params->author = strdup (json_author->valuestring);
        thread_params->version = strdup (json_ver->valuestring);
        thread_params->id = deploy_id;

        pthread_t tid;
        pthread_create (&tid, NULL, thread_deploy_create, thread_params);
        send_normal_request (req, json_encoded);

        free (json_encoded);
        cJSON_Delete (json);
        cJSON_Delete (json_ret);
    } else {
        send_bad_request (req, "bad request");
    }
  end:
    smart_str_free (&body);
    free (decode_uri);
}

void fire_show (struct evhttp_request *req, void *arg) {
    const char *orig_uri = "/api/fire";
    int orig_uri_len = strlen (orig_uri);
    char *decode_uri = strdup ((char *) evhttp_request_uri (req));
    if (strcmp (decode_uri, orig_uri) == 0) {
        // todo: show fire list
    } else {
        if (decode_uri[orig_uri_len] != '/' || strlen (decode_uri) == orig_uri_len + 1) {
            // todo: send 400 page
        }
        char *task_id = strdup (decode_uri + orig_uri_len + 1);
        // todo
        free (task_id);
    }
    free (decode_uri);

}

void fire_create (struct evhttp_request *req, void *arg) {
    const char *orig_uri = "/api/fire";
    int orig_uri_len = strlen (orig_uri);
    char *decode_uri = strdup ((char *) evhttp_request_uri (req));
    if (strcmp (decode_uri, orig_uri) == 0) {
        // todo: show deploy list
    } else {
        // todo: send 400 page
    }
    free (decode_uri);
}

void log_show (struct evhttp_request *req, void *arg) {
    const char *orig_uri = "/api/fire";
    int orig_uri_len = strlen (orig_uri);
    char *decode_uri = strdup ((char *) evhttp_request_uri (req));
    if (strcmp (decode_uri, orig_uri) == 0) {
        // todo: show deploy list
    } else {
        // todo: send 400 page
    }
    free (decode_uri);
}

void status_show (struct evhttp_request *req, void *arg) {
    const char *orig_uri = "/api/log";
    int orig_uri_len = strlen (orig_uri);
    char *decode_uri = strdup ((char *) evhttp_request_uri (req));
    if (strcmp (decode_uri, orig_uri) == 0) {
        // todo: show deploy list
    } else {
        // todo: send 400 page
    }
    free (decode_uri);
}

#include <event2/event.h>
#include <stdio.h>

static void log_callback(int severity, const char *msg)
{
    const char *s;

    switch (severity) {
        case _EVENT_LOG_DEBUG: s = "debug"; break;
        case _EVENT_LOG_MSG:   s = "msg";   break;
        case _EVENT_LOG_WARN:  s = "warn";  break;
        case _EVENT_LOG_ERR:   s = "error"; break;
        default:               s = "?";     break; /* never reached */
    }
    printf("[%s] %s\n", s, msg);
}

static void fatal_log_callback(int errno)
{
    printf("errno(%d)",errno);
}

void set_logging(void)
{
    event_set_log_callback(log_callback);

    event_set_fatal_callback(fatal_log_callback);
}

int main()
{
    set_logging();
    return 0;
}

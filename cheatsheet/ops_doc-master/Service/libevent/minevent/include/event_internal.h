#ifndef _MIN_EVENT_INTERNAL_H_
#define _MIN_EVENT_INTERNAL_H_

#ifdef __cplusplus
extern "C" {
#endif

    TAILQ_HEAD (event_list, event);

    struct event_base {
        const struct eventop *evsel;
        void *evbase;

        int event_count;        //所有事件数
        int event_count_active; //就绪事件数

        struct event_list **activequeues;   // 就绪队列(下标为优先级)
        int nactivequeues;

        struct event_list eventqueue;   // 事件队列(保存所有的注事件)
        struct timeval event_tv;

         RB_HEAD (event_tree, event) timetree;
    };

#ifdef __cplusplus
}
#endif
#endif

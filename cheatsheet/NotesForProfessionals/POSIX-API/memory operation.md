---
title: 内存操作
comments: true
---

# 修改数据段大小

  #include <unistd.h>
  int brk(void *addr);
  void *sbrk(intptr_t increment);

# 设置malloc参数

    int mallopt(int param, int value);

# 内存分配和释放

    #include <stdlib.h>
    void *malloc(size_t size);
    void free(void *ptr);
    void *calloc(size_t nmemb, size_t size);
    void *realloc(void *ptr, size_t size);
    void *reallocarray(void *ptr, size_t nmemb, size_t size);

<!--more-->

# malloc状态

    #include <malloc.h>
    void* malloc_get_state(void);
    int malloc_set_state(void *state);

# 堆顶释放

    int malloc_trim(size_t pad);

# 分配信息

    struct mallinfo {
        int arena;     /* Non-mmapped space allocated (bytes) */
        int ordblks;   /* Number of free chunks */
        int smblks;    /* Number of free fastbin blocks */
        int hblks;     /* Number of mmapped regions */
        int hblkhd;    /* Space allocated in mmapped regions (bytes) */
        int usmblks;   /* Maximum total allocated space (bytes) */
        int fsmblks;   /* Space in freed fastbin blocks (bytes) */
        int uordblks;  /* Total allocated space (bytes) */
        int fordblks;  /* Total free space (bytes) */
        int keepcost;  /* Top-most, releasable space (bytes) */
    };
    struct mallinfo mallinfo(void);
    int malloc_info(int options, FILE *stream);
    void malloc_stats(void);

# 还可分配大小

    size_t malloc_usable_size (void *ptr);

# 内存分配钩子函数

    #include <malloc.h>
    void *(*__malloc_hook)(size_t size, const void *caller);
    void *(*__realloc_hook)(void *ptr, size_t size, const void *caller);
    void *(*__memalign_hook)(size_t alignment, size_t size, const void *caller);
    void (*__free_hook)(void *ptr, const void *caller);
    void (*__malloc_initialize_hook)(void);
    void (*__after_morecore_hook)(void);

# 对齐分配内存

    #include <stdlib.h>
    int posix_memalign(void **memptr, size_t alignment, size_t size);
    void *aligned_alloc(size_t alignment, size_t size);
    void *valloc(size_t size);

    #include <malloc.h>
    void *memalign(size_t alignment, size_t size);
    void *pvalloc(size_t size);

# 内存跟踪调试

    #include <mcheck.h>
    void mtrace(void);
    void muntrace(void);

# 堆移植性检查

    #include <mcheck.h>
    int mcheck(void (*abortfunc)(enum mcheck_status mstatus));
    int mcheck_pedantic(void (*abortfunc)(enum mcheck_status mstatus));
    void mcheck_check_all(void);
    enum mcheck_status mprobe(void *ptr);

# 栈上内存分配

    #include <alloca.h>
    void *alloca(size_t size);

会自动释放

# 获取页大小

    #include <unistd.h>
    int getpagesize(void);

# 内存策略

    long mbind(void *addr, unsigned long len, int mode, const unsigned long *nodemask, unsigned long maxnode, unsigned flags);
    long set_mempolicy(int mode, const unsigned long *nodemask, unsigned long maxnode);

# 内存使用建议

    int madvise(void *addr, size_t length, int advice);
    int posix_madvise(void *addr, size_t len, int advice);

# 内存驻留

    #include <unistd.h>
    #include <sys/mman.h>
    int mincore(void *addr, size_t length, unsigned char *vec);

# 内存锁

    #include <sys/mman.h>
    int mlock(const void *addr, size_t len);
    int mlock2(const void *addr, size_t len, int flags);
    int munlock(const void *addr, size_t len);
    int mlockall(int flags);
    int munlockall(void);

# 重新映射虚拟内存

    #define _GNU_SOURCE         /* See feature_test_macros(7) */
    #include <sys/mman.h>
    void *mremap(void *old_address, size_t old_size, size_t new_size, int flags, ... /* void *new_address */);

# 移动页

    long move_pages(int pid, unsigned long count, void **pages, const int *nodes, int *status, int flags);
    #include <numaif.h>
    long migrate_pages(int pid, unsigned long maxnode, const unsigned long *old_nodes, const unsigned long *new_nodes);

# NUMA

    #include <numa.h>
    cc ... -lnuma

    int numa_available(void);

    int numa_max_possible_node(void);
    int numa_num_possible_nodes();
    int numa_max_node(void);
    int numa_num_configured_nodes();
    struct bitmask *numa_get_mems_allowed(void);
    int numa_num_configured_cpus(void);
    struct bitmask *numa_all_nodes_ptr;
    struct bitmask *numa_no_nodes_ptr;
    struct bitmask *numa_all_cpus_ptr;
    int numa_num_task_cpus();
    int numa_num_task_nodes();
    int numa_parse_bitmap(char *line , struct bitmask *mask);
    struct bitmask *numa_parse_nodestring(const char *string);
    struct bitmask *numa_parse_nodestring_all(const char *string);
    struct bitmask *numa_parse_cpustring(const char *string);
    struct bitmask *numa_parse_cpustring_all(const char *string);
    long numa_node_size(int node, long *freep);
    long long numa_node_size64(int node, long long *freep);
    int numa_preferred(void);
    void numa_set_preferred(int node);
    int numa_get_interleave_node(void);
    struct bitmask *numa_get_interleave_mask(void);
    void numa_set_interleave_mask(struct bitmask *nodemask);
    void numa_interleave_memory(void *start, size_t size, struct bitmask *nodemask);
    void numa_bind(struct bitmask *nodemask);
    void numa_set_localalloc(void);
    void numa_set_membind(struct bitmask *nodemask);
    struct bitmask *numa_get_membind(void);

    void *numa_alloc_onnode(size_t size, int node);
    void *numa_alloc_local(size_t size);
    void *numa_alloc_interleaved(size_t size);
    void *numa_alloc_interleaved_subset(size_t size,  struct bitmask *nodemask); void *numa_alloc(size_t size);
    void *numa_realloc(void *old_addr, size_t old_size, size_t new_size);
    void numa_free(void *start, size_t size);

    int numa_run_on_node(int node);
    int numa_run_on_node_mask(struct bitmask *nodemask);
    int numa_run_on_node_mask_all(struct bitmask *nodemask);
    struct bitmask *numa_get_run_node_mask(void);

    void numa_tonode_memory(void *start, size_t size, int node);
    void numa_tonodemask_memory(void *start, size_t size, struct bitmask *nodemask);
    void numa_setlocal_memory(void *start, size_t size);
    void numa_police_memory(void *start, size_t size);
    void numa_set_bind_policy(int strict);
    void numa_set_strict(int strict);

    int numa_distance(int node1, int node2);

    int numa_sched_getaffinity(pid_t pid, struct bitmask *mask);
    int numa_sched_setaffinity(pid_t pid, struct bitmask *mask);
    int numa_node_to_cpus(int node, struct bitmask *mask);
    int numa_node_of_cpu(int cpu);

    struct bitmask *numa_allocate_cpumask();

    void numa_free_cpumask();
    struct bitmask *numa_allocate_nodemask();

    void numa_free_nodemask();
    struct bitmask *numa_bitmask_alloc(unsigned int n);
    struct bitmask *numa_bitmask_clearall(struct bitmask *bmp);
    struct bitmask *numa_bitmask_clearbit(struct bitmask *bmp, unsigned int n);
    int numa_bitmask_equal(const struct bitmask *bmp1, const struct bitmask *bmp2);
    void numa_bitmask_free(struct bitmask *bmp);
    int numa_bitmask_isbitset(const struct bitmask *bmp, unsigned int n);
    unsigned int numa_bitmask_nbytes(struct bitmask *bmp);
    struct bitmask *numa_bitmask_setall(struct bitmask *bmp);
    struct bitmask *numa_bitmask_setbit(struct bitmask *bmp, unsigned int n);
    void copy_bitmask_to_nodemask(struct bitmask *bmp, nodemask_t *nodemask)
    void copy_nodemask_to_bitmask(nodemask_t *nodemask, struct bitmask *bmp)
    void copy_bitmask_to_bitmask(struct bitmask *bmpfrom, struct bitmask *bmpto)
    unsigned int numa_bitmask_weight(const struct bitmask *bmp )

    int numa_move_pages(int pid, unsigned long count, void **pages, const
    int *nodes, int *status, int flags);
    int numa_migrate_pages(int pid, struct bitmask *fromnodes, struct bitmask *tonodes);

    void numa_error(char *where);

    extern int numa_exit_on_error;
    extern int numa_exit_on_warn;
    void numa_warn(int number, char *where, ...);

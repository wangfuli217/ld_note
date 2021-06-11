#ifndef STR_INCLUDE
#define STR_INCLUDE


extern char    *str_sub     (const char *s, ssize_t i, ssize_t j);
extern char    *str_dup     (const char *s, ssize_t i, ssize_t j, ssize_t n);
extern char    *str_cat     (const char *s1, ssize_t i1, ssize_t j1,
                             const char *s2, ssize_t i2, ssize_t j2);
/**
 * 参数表最后需要填NULL, 否则会导致不确定的结果
 */
extern char    *str_cat_v   (const char *s,...);
extern char    *str_reverse (const char *s, ssize_t i, ssize_t j);
extern char    *str_map     (const char *s, ssize_t i, ssize_t j,
                             const char *from, const char *to);

extern ssize_t str_pos      (const char *s, ssize_t i);
extern ssize_t str_len      (const char *s, ssize_t i, ssize_t j);
extern int     str_cmp      (const char *s1, ssize_t i1, ssize_t j1,
                             const char *s2, ssize_t i2, ssize_t j2);

extern ssize_t str_chr      (const char *s, ssize_t i, ssize_t j, int c);
extern ssize_t str_rchr     (const char *s, ssize_t i, ssize_t j, int c);
extern ssize_t str_upto     (const char *s, ssize_t i, ssize_t j, const char *set);
extern ssize_t str_rupto    (const char *s, ssize_t i, ssize_t j, const char *set);
extern ssize_t str_find     (const char *s, ssize_t i, ssize_t j, const char *str);
extern ssize_t str_rfind    (const char *s, ssize_t i, ssize_t j, const char *str);

extern ssize_t str_any      (const char *s, ssize_t i, const char *set);
extern ssize_t str_many     (const char *s, ssize_t i, ssize_t j, const char *set);
extern ssize_t str_rmany    (const char *s, ssize_t i, ssize_t j, const char *set);
extern ssize_t str_match    (const char *s, ssize_t i, ssize_t j, const char *str);
extern ssize_t str_rmatch   (const char *s, ssize_t i, ssize_t j, const char *str);



#endif /*STR_INCLUDE*/

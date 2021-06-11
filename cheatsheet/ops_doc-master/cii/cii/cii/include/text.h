#ifndef TEXT_INCLUDE
#define TEXT_INCLUDE

#define T text_t

typedef struct T {
	int         len;
	const char  *str;
} T;

typedef struct text_save_t *text_save_t;

extern  const T text_cset;
extern  const T text_ascii;
extern  const T text_ucase;
extern  const T text_lcase;
extern  const T text_digits;
extern  const T text_null;

extern  T       text_put(const char *str);
extern  char   *text_get(char *str, ssize_t size, T text);
extern  T       text_box(const char *str, ssize_t len);


extern  ssize_t text_pos(T text, ssize_t i);

extern  T       text_sub(T text, ssize_t i, ssize_t j);
extern  T       text_cat(T text1, T text2);
extern  T       text_dup(T text, int n);
extern  T       text_reverse(T text);
extern  T       text_map(T text, const T *from, const T *to);


extern  int     text_cmp(T text1, T text2);


extern  ssize_t text_chr(T text, ssize_t i, ssize_t j, int c);
extern  ssize_t text_rchr(T text, ssize_t i, ssize_t j, int c);
extern  ssize_t text_upto(T text, ssize_t i, ssize_t j, T set);
extern  ssize_t text_rupto(T text, ssize_t i, ssize_t j, T set);
extern  ssize_t text_any(T text, ssize_t i, T set);
extern  ssize_t text_many(T text, ssize_t i, ssize_t j, T set);
extern  ssize_t text_rmany(T text, ssize_t i, ssize_t j, T set);


extern  ssize_t text_find(T text, ssize_t i, ssize_t j, T str);
extern  ssize_t text_rfind(T text, ssize_t i, ssize_t j, T str);
extern  ssize_t text_match(T text, ssize_t i, ssize_t j, T str);
extern  ssize_t text_rmatch(T text, ssize_t i, ssize_t j, T str);


extern  text_save_t text_save(void);
extern  void        text_restore(text_save_t *save);

#undef T

#endif /*TEXT_INCLUDE*/

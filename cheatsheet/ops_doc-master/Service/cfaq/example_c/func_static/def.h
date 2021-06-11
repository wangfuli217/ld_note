#ifndef __DEF_H_
#define __DEF_H_

typedef void (*callback_t)(void);

typedef struct {
	callback_t cb;
} func_struct_s;

typedef func_struct_s func_struct_t;

#endif

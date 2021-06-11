#ifndef __SELFDEF_TYPES_H__
#define __SELFDEF_TYPES_H__

#ifdef __cplusplus
extern "C" {
#endif

#include "sys/types.h"

#ifndef TRUE
#define TRUE 1
#endif

#ifndef FALSE
#define FALSE 0
#endif

#ifndef SUCCESS
#define SUCCESS 0
#endif

#ifndef FAIL
#define FAIL 1
#endif

#ifndef OK
#define OK 0
#endif

#ifndef ERROR
#define ERROR 1
#endif

#ifndef NULL
#define NULL	 0
#endif

typedef unsigned char uint8;
typedef unsigned short uint16;
typedef unsigned int uint32;

typedef signed char int8;
typedef signed short int16;
typedef signed int int32;

#ifdef __cplusplus
}
#endif

#endif /* __SELFDEF_TYPES_H__ */


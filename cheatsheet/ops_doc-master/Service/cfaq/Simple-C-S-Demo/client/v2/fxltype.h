#ifndef _FXL_TYPE_H
#define _FXL_TYPE_H

#ifdef __cplusplus
extern "C" {
#endif //__cplusplus

#ifndef TRUE 
#define TRUE (1)
#endif //TRUE

#ifndef FALSE 
#define FALSE (0)
#endif //FALSE

typedef char s8;
typedef short s16;
typedef int s32,BOOL32;
typedef unsigned char u8;
typedef unsigned short u16;
typedef unsigned long u32;
typedef unsigned long long u64;

#ifdef __cplusplus
}
#endif  //__cplusplus

#endif  //_FXL_TYPE_H

#ifndef UTILS_INCLUDED
#define UTILS_INCLUDED

/* Guard C code in C++ headers */
#ifdef  __cplusplus
# define BEGIN_DECLS  extern "C" {
# define END_DECLS    }
#else
# define BEGIN_DECLS
# define END_DECLS
#endif

/* Use to make macro statement more secure*/
#  define STMT_START  do
#  define STMT_END    while (0)

#define FOUND 1
#define NOT_FOUND 0

#endif

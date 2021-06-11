#ifndef __TYPE_DEF_H_
#define __TYPE_DEF_H_

/// define m
#define lnum		5
#define sbits		6
#define ebits		8
#define sbitsize	( 1 << sbits )
#define ebitsize	( 1 << ebits )
#define sMask		( sbitsize- 1)
#define eMask		( ebitsize -1)

/// 数组
#define SAFE_ARR_DELETE( a )   if((a)!= NULL) {  delete [] a; a = NULL;} 
/// 指针
#define SAFE_DELETE( a )	   if((a)!= NULL) {  delete  a ; a = NULL; }

#endif 
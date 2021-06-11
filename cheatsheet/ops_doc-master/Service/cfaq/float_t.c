#include <stdio.h>
#include <float.h>
int main (void) {
  printf("float:\n" );
    printf("FLT_DIG = %d\n",FLT_DIG );
    printf("FLT_EPSILON = %.10e\n",FLT_EPSILON );
    printf("FLT_MANT_DIG = %.10e\n",FLT_MANT_DIG );
    // printf("FLT_RADIX = %d\n",FLT_RADIX );
    // printf("FLT_ROUNDS = %d\n",FLT_ROUNDS );
    printf("FLT_MAX = %.10e\n",FLT_MAX );
    printf("FLT_MIN = %.10e\n",FLT_MIN );
    printf("FLT_MAX_10_EXP = %.10e\n",FLT_MAX_10_EXP );
    printf("FLT_MIN_10_EXP = %.10e\n",FLT_MIN_10_EXP );
    printf("FLT_MAX_EXP = %.10e\n",FLT_MAX_EXP );
    printf("FLT_MIN_EXP = %.10e\n",FLT_MIN_EXP );
  
    printf("double:\n" );
    printf("DBL_DIG = %d\n",DBL_DIG );
    printf("DBL_EPSILON = %.10e\n",DBL_EPSILON );
    printf("DBL_MANT_DIG = %.10e\n",DBL_MANT_DIG );
    printf("DBL_MAX = %.10e\n",DBL_MAX );
    printf("DBL_MIN = %.10e\n",DBL_MIN );
    printf("DBL_MAX_10_EXP = %.10e\n",DBL_MAX_10_EXP );
    printf("DBL_MIN_10_EXP = %.10e\n",DBL_MIN_10_EXP );
    printf("DBL_MAX_EXP = %.10e\n",DBL_MAX_EXP );
    printf("DBL_MIN_EXP = %.10e\n",DBL_MIN_EXP );
  
    printf("long double:\n" );
    printf("LDBL_DIG = %d\n",LDBL_DIG );
    printf("LDBL_EPSILON = %.10e\n",LDBL_EPSILON );
    printf("LDBL_MANT_DIG = %.10e\n",LDBL_MANT_DIG );
    printf("LDBL_MAX = %.e\n",LDBL_MAX );
    printf("LDBL_MIN = %.e\n",LDBL_MIN );
    printf("LDBL_MAX_10_EXP = %.10e\n",LDBL_MAX_10_EXP );
    printf("LDBL_MIN_10_EXP = %.10e\n",LDBL_MIN_10_EXP );
    printf("LDBL_MAX_EXP = %.10e\n",LDBL_MAX_EXP );
    printf("LDBL_MIN_EXP = %.10e\n",LDBL_MIN_EXP );
    
    return 0;
}
/*
//float

#define FLT_DIG      (6)  //float小数点后面精确的位数
#define FLT_EPSILON  1.19209290E-07F //小的正数,float的0跨度值
#define FLT_MANT_DIG 24 //尾数中的位数
#define FLT_RADIX    (2) //进制基数

//Defines the way floating-point numbers are rounded.
//-1 indeterminable
// 0 toward zero
// 1 to nearest
// 2 toward positive infinity
// 3 toward negative infinity

#define FLT_ROUNDS      //加法舍入
#define FLT_MAX         //最大值
#define FLT_MIN         //最小值
#define FLT_MAX_10_EXP  //最大10进制指数
#define FLT_MIN_10_EXP  //最小10进制指数
#define FLT_MAX_EXP     //最大2进制指数 基于FLT_RADIX
#define FLT_MIN_EXP     //最小2进制指数 基于FLT_RADIX



//double
#define DBL_DIG         //double 小数点后面精确的位数
#define DBL_EPSILON     //小的正数 ,double的0跨度值
#define DBL_MANT_DIG    //尾数中的位数
#define DBL_MAX         //最大值
#define DBL_MAX_10_EXP  //最大10进制指数
#define DBL_MAX_EXP     //最大2进制指数
#define DBL_MIN         //最小值
#define DBL_MIN_10_EXP  //最小10进制指数
#define DBL_MIN_EXP     //最小2进制指数

//long double
#define LDBL_DIG         //long double小数点后面精确的位数
#define LDBL_EPSILON     //小的正数,long double的0跨度值
#define LDBL_MANT_DIG    //尾数中的位数

#define LDBL_MAX         //最大值
#define LDBL_MIN         //最小值
#define LDBL_MAX_10_EXP  //最大10进制指数
#define LDBL_MIN_10_EXP  //最小10进制指数
#define LDBL_MAX_EXP     //最大2进制指数
#define LDBL_MIN_EXP //最小2进制指数
*/
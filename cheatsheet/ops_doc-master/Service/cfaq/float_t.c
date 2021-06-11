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

#define FLT_DIG      (6)  //floatС������澫ȷ��λ��
#define FLT_EPSILON  1.19209290E-07F //С������,float��0���ֵ
#define FLT_MANT_DIG 24 //β���е�λ��
#define FLT_RADIX    (2) //���ƻ���

//Defines the way floating-point numbers are rounded.
//-1 indeterminable
// 0 toward zero
// 1 to nearest
// 2 toward positive infinity
// 3 toward negative infinity

#define FLT_ROUNDS      //�ӷ�����
#define FLT_MAX         //���ֵ
#define FLT_MIN         //��Сֵ
#define FLT_MAX_10_EXP  //���10����ָ��
#define FLT_MIN_10_EXP  //��С10����ָ��
#define FLT_MAX_EXP     //���2����ָ�� ����FLT_RADIX
#define FLT_MIN_EXP     //��С2����ָ�� ����FLT_RADIX



//double
#define DBL_DIG         //double С������澫ȷ��λ��
#define DBL_EPSILON     //С������ ,double��0���ֵ
#define DBL_MANT_DIG    //β���е�λ��
#define DBL_MAX         //���ֵ
#define DBL_MAX_10_EXP  //���10����ָ��
#define DBL_MAX_EXP     //���2����ָ��
#define DBL_MIN         //��Сֵ
#define DBL_MIN_10_EXP  //��С10����ָ��
#define DBL_MIN_EXP     //��С2����ָ��

//long double
#define LDBL_DIG         //long doubleС������澫ȷ��λ��
#define LDBL_EPSILON     //С������,long double��0���ֵ
#define LDBL_MANT_DIG    //β���е�λ��

#define LDBL_MAX         //���ֵ
#define LDBL_MIN         //��Сֵ
#define LDBL_MAX_10_EXP  //���10����ָ��
#define LDBL_MIN_10_EXP  //��С10����ָ��
#define LDBL_MAX_EXP     //���2����ָ��
#define LDBL_MIN_EXP //��С2����ָ��
*/
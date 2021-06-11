#include <locale.h>
#include <stdio.h>
int main(void)
{
    struct lconv locale_structure;
    struct lconv *locale_ptr=&locale_structure;
    locale_ptr=localeconv();
    printf("Decimal point: %s",locale_ptr->decimal_point);
    printf("Thousands Separator: %s",locale_ptr->thousands_sep);
    printf("Grouping: %s",locale_ptr->grouping);
    printf("International Currency Symbol: %s",locale_ptr->int_curr_symbol);
    printf("Currency Symbol: %s",locale_ptr->currency_symbol);
    printf("Monetary Decimal Point: %s",locale_ptr->mon_decimal_point);
    printf("Monetary Thousands Separator: %s",locale_ptr->mon_thousands_sep);
    printf("Monetary Grouping: %s",locale_ptr->mon_grouping);
    printf("Monetary Positive Sign: %s",locale_ptr->positive_sign);
    printf("Monetary Negative Sign: %s",locale_ptr->negative_sign);
    printf("Monetary Intl Decimal Digits: %c",locale_ptr->int_frac_digits);
    printf("Monetary Decimal Digits: %c",locale_ptr->frac_digits);
    printf("Monetary + Precedes: %c",locale_ptr->p_cs_precedes);
    printf("Monetary + Space: %c",locale_ptr->p_sep_by_space);
    printf("Monetary - Precedes: %c",locale_ptr->n_cs_precedes);
    printf("Monetary - Space: %c",locale_ptr->n_sep_by_space);
    printf("Monetary + Sign Posn: %c",locale_ptr->p_sign_posn);
    printf("Monetary - Sign Posn: %c",locale_ptr->n_sign_posn);
    
   struct lconv * lc;

   setlocale(LC_MONETARY, "it_IT");
   lc = localeconv();
   printf("Local Currency Symbol: %s\n",lc->currency_symbol);
   printf("International Currency Symbol: %s\n",lc->int_curr_symbol);

   setlocale(LC_MONETARY, "en_US");
   lc = localeconv();
   printf("Local Currency Symbol: %s\n",lc->currency_symbol);
   printf("International Currency Symbol: %s\n",lc->int_curr_symbol);

   setlocale(LC_MONETARY, "en_GB");
   lc = localeconv();
   printf ("Local Currency Symbol: %s\n",lc->currency_symbol);
   printf ("International Currency Symbol: %s\n",lc->int_curr_symbol);

   printf("Decimal Point = %s\n", lc->decimal_point);
}

/*
#define LC_ALL        //设置下面的所有选项。
#define LC_COLLATE    //影响 strcoll 和 strxfrm 函数。
#define LC_CTYPE      //影响所有字符函数。
#define LC_MONETARY   //影响 localeconv 函数提供的货币信息。
#define LC_NUMERIC    //影响 localeconv 函数提供的小数点格式化和信息。
#define LC_TIME //影响 strftime 函数。
*/
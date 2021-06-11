#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include"text.h"

static
void
_usage()
{

    printf("Usage: text i j\n");
}

int
main(int argc, char *argv[])
{
    int i, j;
    char * str;
    int size;
    int bl;

	text_save_t mark = text_save();

    if(4 != argc){
        _usage();
    }


    i = atoi(argv[2]);
    j = atoi(argv[3]);

    text_t ta1 = text_box(argv[1], strlen(argv[1]));
    printf("text_box ta1 len:%d\n", ta1.len);

    size = text_pos(ta1, -3);
    printf("text_pos:%d\n", size);

    text_t  tp = text_put("thrallandjainasittinginatreekissing");
    printf("text_put:%.*s\n", tp.len, tp.str);

    text_t  tsub = text_sub(tp, i, j);
    printf("text_sub:%.*s\n", tsub.len, tsub.str);

    char *sget = text_get(NULL, tsub.len, tsub);
    printf("sget:%s\n", sget);

    text_t  tdup0 = text_dup(tp, 0);
    text_t  tdup1 = text_dup(tp, 1);
    text_t  tdup2 = text_dup(tsub, 2);
    printf("text_null.str addr:%p, tdup0.str addr:%p\n"
           "tp.str addr:%p,        tdup1.str addr:%p\n"
           "tsub.str addr:%p,      tdup2.str addr:%p\n",
           text_null.str, tdup0.str,
           tp.str, tdup1.str,
           tsub.str, tdup2.str);

    text_t  tcat0 = text_cat(tdup0, tdup2);
    text_t  tcat1 = text_cat(tsub, tdup2);
    text_t  tcat2 = text_cat(ta1, tp);
    printf("tcat0.str addr:%p\n"
           "tcat1.str addr:%p\n"
           "tcat2.str addr:%p\n",
           tcat0.str, tcat1.str, tcat2.str);

    text_t  trev  = text_reverse(tp);
    printf("text_reverse\n"
            "\ttp:%.*s\n"
            "\ttrev:%.*s\n", tp.len, tp.str, trev.len, trev.str);

    text_t  mapfrom = text_put("abcdefghij");
    text_t  mapto   = text_put("1234567890");

    text_t  tmap0 = text_map(tp, 
                            &mapfrom,
                            &mapto);
    text_t  tmap1 = text_map(trev, NULL, NULL);
    printf("text_map\n"
            "\ttmap0:%.*s\n"
            "\ttmap1:%.*s\n", tmap0.len, tmap0.str, tmap1.len, tmap1.str);

    text_t  tpp = text_put("thrallandjainasittinginatreekissing");
    int cmp0 = text_cmp(tp, trev);
    int cmp1 = text_cmp(trev, tp);
    int cmp2 = text_cmp(tpp, tp);
    printf("text_cmp\n"
            "\tcmp0:%d\n"
            "\tcmp1:%d\n"
            "\tcmp2:%d\n", cmp0, cmp1, cmp2);

    size = text_chr(ta1, 0, -1, 'x');
    printf("text_chr:%d\n", size);
    size = text_rchr(ta1, 0, -1, 'x');
    printf("text_rchr:%d\n", size);


    text_t tset0 = text_put("las");
    text_t tset1 = text_put("xoz");
    printf("tp:%.*s\n", tp.len, tp.str);
    size = text_upto(tp, 0, -1, tset0);
    printf("\ttset0:%.*s, text_upto:%d\n", tset0.len, tset0.str, size);
    size = text_upto(tp, 0, -1, tset1);
    printf("\ttset1:%.*s, text_upto:%d\n", tset1.len, tset1.str, size);
    size = text_rupto(tp, 0, -1, tset0);
    printf("\ttset0:%.*s, text_rupto:%d\n", tset0.len, tset0.str, size);
    size = text_rupto(tp, 0, -1, tset1);
    printf("\ttset1:%.*s, text_rupto:%d\n", tset1.len, tset1.str, size);

    text_t tstr0 = text_put("na");
    text_t tstr1 = text_put("tree");
    text_t tstr2 = text_put("kissing");
    printf("tp:%.*s\n", tp.len, tp.str);
    size = text_find(tp, 0, -1, tstr0);
    printf("\ttstr0:%.*s, text_find:%d\n", tstr0.len, tstr0.str, size);
    size = text_find(tp, 0, -1, tstr1);
    printf("\ttstr1:%.*s, text_find:%d\n", tstr1.len, tstr1.str, size);
    size = text_find(tp, 0, -1, tstr2);
    printf("\ttstr2:%.*s, text_find:%d\n", tstr2.len, tstr2.str, size);
    

    size = text_rfind(tp, 0, -1, tstr0);
    printf("\ttstr0:%.*s, text_rfind:%d\n", tstr0.len, tstr0.str, size);
    size = text_rfind(tp, 0, -1, tstr1);
    printf("\ttstr1:%.*s, text_rfind:%d\n", tstr1.len, tstr1.str, size);
    size = text_rfind(tp, 0, -1, tstr2);
    printf("\ttstr2:%.*s, text_rfind:%d\n", tstr2.len, tstr2.str, size);

    size = text_any(tp, 3, tstr0);
    printf("tstr0:%.*s, text_any:%d\n", tstr0.len, tstr0.str, size);
    size = text_any(tp, 3, tstr1);
    printf("tstr1:%.*s, text_any:%d\n", tstr1.len, tstr1.str, size);


    text_t tm0 = text_put("thrall");
    text_t tm1 = text_put("kisng");
    text_t tm2 = text_put("kissing");
    size = text_many(tp, 0, -1, tm0);
    printf("tm0:%.*s, text_many:%d\n", tm0.len, tm0.str, size);
    size = text_rmany(tp, 0, -1, tm1);
    printf("tm1:%.*s, text_rmany:%d\n", tm1.len, tm1.str, size);

    size = text_match(tp, 0, -1, tm0);
    printf("tm0:%.*s, text_match:%d\n", tm0.len, tm0.str, size);
    size = text_rmatch(tp, 0, -1, tm1);
    printf("tm1:%.*s, text_rmatch:%d\n", tm1.len, tm1.str, size);
    size = text_rmatch(tp, 0, -1, tm2);
    printf("tm2:%.*s, text_rmatch:%d\n", tm2.len, tm2.str, size);

	text_restore(&mark);
    return 0;
}

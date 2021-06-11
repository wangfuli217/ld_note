getopt(man getopt)
{

moosefs memcached redis

extern char *optarg;  
int getopt(int argc, char * const argv[], const char *optstring);
#include <unistd.h> 

#    while( (opt = getopt(argc, argv, "ab:c:de::")) != -1 )   
#    {  
#        switch( opt )  
#        {  
#            case 'a' :  break;            
#            case 'b' :  printf("parm = %s", optarg); break;  
#            case 'c' :  break;  
#            case 'd' :  break;  
#  
#            case 'e' :    
#                    if(optarg)  
#                    {  
#                        printf("option e has parm\n");    
#                    }  
#                    break;  
#  
#            default : //出现了不是选项的字符  
#        }  
#    }  

}

getopt_long()
{
dnsmasq

}

getsubopt(man getsubopt)
{
memcached
    从上面代码可以看到，要想使用getsubopt就需要使用定义一个二维字符数组。数组里面的字符串就是命令行参数里面的子选项值。
如果查找到了一个子选项，那么getsubopt函数返回这个子选项在二维数组里面的下标值。而getsubopt的参数valuep则会指向对应
子选项的参数值。

int getsubopt(char **optionp, char * const *tokens, char **valuep); 
#include <stdlib.h>  

/test -o ro,rw,name=main.c


#enum {  
#        RO_OPT = 0,  
#        RW_OPT,  
#        NAME_OPT  
#    };  
#    char *const token[] = {  
#        [RO_OPT]   = "ro",  
#        [RW_OPT]   = "rw",  
#        [NAME_OPT] = "name",  
#        NULL  
#    };  
#    char *subopts;  
#char *value;  
#int err = 0;  
#    int opt;  
#  
#    while ((opt = getopt(argc, argv, "aeo:")) != -1) {  
#        switch (opt) {  
#        case 'a': break;  
#        case 'e': break;  
#  
#        case 'o':  
#            subopts = optarg;//optarg指向参数字符串的开始位置  
#  
#            while (*subopts != '\0' && !err) {  
#                //getsubopt会修改subopts的值  
#                switch (getsubopt(&subopts, token, &value)) {  
#                case RO_OPT:  
#                    if( value )  
#                        printf("ro parm = %s\n", value);  
#                    else  
#                        printf("ro\n");  
#                    break;  
#  
#                case RW_OPT:  
#                    if( value )  
#                        printf("rw parm = %s\n", value);  
#                    else  
#                        printf("rw\n");  
#                    break;  
#                    break;  
#  
#                case NAME_OPT:  
#                    if( value )  
#                        printf("name parm = %s\n", value);  
#                    else  
#                        printf("name\n");  
#                    break;  
#              
#                default:  
#                    err = 1;  
#                    break;  
#                }  
#            }  
#        }  
#    }

}

moosefs配置文件解释简单明了，更容易模块化，不支持多实例。
redis  配置文件解释依赖sds函数处理，这要求对sds操作功能明了，绑定在server(RedisServer)全局对象上，模块化较差，支持多实例。
dnsmasq将配置文件和命令行选项通过one_opt达到统一处理，其中关键是getopt和getopt_long函数实例很好。
       绑定在daemon全局变量上，模块化较差，支持多实例。
atop和toybox：处理对象为/proc下的文件。多使用sscanf直接进行解析。       

moosefs(cfg)
{
1. isspace包括：空格(' ')、form-feed('\f')、新行('\n')、回车('\r')和水平制表符('\t')、垂直制表符('\v')。
2. 行内空格字符为' '和'\t'，行内非空格字符为>32和<127的所有字符。

    先将字符串(文件的一行数据fgets)解释成 name 和 value 两个字符串；然后根据 name 名称，将 value 解释成定义的类型。
name 和 value 字符串的开始位置使用' '和'\t'进行判定、结束位置使用>32和<127的字符进行判定。其中又通过 '=' 对两个
字符串进行分割。将解释出来的name和value存放到paramstr结构体中。
    value字符串以'\0'，'\r'，'\n'，'#'表示行解释中value的结束。

关键字：'\0','\r','\n','#','\t',' ',以及32 127 fgets while.
原则：  如果name不存在，添加到链表中；如果name已经存在，从链表中释放name和value，将新添加到覆盖原先添加的。
}

redis(config)
{

主要函数为loadServerConfigFromString和sdssplitlen。

    通过sds.sdscat先将整个文件保存到一个字符串中。然后使用sdssplitlen将文件字符串按'\n'分割成多个sds对象(每个sds对象对应一行)。
然后使用sdstrim对sds对象进行修正，再使用sds.sdssplitargs(lines[i],&argc)将行sds解释成多个sds字符串(argc和argv).最后根据
argv[0]对后续的字符串进行解释。

关键字：'\r','\n','\t','\0', strcasecmp
原则：  如果argv[0]不存在，直接解释成server全局结构对应的关键字；如果argv[0]存在，可以多实例的添加到链表中，不可以多实例的覆盖原先添加的。

}

dnsmasq(option)
{
    主要函数为read_opts和read_file。read_opts解释命令行方式的参数输入，read_file解释从配置文件方式的参数输入，最后都在one_opt
函数中，实现参数最终解释。read_opts中有getopt_long或者getopt的帮助，所以解释起来比较简单。而read_file围绕start,arg和option三个参数
进行分析，其中start与opts[].name相等既得到了option,又可以得到是否有选项，arg就是后续首个有效参数。

关键字：getopt, getopt_long, usage
原则：  如果option不存在，直接解释成daemon全局结构对应的关键字；如果option存在，可以多实例的添加到链表中，不可以多实例的覆盖原先添加的。

}

atop(toybox)
{
    主要使用fopen,fgets与sscanf相结合的方式实现。
    主要用于读取/proc下面的文件。
}

/****编译器前端*********************************************************************************
该程序主要完成以下任务:
|--------|		|--------|		|--------|		|--------|
|源程序	 |----->|词法分析|----->|语法分析|----->|代码生成|----->filename_ir.txt
|--------|		|--------|		|--------|		|--------|
值得注意的是，所生成的中间代码即filename_ir.txt中的内容，需要参考栈式计算机的汇编指令:
LOAD 	D		将D中的内容加载的操作数栈。
LOADI 	N		将常量N压入操作数栈。
STO		D		将操作数栈栈顶单元内容存入D，且栈顶单元内容保持不变。
POP				将栈顶内容弹出
STOP			停止执行
BR		lab		无条件转移到lab
BRF		lab		检查栈顶单元的逻辑值，若为假则转移到lab
*********************************************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

#define KEYWORD_SUM     8   //定义保留字数量
#define MAX_VAR_TABLE   500 //定义符号表容量

/****数据结构*********************************************************************************/
struct
{
    char name[8];
    int addess;
} vartable[MAX_VAR_TABLE];


/****全局变量*********************************************************************************/

    //系统保留字
    char * keyword[KEYWORD_SUM]={"if","else","for","while","do","int","read","write"};

    //单分界符
    char singleword[50]="+-*\(){};,:";

    //双分界符首字符
    char doubleword[10]="><=!";

    //输入输出文件名
    char scanin[300],scanout[300];

    //指向输入输出文件的指针
    FILE * fin;
	FILE * fout;

    //语法分析读入文件
    FILE * fp;

    //单词符号
    char token[20];

    //单词值
    char token1[40];

    int vartablep=0,labelp=0,datap=0;

    char codeout[300];

/****函数定义*********************************************************************************/

    //插入符号表
    int name_def(char * name);

    //查询符号表返回地址
    int look_up(char * name , int * address);

    //词法分析
    int LexicalAnalysis();

    //语法分析
    int SyntaxAnalysis();

    int Program();
    int Declaration_List();
    int Statement_List();
    int Declaration_Stat();
    int Statement();
    int If_Stat();
    int While_Stat();
    int Read_Stat();
    int Write_Stat();
    int Compound_Stat();
    int Expression_Stat();
    int Expression();
    int Bool_Expr();
    int Additive_Expr();
    int Term();
    int Factor();


/****函数实现*********************************************************************************/


    /******************************************************************************************
    *
    *   name_def()
    *
    *   插入符号表
    */
    int name_def(char * name)
    {
        int i,es=0;
        if(vartablep>=MAX_VAR_TABLE)
        {
            //符号表溢出
            return 21;
        }
        for(i=vartablep-1;i==0;i--)
        {
            if(strcmp(vartable[i].name,name)==0)
            {
                //变量重复声明
                es=22;
                break;
            }
        }
        if(es>0)
        {
            return es;
        }
        strcpy(vartable[vartablep].name,name);
        vartable[vartablep].addess=datap;
        datap++;
        vartablep++;
        return es;
    }

    /******************************************************************************************
    *
    *   look_up()
    *
    *   查询符号表返回地址
    */
    int look_up(char * name , int * address)
    {
        int i=0;
        int es=0;
        for(;i<vartablep;i++)
        {
            if(strcmp(vartable[i].name,name)==0)
            {
                * address=vartable[i].addess;
                return es;
            }
        }
        //变量没有声明
        es=23;
        return es;
    }






    /******************************************************************************************
    *
    *   LexicalAnalysis()
    *
    *   词法分析
    */
    int LexicalAnalysis()
    {

        //ch 为每次读入的字符
        char ch;

        //token用于保存识别出的单词
        char token[40];

        //es为错误代码，0表示没有错误
        int es=0;
        int j=0;
        int n=0;
        printf("请输入源程序文件名(包括路径)\n");
        scanf("%s",scanin);
        printf("请输入词法分析输出文件名(包括路径)\n");
        scanf("%s",scanout);

        //判断输入文件名是否正确
        if((fin=fopen(scanin,"r"))==NULL)
        {
            printf("\n不能打开%s或者打开出错！\n",scanin);

            //输入文件出错返回错误代码1
            return 1;
        }

        //判断输出文件名是否正确
        if((fout=fopen(scanout,"w"))==NULL)
        {
            printf("\n创建词法分析输出文件出错！\n");

            //输出文件出错返回错误代码2
            return 2;
        }

        //从输入文件中获取下一个字符
        ch=getc(fin);

        //循环输入指导文件末尾
        while(ch!=EOF)
        {
            //忽略空白符，换行符，制表符
            while(ch==' ' || ch=='\n' || ch=='\t')
            {
                ch=getc(fin);
            }

            //如果是字母则进行标识符处理
            if(isalpha(ch))
            {
                token[0]=ch;
                j=1;
                ch=getc(fin);

                //判断ch是否为字母或数字
                while(isalnum(ch))
                {
                    token[j++]=ch;
                    ch=getc(fin);
                }

                //标识符组合结束
                token[j]='\0';

                // 检查保留字
                for(n=0;n<KEYWORD_SUM;n++)
                {
                    if(strcmp(token,keyword[n])==0)
                    {
                        break;
                    }
                }
                if(n>=KEYWORD_SUM)
                {
                    //输出标识符
                    fprintf(fout,"%s\t%s\n","ID",token);
                }
                else
                {
                    //输出保留字
                    fprintf(fout,"%s\t%s\n",token,token);
                }
            }// 标识符或保留字处理结束

            //数字处理
            else if(isdigit(ch))
            {

                token[0]=ch;
                j=1;
                ch=getc(fin);

                //判断ch是否为数字
                while(isdigit(ch))
                {
                    token[j++]=ch;
                    ch=getc(fin);
                }

                //数字处理结束
                token[j]='\0';

                //输出保留字
                fprintf(fout,"%s\t%s\n","NUM",token);

            }//数字处理完毕

            //单分界符处理
            else if(strchr(singleword,ch)>0)
            {
                token[0]=ch;
                token[1]='\0';
                ch=getc(fin);

                //输出单分界符
                fprintf(fout,"%s\t%s\n",token,token);
            }

            //双分解符处理
            else if(strchr(doubleword,ch)>0)
            {
                printf("%c",ch);
                token[0]=ch;
                ch=getc(fin);
                if(ch=='=')
                {
                    token[1]=ch;
                    token[2]='\0';
                    ch=getc(fin);
                }
                else
                {
                    token[1]='\0';
                }

                //输出双分界符
                fprintf(fout,"%s\t%s\n",token,token);
            }

            //注释处理
            else if(ch=='/')
            {
                ch=getc(fin);

                //如果是*则开始处理注释
                if(ch=='*')
                {
                    char ch1=getc(fin);
                    do
                    {
                        ch=ch1;
                        ch1=getc(fin);
                    }while((ch != '*' || ch1 !='/') && ch1!=EOF);
                    ch=getc(fin);
                }
                else
                {
                    token[0]='/';
                    token[1]='\0';

                    //输出单分界符
                    fprintf(fout,"%s\t%s\n",token,token);
                }
            }
            else
            {
                token[0]=ch;
                token[1]='\0';
                ch=getc(fin);
                es=3;

                //输出错误
                fprintf(fout,"%s\t%s\n","ERROR",token);
            }


        }// while 结束

        //关闭输入输出文件
        fclose(fin);
        fclose(fout);

        //返回词法分析结果
        return es;
    }


    /******************************************************************************************
    *
    *   SyntaxAnalysis()
    *
    *   根据词法分析产生的结果进行语法分析
    */
    int SyntaxAnalysis()
    {
        int es=0;
        if((fp=fopen(scanout,"r"))==NULL)
        {
            //打开词法分析结果文件失败的错误码
            printf("\n打开%s错误！\n",scanout);
            es=10;
            return es;
        }
        printf("请输入目标文件名（包括路径）\n");
        scanf("%s",codeout);
        if((fout=fopen(codeout,"w"))==NULL)
        {
            //打开词法分析结果文件失败的错误码
            printf("\n创建%s错误！\n",scanout);
            es=10;
            return es;
        }
        if(es==0)
        {
            es=Program();
        }
        printf("语法分析结果\n");
        switch(es)
        {
            case 0:
                printf("语法，语义分析，生成中间代码成功！\n");
                break;
            case 1:
                printf("缺少{！\n");
                break;
            case 2:
                printf("缺少}！\n");
                break;
            case 3:
                printf("缺少标识符！\n");
                break;
            case 4:
                printf("缺少分号！\n");
                break;
            case 5:
                printf("缺少(！\n");
                break;
            case 6:
                printf("缺少)！\n");
                break;
            case 7:
                printf("缺少操作数！\n");
                break;
            case 8:
                printf("缺少write\n");
                break;
            case 10:
                printf("打开词法分析结果文件失败！\n");
                break;
            case 21:
                printf("符号表溢出！\n");
                break;
            case 22:
                printf("变量重复定义！\n");
                break;
            case 23:
                printf("变量未声明！\n");
                break;
            default:
                break;
        }
        fclose(fp);
        fclose(fout);
        return es;
    }

    /******************************************************************************************
    *
    *   Program()
    *
    *   <program>::={<declaration_list><statement_list>}
    */
    int Program()
    {
        int es=0;

        //从词法分析结果文件中读取数据到token，token1
        fscanf(fp,"%s %s\n",token,token1);
        printf("%s\t%s\n",token,token1);

        //判断是否为"{"
        if(strcmp(token,"{"))
        {
            return 1;
        }
        fscanf(fp,"%s %s\n",token,token1);
        printf("%s\t%s\n",token,token1);

        es=Declaration_List();
        if(es>0)
        {
            return es;
        }
        printf("符号表\n");
        printf("名字\t地址\n");
        int i;
        for(i=0;i<vartablep;i++)
        {
            printf("%s\t%d\n",vartable[i].name,vartable[i].addess);
        }
        es=Statement_List();
        if(es>0)
        {
            return es;
        }

        //判断是否为"}"
        if(strcmp(token,"}"))
        {
            return 2;
        }
        //产生停止指令
        fprintf(fout,"\tSTOP\n");
        return es;
    }

    /******************************************************************************************
    *
    *   Declaration_List()
    *
    *   <declaration_list>::={<declaration_stat>}
    */
    int Declaration_List()
    {
        int es=0;
        while(strcmp(token,"int")==0)
        {
            es=Declaration_Stat();
            if(es>0)
            {
                return es;
            }
        }
        return es;
    }


    /******************************************************************************************
    *
    *   Declaration_Stat()
    *
    *   <declaration_stat>::=int ID;
    */
    int Declaration_Stat()
    {
        int es=0;
        fscanf(fp,"%s %s\n",token,token1);
        printf("%s\t%s\n",token,token1);
        if(strcmp(token,"ID"))
        {
            //不是标识符
            return 3;
        }
        //插入符号表
        es=name_def(token1);
        if(es>0)
        {
            return es;
        }
        fscanf(fp,"%s %s\n",token,token1);
        printf("%s\t%s\n",token,token1);
        if(strcmp(token,";"))
        {
            //缺少";"
            return 4;
        }
        fscanf(fp,"%s %s\n",token,token1);
        printf("%s\t%s\n",token,token1);
        return es;
    }

    /******************************************************************************************
    *
    *   Statement_List()
    *
    *   <statement_list>::={<statement>}
    */
    int Statement_List()
    {
        int es=0;
        //如果当前token不是"}"则进入循环处理
        while(strcmp(token,"}"))
        {
            es=Statement();
            if(es>0)
            {
                return es;
            }
        }
        return es;
    }

    /******************************************************************************************
    *
    *   Statement()
    *
    *   <statement>::=<if_stat>|<while_stat>|<read_stat>|<write_stat>|<compound_stat>|<expression_stat>
    */
    int Statement()
    {
        int es=0;
        if(es==0 && strcmp(token,"if")==0)
        {
            es=If_Stat();
        }
        if(es==0 && strcmp(token,"while")==0)
        {
            es=While_Stat();
        }
        if(es==0 && strcmp(token,"read")==0)
        {
            es=Read_Stat();
        }
        if(es==0 && strcmp(token,"write")==0)
        {
            es=Write_Stat();
        }
        if(es==0 && strcmp(token,"{")==0)
        {
            es=Compound_Stat();
        }
        if(es==0 && (strcmp(token,"ID")==0)|| strcmp(token,"NUM")==0 ||strcmp(token,"(")==0)
        {
            es=Expression_Stat();
        }
        return es;
    }

    /******************************************************************************************
    *
    *   If_Stat()
    *
    *   <if_stat>::=if(<expression>)<statement>[else<statement>]
    */
    int If_Stat()
    {
        int es=0,label1,label2;
        fscanf(fp,"%s %s\n",token,token1);
        printf("%s\t%s\n",token,token1);

        //缺少左括号
        if(strcmp(token,"("))
        {
            return 5;
        }
        fscanf(fp,"%s %s\n",token,token1);
        printf("%s\t%s\n",token,token1);
        es=Expression();
        if(es>0)
        {
            return es;
        }
        if(strcmp(token,")")!=0)
        {
            //缺少右括号
            return 6;
        }

        //用label1记住条件为假时要转向的标号
        label1=labelp++;
        //输出假转移指令
        fprintf(fout,"\tBRF LABEL\t%d\n",label1);

        fscanf(fp,"%s %s\n",token,token1);
        printf("%s\t%s\n",token,token1);
        es=Statement();
        if(es>0)
        {
            return es;
        }

        //用label2记住要转向的标号
        label2=labelp++;
        fprintf(fout,"\tBR LABEL\t%d\n",label2);
        fprintf(fout,"\tLABEL%d:\n",label1);
        if(strcmp(token,"else")==0)
        {
            fscanf(fp,"%s %s\n",token,token1);
            printf("%s\t%s\n",token,token1);
            es=Statement();
            if(es>0)
            {
                return es;
            }
        }

        //设置label2记住的标号
        fprintf(fout,"\tLABEL%d:\n",label2);
        return es;

    }

    /******************************************************************************************
    *
    *   While_Stat()
    *
    *   <while_stat>::=while(<expression>)<statement>
    */
    int While_Stat()
    {
        int es=0,label1,label2;
        label1=labelp++;

        //设置label1标号
        fprintf(fout,"\tLABEL%d:\n",label1);
        fscanf(fp,"%s %s\n",token,token1);
        printf("%s\t%s\n",token,token1);
        if(strcmp(token,"("))
        {
            //缺少左括号
            return 5;
        }
        fscanf(fp,"%s %s\n",token,token1);
        printf("%s\t%s\n",token,token1);
        es=Expression();
        if(es>0)
        {
            return es;
        }
        if(strcmp(token,")"))
        {
            //缺少右括号
            return 6;
        }
        label2=labelp++;

        //输出假转移指令
        fprintf(fout,"\tBRF LABEL%d",label2);
        fscanf(fp,"%s %s\n",token,token1);
        printf("%s\t%s\n",token,token1);
        es=Statement();
        if(es>0)
        {
            return es;
        }

        //输出无条件转移指令
        fprintf(fout,"\tBR LABEL%d",label1);

        //设置label2标号
        fprintf(fout,"\tLABEL:%d\n",label2);
        return es;

    }

    /******************************************************************************************
    *
    *   Read_Stat()
    *
    *   <read_stat>::=read ID;
    */
    int Read_Stat()
    {
        int es=0,address;
        fscanf(fp,"%s %s\n",token,token1);
        printf("%s\t%s\n",token,token1);
        if(strcmp(token,"ID"))
        {
            //缺少标识符
            return 3;
        }
        es=look_up(token1,&address);
        if(es>0){
            return es;
        }
        fprintf(fout,"\tIN\t\n");
        fprintf(fout,"\tSTO\t%d\n",address);
        fprintf(fout,"\tPOP\n");
        fscanf(fp,"%s %s\n",token,token1);
        printf("%s\t%s\n",token,token1);

        if(strcmp(token,";"))
        {
            //缺少分号
            return 4;
        }
        fscanf(fp,"%s %s\n",token,token1);
        printf("%s\t%s\n",token,token1);
        return es;
    }

    /******************************************************************************************
    *
    *   Write_Stat()
    *
    *   <Write_stat>::=write<expression>;
    */
    int Write_Stat()
    {
        int es=0;
        fscanf(fp,"%s %s\n",token,token1);
        printf("%s\t%s\n",token,token1);
        es=Expression();
        if(es>0)
        {
            return es;
        }
        if(strcmp(token,";"))
        {
            //缺少分号
            return 4;
        }
        fprintf(fp,"\tOUT\n");
        fscanf(fp,"%s %s\n",token,token1);
        printf("%s\t%s\n",token,token1);
        return es;
    }

    /******************************************************************************************
    *
    *   Compound_Stat()
    *
    *   <compound_stat>::={<statement_list>}
    */
    int Compound_Stat()
    {
        int es=0;
        fscanf(fp,"%s %s\n",token,token1);
        printf("%s\t%s\n",token,token1);
        es=Statement_List();
        return es;
    }

    /******************************************************************************************
    *
    *   Expression_Stat()
    *
    *   <expression_stat>::=<expression>;|;
    */
    int Expression_Stat()
    {
        int es=0;
        if(strcmp(token,";")==0)
        {
            fscanf(fp,"%s %s\n",token,token1);
            printf("%s\t%s\n",token,token1);
            return es;
        }
        es=Expression();
        if(es>0)
        {
            return es;
        }
        fprintf(fout,"\tPOP\n");
        if(es==0 && strcmp(token,";")==0)
        {
            fscanf(fp,"%s %s\n",token,token1);
            printf("%s\t%s\n",token,token1);
            return es;
        }else
        {
            //缺少；
            es=4;
            return 4;
        }
        return es;
    }

    /******************************************************************************************
    *
    *   Expression()
    *
    *   <Expression>::=ID=<bool_expr>|<bool_expr>
    */
    int Expression()
    {
        int es=0,fileadd;
        char token2[20];
        char token3[40];
        if(strcmp(token,"ID")==0)
        {
            //记住当前文件位置
            fileadd=ftell(fp);
            fscanf(fp,"%s %s\n",&token2,&token3);
            printf("%s\t%s\n",token2,token3);
            if(strcmp(token2,"=")==0)
            {
                int address;
                es=look_up(token1,&address);
                if(es>0)
                {
                    return es;
                }
                fscanf(fp,"%s %s\n",&token,&token1);
                printf("%s\t%s\n",token,token1);
                es=Bool_Expr();
                if(es>0){
                    return es;
                }
                fprintf(fout,"\tSTO\t%d\n",address);
            }else
            {
                //如果不是“=”，则文件指针回到“=”之前的标识符
                fseek(fp,fileadd,0);
                printf("%s\t%s\n",token,token1);
                es=Bool_Expr();
                if(es>0)
                {
                    return es;
                }
            }
        }else
        {
            es=Bool_Expr();
        }
        return es;
    }

    /******************************************************************************************
    *
    *   Bool_Expr()
    *
    *   <bool_expr>::=<additive_expr>|<additive_expr>(>|<|>=|<=|==|!=)<additive_expr>
    */
    int Bool_Expr()
    {
        int es=0;
        es=Additive_Expr();
        if(es>0)
        {
            return es;
        }
        if(strcmp(token,">")==0 || strcmp(token,"<")==0 || strcmp(token,">=")==0 || strcmp(token,"<=")==0 ||
           strcmp(token,"==")==0 || strcmp(token,"!=")==0)
        {
            char token2[20];
            strcpy(token2,token);
            fscanf(fp,"%s %s\n",token,token1);
            printf("%s\t%s\n",token,token1);
            es=Additive_Expr();
            if(es>0)
            {
                return es;
            }
            if(strcmp(token2,">")==0)
            {
                fprintf(fout,"\tGT\n");
            }
            if(strcmp(token2,">=")==0)
            {
                fprintf(fout,"\tGE\n");
            }
            if(strcmp(token2,"\t<")==0)
            {
                fprintf(fout,"\tLES\n");
            }
            if(strcmp(token2,"\t<=")==0)
            {
                fprintf(fout,"\tLE\n");
            }
            if(strcmp(token2,"==")==0)
            {
                fprintf(fout,"\tEQ\n");
            }
            if(strcmp(token2,"!=")==0)
            {
                fprintf(fout,"\tNOTEQ\n");
            }

        }
        return es;
    }

    /******************************************************************************************
    *
    *   Additive_Expr()
    *
    *   <additive_expr>::=<term>{(+|-)<term>}
    */
    int Additive_Expr()
    {
        int es=0;
        es=Term();
        if(es>0)
        {
            return es;
        }
        while(strcmp(token,"+")==0 ||strcmp(token,"-")==0)
        {
            char token2[20];
            strcpy(token2,token);
            fscanf(fp,"%s %s\n",token,token1);
            printf("%s\t%s\n",token,token1);
            es=Term();
            if(es>0)
            {
                return es;
            }
            if(strcmp(token2,"+")==0)
            {
                fprintf(fout,"\tADD\n");
            }
            if(strcmp(token2,"-")==0)
            {
                fprintf(fout,"\tSUB\n");
            }
        }
        return es;
    }

    /******************************************************************************************
    *
    *   Term()
    *
    *   <term>::=<factor>{(*|/)<factor>}
    */
    int Term()
    {
        int es=0;
        es=Factor();
        if(es>0)
        {
            return es;
        }
        while(strcmp(token,"*")==0 ||strcmp(token,"/")==0)
        {
            char token2[20];
            strcpy(token2,token);
            fscanf(fp,"%s %s\n",token,token1);
            printf("%s\t%s\n",token,token1);
            es=Factor();
            if(es>0)
            {
                return es;
            }
            if(strcmp(token2,"*")==0)
            {
                fprintf(fout,"\tMULT\n");
            }
            if(strcmp(token2,"/")==0)
            {
                fprintf(fout,"\tDIV\n");
            }
        }
        return es;
    }

    /******************************************************************************************
    *
    *   Factor()
    *
    *   <factor>::=(<expression>)|ID|NUM
    */
    int Factor()
    {
        int es=0;
        if(strcmp(token,"(")==0)
        {
            fscanf(fp,"%s %s\n",token,token1);
            printf("%s\t%s\n",token,token1);
            es=Expression();
            if(es>0)
            {
                return es;
            }
            if(strcmp(token,")")!=0)
            {
                //缺少右括号
                return 6;
            }
            fscanf(fp,"%s %s\n",token,token1);
            printf("%s\t%s\n",token,token1);
        }else
        {
            if(strcmp(token,"ID")==0)
            {
                int address;
                es=look_up(token1,&address);
                if(es>0)
                {
                    //变量没有声明
                    return es;
                }
                fprintf(fout,"\tLOAD\t%d\n",address);
                fscanf(fp,"%s %s\n",token,token1);
                printf("%s\t%s\n",token,token1);
                return es;
            }else if(strcmp(token,"NUM")==0)
            {
                fprintf(fout,"\tLOADI\t%s\n",token1);
                fscanf(fp,"%s %s\n",token,token1);
                printf("%s\t%s\n",token,token1);
                return es;
            }
            else
            {
                //缺少操作数
                es=7;
                return es;
            }
        }
        return es;
    }

int main()
{
    printf("欢迎使用编译器前端系统\n");
    int es=0;
    es=LexicalAnalysis();
    if(es)
    {
        printf("词法分析有错，编译停止。\n");
    }
    else
    {
        printf("词法分析成功！\n");
    }
    es=SyntaxAnalysis();
    if(es)
    {
        printf("语法分析有错，编译停止。\n");
    }
    else
    {
        printf("语法分析成功！\n");
    }
    getchar();
    getchar();
    return 0;
}
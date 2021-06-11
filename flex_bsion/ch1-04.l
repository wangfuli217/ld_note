%{
  /*
   *带符号表的词法分析程序
   */
   
   enum{
		LOOKUP = 0, /*默认——查找而不是定义*/
		VERB,
		ADJ,
		ADV,
		NOUN,
		PREP,
		PRON,
		CONJ
	};
	
	int state;
	int add_word(int type, char *word);
	int lookup_word(char *word);
%}
 
%%
\n		{state = LOOKUP;} /*行结束，返回到默认状态*/
 
		/*无论何时，行都以保留字的词性名字开始*/
		/*定义该类型的单词*/
^verb 	{state = VERB;}
^adj	{state = ADJ;}
^adv	{state = ADV;}
^noun	{state = NOUN;}
^prep	{state = PREP;}
^pron	{state = PRON;}
^conj	{state = CONJ;}
 
[a-zA-Z]+	{
				/*一个标准的单词、定义或者查找它*/
				if(state != LOOKUP){
					/*定义当前单词*/
					add_word(state,yytext);
				}else{
					switch(lookup_word(yytext)){
						case VERB: printf("%s: verb\n",yytext); break;
						case ADJ: printf("%s: adj\n",yytext); break;
						case ADV: printf("%s: adv\n",yytext); break;
						case NOUN: printf("%s: noun\n",yytext); break;
						case PREP: printf("%s: prep\n",yytext); break;
						case PRON: printf("%s: pron\n",yytext); break;
						case CONJ: printf("%s: conj\n",yytext); break;
						default:
									printf("%s: don't recognize\n",yytext);
									break;
					}//switch
				}//else
			}
			/*忽略其他的东西*/
%%
 
int main()
{
	yylex();
}
 
/*定义一个连接的单词和类型列表*/
struct word{
	char *word_name;
	int word_type;
	struct word *next;
};
 
struct word *word_list; //first element in word list
 
extern void *malloc();

/* 表示在符号表中放置一个新的单词 */
int add_word(int type, char *word)
{
	struct word *wp;
	if(lookup_word(word) != LOOKUP)
	{
		printf("!!! warning : word %s already defined \n ",word);
		return 0;
	}//if
	
	/*单词不在那里，分配一个新的条目并将它连接到列表上*/
	wp = (struct word*) malloc (sizeof(struct word));
	
	wp->next = word_list;
	
	/*还必须复制单词本身*/
	wp->word_name = (char *)malloc(strlen(word)+1);
	strcpy(wp->word_name,word);
	wp->word_type = type;
	word_list = wp;
	return 1; /*它被处理过*/
}

/* 查询已经输入的单词 */
int lookup_word(char *word)
{
	struct word *wp = word_list;
	
	/*向下搜索列表以寻找单词*/
	for(; wp ; wp = wp->next)
	{
		if(strcmp(wp->word_name , word) == 0)
			return wp->word_type;
	}//for
	return LOOKUP;
}
 
int yywrap()
{
	return 1;
}

/* 
flex  ch1-04.l      生成lex.yy.c
gcc -c lex.yy.c     生成lex.yy.o
gcc lex.yy.c -o ch1 生成ch1
./ch1
*/
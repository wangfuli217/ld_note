/* Function type.  */
/* 函数类型 */
typedef double (*func_t)(double);

/* Data type for links in the chain of symbols.  */
/* 链表节点的数据类型 */
struct symrec
{
	char *name;	/* name of symbol */ /* 符号的名称 */
	int type; /* type of symbol: either VAR or FNCT */ /* 符号的类型: VAR 或 FNCT */
  	union
	{
		double var;		/* value of a VAR */ /* VAR 的值 */
		func_t fnctptr;	/* value of a FNCT */ /* FNCT 的值 */
	} value;
	struct symrec *next;	/* link field */ /* 指针域 */
};

typedef struct symrec symrec;

/* The symbol table: a chain of `struct symrec'.  */
/* 符号表: `struct symrec'的链表 */
extern symrec *sym_table;

symrec *putsym (char const *, int);
symrec *getsym (char const *);

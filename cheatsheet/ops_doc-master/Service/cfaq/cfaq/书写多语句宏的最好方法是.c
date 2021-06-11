// 方案1
#define MACRO(arg1, arg2) do {	\
	/* declarations */	\
	stmt1;			\
	stmt2;			\
	/* ... */		\
	} while(0)	/* (no trailing ; ) */


// 方案2
#define MACRO(arg1, arg2) if(1) { \
		stmt1; \
		stmt2; \
		} else

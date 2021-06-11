#ifndef XP_H_
#define XP_H_

typedef unsigned char *Xp;

extern int XP_add(int n, Xp z, Xp x, Xp y, int carry);
extern int XP_sub(int n, Xp z, Xp x, Xp y, int borrow);
extern int XP_mul(Xp z, int n, Xp x, int m, Xp y);
extern int XP_div(int n, Xp q, Xp x, int m, Xp y, Xp r,Xp tmp);
extern int XP_sum     (int n, Xp z, Xp x, int y);
extern int XP_diff    (int n, Xp z, Xp x, int y);
extern int XP_product (int n, Xp z, Xp x, int y);
extern int XP_quotient(int n, Xp z, Xp x, int y);
extern int XP_neg(int n, Xp z, Xp x, int carry);
extern int XP_cmp(int n, Xp x, Xp y);
extern void XP_lshift(int n, Xp z, int m, Xp x,
	int s, int fill);
extern void XP_rshift(int n, Xp z, int m, Xp x,
	int s, int fill);
extern int           XP_length (int n, Xp x);
extern unsigned long XP_fromint(int n, Xp z,
	unsigned long u);
extern unsigned long XP_toint  (int n, Xp x);
extern int   XP_fromstr(int n, Xp z, const char *str,
	int base, char **end);
extern char *XP_tostr  (char *str, int size, int base,
	int n, Xp x);
#undef Xp
#endif

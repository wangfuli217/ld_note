#ifndef BIT_H_
#define BIT_H_

//λͼ 
typedef struct bit 
{
	int length;          //����λ�ĸ���������ֵ�����ֵ - 1 
	unsigned char *bytes;//ʹ��char�����ڼ��� 
	unsigned long *words;//λͼ����ʼ 
}*Bit;

extern Bit Bit_new   (int length);
extern int Bit_length(Bit set);
extern int Bit_count (Bit set);
extern void Bit_free (Bit *set);

extern int Bit_get(Bit set, int n);
extern int Bit_put(Bit set, int n, int bit);

extern void Bit_clear(Bit set, int lo, int hi);
extern void Bit_set  (Bit set, int lo, int hi);
extern void Bit_not  (Bit set, int lo, int hi);

extern int Bit_lt (Bit s, Bit t);
extern int Bit_eq (Bit s, Bit t);
extern int Bit_leq(Bit s, Bit t);
extern void Bit_map(Bit set,
 	void (*apply)(int n, int bit));

extern Bit Bit_union(Bit s, Bit t);
extern Bit Bit_inter(Bit s, Bit t);
extern Bit Bit_minus(Bit s, Bit t);
extern Bit Bit_diff (Bit s, Bit t);

#endif


#ifndef rdtsc
//#define rdtscfreq 2.1280493e9
#define rdtscfreq 1 
#define rdtsc(low,high) \
__asm__ __volatile__("rdtsc" : "=a" (low), "=d" (high))
static inline  double rdtscdiff(unsigned int low1,unsigned int high1,unsigned int low2,unsigned int high2)
{
	const  double MAXintplus1 = 4294967296.0;
	unsigned int low,high;
	if (low2<low1) {
	low = 0xffffffff - low1 + low2;
	high = high2 - high1 -1;
	}
	else {
	high = high2 - high1;
	low = low2 - low1;
	}
//	printf("%d,",low);
	return (double)high * MAXintplus1 + (double)low ;
}
static inline double mdtime(int id)
{
	static unsigned int high0,low0,high1,low1;
	if(id){
		rdtsc(low1,high1);
	        return rdtscdiff(low0,high0,low1,high1)/rdtscfreq;	
	}
	else{
		rdtsc(low0,high0);
		return 0.0;
	}
}
static inline double mdtime2(int id)
{
	static unsigned int high0,low0,high1,low1;
	if(id){
		rdtsc(low1,high1);
	        return rdtscdiff(low0,high0,low1,high1)/rdtscfreq;	
	}
	else{
		rdtsc(low0,high0);
		return 0.0;
	}
}
#endif

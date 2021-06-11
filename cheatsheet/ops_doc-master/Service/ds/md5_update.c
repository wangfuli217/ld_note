#include <stdio.h>
#include <string.h> 
#include "sys_crypt.h"    

https://linux.die.net/man/3/md5_update
man MD5_Update
man SHA1_Update
/**********************************************************
*******MD5 algorithm definition
***********************************************************
md5 算法 说明 以及 c源代码

www.diybl.com    时间 ： 2011-04-26  作者：佚名   编辑：fnw 点击：  2848 [
评论 ]

1、MD5算法是对输入的数据进行补位，使得如果数据位长度LEN对512求余的结果是448
。即数据扩展至K*512+448位。即K*64+56个字节，K为整数。 具体补位操作：补一个1
，然后补0至满足上述要求

2、补数据长度：
用一个64位的数字表示数据的原始长度B，把B用两个32
位数表示。这时，数据就被填补成长度为512位的倍数。

3. 初始化MD5参数
四个32位整数 (A,B,C,D) 用来计算信息摘要，初始化使用的是十六进制表示的数字
A=0X01234567
B=0X89abcdef
C=0Xfedcba98
D=0X76543210

4、处理位操作函数
X，Y，Z为32位整数。
F(X,Y,Z) = X&Y|NOT(X)&Z
G(X,Y,Z) = X&Z|Y&not(Z)
H(X,Y,Z) = X xor Y xor Z
I(X,Y,Z) = Y xor (X|not(Z))


5、主要变换过程：
使用常数组T[1 ... 64]， T[i]为32位整数用16进制表示，数据用16个32位的整数数组M[
]表示。
具体过程如下：
// 处理数据原文
For i = 0 to N/16-1 do
//每一次，把数据原文存放在16个元素的数组X中.
For j = 0 to 15 do
Set X[j] to M[i*16+j].
end /结束对J的循环
// Save A as AA, B as BB, C as CC, and D as DD. 
AA = A
BB = B
CC = C
DD = D
//第1轮
// 以 [abcd k s i]表示如下操作
a = b + ((a + F(b,c,d) + X[k] + T[i]) <<< s). 
// Do the following 16 operations. 
[ABCD 0 7 1] [DABC 1 12 2] [CDAB 2 17 3] [BCDA 3 22 4]
[ABCD 4 7 5] [DABC 5 12 6] [CDAB 6 17 7] [BCDA 7 22 8]
[ABCD 8 7 9] [DABC 9 12 10] [CDAB 10 17 11] [BCDA 11 22 12]
[ABCD 12 7 13] [DABC 13 12 14] [CDAB 14 17 15] [BCDA 15 22 16]
// 第2轮
// 以 [abcd k s i]表示如下操作
a = b + ((a + G(b,c,d) + X[k] + T[i]) <<< s). 
// Do the following 16 operations. 
[ABCD 1 5 17] [DABC 6 9 18] [CDAB 11 14 19] [BCDA 0 20 20]
[ABCD 5 5 21] [DABC 10 9 22] [CDAB 15 14 23] [BCDA 4 20 24]
[ABCD 9 5 25] [DABC 14 9 26] [CDAB 3 14 27] [BCDA 8 20 28]
[ABCD 13 5 29] [DABC 2 9 30] [CDAB 7 14 31] [BCDA 12 20 32]
// 第3轮
// 以 [abcd k s i]表示如下操作
a = b + ((a + H(b,c,d) + X[k] + T[i]) <<< s). 
// Do the following 16 operations. *
[ABCD 5 4 33] [DABC 8 11 34] [CDAB 11 16 35] [BCDA 14 23 36]
[ABCD 1 4 37] [DABC 4 11 38] [CDAB 7 16 39] [BCDA 10 23 40]
[ABCD 13 4 41] [DABC 0 11 42] [CDAB 3 16 43] [BCDA 6 23 44]
[ABCD 9 4 45] [DABC 12 11 46] [CDAB 15 16 47] [BCDA 2 23 48]
// 第4轮*
// 以 [abcd k s i]表示如下操作
a = b + ((a + I(b,c,d) + X[k] + T[i]) <<< s). 
// Do the following 16 operations. 
[ABCD 0 6 49] [DABC 7 10 50] [CDAB 14 15 51] [BCDA 5 21 52]
[ABCD 12 6 53] [DABC 3 10 54] [CDAB 10 15 55] [BCDA 1 21 56]
[ABCD 8 6 57] [DABC 15 10 58] [CDAB 6 15 59] [BCDA 13 21 60]
[ABCD 4 6 61] [DABC 11 10 62] [CDAB 2 15 63] [BCDA 9 21 64]
// 然后进行如下操作
A = A + AA
B = B + BB
C = C + CC
D = D + DD
end // 结束对I的循环*

http://www.diybl.com/course/3_program/c++/cppsl/200832/102444.html
***********************************************************/

#define S11 7 
#define S12 12
#define S13 17
#define S14 22
#define S21 5 
#define S22 9 
#define S23 14
#define S24 20
#define S31 4 
#define S32 11
#define S33 16
#define S34 23
#define S41 6 
#define S42 10
#define S43 15
#define S44 21

/*
用于bits填充的缓冲区，为什么要64个字节呢？因为当欲加密的信息的bits数被512
除其余数为448时，
需要填充的bits的最大值为512=64*8 。
*/
static unsigned char PADDING[64] =    
{    
    0x80, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,  
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0   
};

/*
接下来的这几个宏定义是md5算法规定的，就是对信息进行md5加密都要做的运算。
据说有经验的高手跟踪程序时根据这几个特殊的操作就可以断定是不是用的md5
*/
/* F, G, H and I are basic MD5 functions.
*/
#define F(x, y, z) (((x) & (y)) | ((~x) & (z)))   
#define G(x, y, z) (((x) & (z)) | ((y) & (~z)))   
#define H(x, y, z) ((x) ^ (y) ^ (z))  
#define I(x, y, z) ((y) ^ ((x) | (~z)))     

/* 
*ROTATE_LEFT rotates x left n bits.
*/
#define ROTATE_LEFT(x, n) (((x) << (n)) | ((x) >> (32-(n))))  
  

/* FF, GG, HH, and II transformations for rounds 1, 2, 3, and 4.
Rotation is separate from addition to prevent recomputation.
*/

#define FF(a, b, c, d, x, s, ac) { \
(a) += F ((b), (c), (d)) + (x) + (unsigned int)(ac); \
(a) = ROTATE_LEFT ((a), (s)); \
(a) += (b); \
}
#define GG(a, b, c, d, x, s, ac) { \
(a) += G ((b), (c), (d)) + (x) + (unsigned int)(ac); \
(a) = ROTATE_LEFT ((a), (s)); \
(a) += (b); \
}
#define HH(a, b, c, d, x, s, ac) { \
(a) += H ((b), (c), (d)) + (x) + (unsigned int)(ac); \
(a) = ROTATE_LEFT ((a), (s)); \
(a) += (b); \
}
#define II(a, b, c, d, x, s, ac) { \
(a) += I ((b), (c), (d)) + (x) + (unsigned int)(ac); \
(a) = ROTATE_LEFT ((a), (s)); \
(a) += (b); \
}



  
static void MD5_Encode(unsigned char * output, unsigned int * input, int len)   
{    
	unsigned int i, j;    
	for (i = 0, j = 0; j < len; i++, j += 4)
	{
		output[j] = (unsigned char) (input[i] & 0xff);  
		output[j + 1] = (unsigned char) ((input[i] >> 8) & 0xff);   
		output[j + 2] = (unsigned char) ((input[i] >> 16) & 0xff);  
		output[j + 3] = (unsigned char) ((input[i] >> 24) & 0xff);  
	}   
} 
  
static void MD5_Decode(unsigned int * output, unsigned char * input, int len
)   
{    
	unsigned int i, j;    
	for (i = 0, j = 0; j < len; i++, j += 4)
	{
		output[i] = ((unsigned int) input[j]) |   (((unsigned int) input[j + 1]) << 
8) |(((unsigned int) input[j + 2]) << 16) |   (((unsigned int) input[j + 3]) 
<< 24);
	}   
} 
  
static void MD5_Transform(unsigned int state[4], unsigned char block[64]) 
{    
	unsigned int a = state[0], b = state[1], c = state[2], d = state[3], x[16]; 
	MD5_Decode(x, block, 64);   

	/**//* Round 1 */     
	FF(a, b, c, d, x[0], S11, 0xd76aa478);    /**//* 1 */     
	FF(d, a, b, c, x[1], S12, 0xe8c7b756);    /**//* 2 */     
	FF(c, d, a, b, x[2], S13, 0x242070db);    /**//* 3 */     
	FF(b, c, d, a, x[3], S14, 0xc1bdceee);    /**//* 4 */     
	FF(a, b, c, d, x[4], S11, 0xf57c0faf);    /**//* 5 */     
	FF(d, a, b, c, x[5], S12, 0x4787c62a);    /**//* 6 */     
	FF(c, d, a, b, x[6], S13, 0xa8304613);    /**//* 7 */     
	FF(b, c, d, a, x[7], S14, 0xfd469501);    /**//* 8 */     
	FF(a, b, c, d, x[8], S11, 0x698098d8);    /**//* 9 */     
	FF(d, a, b, c, x[9], S12, 0x8b44f7af);    /**//* 10 */    
	FF(c, d, a, b, x[10], S13, 0xffff5bb1);   /**//* 11 */    
	FF(b, c, d, a, x[11], S14, 0x895cd7be);   /**//* 12 */    
	FF(a, b, c, d, x[12], S11, 0x6b901122);   /**//* 13 */    
	FF(d, a, b, c, x[13], S12, 0xfd987193);   /**//* 14 */    
	FF(c, d, a, b, x[14], S13, 0xa679438e);   /**//* 15 */    
	FF(b, c, d, a, x[15], S14, 0x49b40821);   /**//* 16 */    

	/**//* Round 2 */     
	GG(a, b, c, d, x[1], S21, 0xf61e2562);    /**//* 17 */    
	GG(d, a, b, c, x[6], S22, 0xc040b340);    /**//* 18 */    
	GG(c, d, a, b, x[11], S23, 0x265e5a51);   /**//* 19 */    
	GG(b, c, d, a, x[0], S24, 0xe9b6c7aa);    /**//* 20 */    
	GG(a, b, c, d, x[5], S21, 0xd62f105d);    /**//* 21 */    
	GG(d, a, b, c, x[10], S22, 0x2441453);    /**//* 22 */    
	GG(c, d, a, b, x[15], S23, 0xd8a1e681);   /**//* 23 */    
	GG(b, c, d, a, x[4], S24, 0xe7d3fbc8);    /**//* 24 */    
	GG(a, b, c, d, x[9], S21, 0x21e1cde6);    /**//* 25 */    
	GG(d, a, b, c, x[14], S22, 0xc33707d6);   /**//* 26 */    
	GG(c, d, a, b, x[3], S23, 0xf4d50d87);    /**//* 27 */    
	GG(b, c, d, a, x[8], S24, 0x455a14ed);    /**//* 28 */    
	GG(a, b, c, d, x[13], S21, 0xa9e3e905);   /**//* 29 */    
	GG(d, a, b, c, x[2], S22, 0xfcefa3f8);    /**//* 30 */    
	GG(c, d, a, b, x[7], S23, 0x676f02d9);    /**//* 31 */    
	GG(b, c, d, a, x[12], S24, 0x8d2a4c8a);   /**//* 32 */    

	/**//* Round 3 */     

	HH(a, b, c, d, x[5], S31, 0xfffa3942);    /**//* 33 */    
	HH(d, a, b, c, x[8], S32, 0x8771f681);    /**//* 34 */    
	HH(c, d, a, b, x[11], S33, 0x6d9d6122);   /**//* 35 */    
	HH(b, c, d, a, x[14], S34, 0xfde5380c);   /**//* 36 */    
	HH(a, b, c, d, x[1], S31, 0xa4beea44);    /**//* 37 */    
	HH(d, a, b, c, x[4], S32, 0x4bdecfa9);    /**//* 38 */    
	HH(c, d, a, b, x[7], S33, 0xf6bb4b60);    /**//* 39 */    
	HH(b, c, d, a, x[10], S34, 0xbebfbc70);   /**//* 40 */    
	HH(a, b, c, d, x[13], S31, 0x289b7ec6);   /**//* 41 */    
	HH(d, a, b, c, x[0], S32, 0xeaa127fa);    /**//* 42 */    
	HH(c, d, a, b, x[3], S33, 0xd4ef3085);    /**//* 43 */    
	HH(b, c, d, a, x[6], S34, 0x4881d05); /**//* 44 */  
	HH(a, b, c, d, x[9], S31, 0xd9d4d039);    /**//* 45 */    
	HH(d, a, b, c, x[12], S32, 0xe6db99e5);   /**//* 46 */    
	HH(c, d, a, b, x[15], S33, 0x1fa27cf8);   /**//* 47 */    
	HH(b, c, d, a, x[2], S34, 0xc4ac5665);    /**//* 48 */    

	/**//* Round 4 */     
	II(a, b, c, d, x[0], S41, 0xf4292244);    /**//* 49 */    
	II(d, a, b, c, x[7], S42, 0x432aff97);    /**//* 50 */    
	II(c, d, a, b, x[14], S43, 0xab9423a7);   /**//* 51 */    
	II(b, c, d, a, x[5], S44, 0xfc93a039);    /**//* 52 */    
	II(a, b, c, d, x[12], S41, 0x655b59c3);   /**//* 53 */    
	II(d, a, b, c, x[3], S42, 0x8f0ccc92);    /**//* 54 */    
	II(c, d, a, b, x[10], S43, 0xffeff47d);   /**//* 55 */    
	II(b, c, d, a, x[1], S44, 0x85845dd1);    /**//* 56 */    
	II(a, b, c, d, x[8], S41, 0x6fa87e4f);    /**//* 57 */    
	II(d, a, b, c, x[15], S42, 0xfe2ce6e0);   /**//* 58 */    
	II(c, d, a, b, x[6], S43, 0xa3014314);    /**//* 59 */    
	II(b, c, d, a, x[13], S44, 0x4e0811a1);   /**//* 60 */    
	II(a, b, c, d, x[4], S41, 0xf7537e82);    /**//* 61 */    
	II(d, a, b, c, x[11], S42, 0xbd3af235);   /**//* 62 */    
	II(c, d, a, b, x[2], S43, 0x2ad7d2bb);    /**//* 63 */    
	II(b, c, d, a, x[9], S44, 0xeb86d391);    /**//* 64 */    

	state[0] += a;  
	state[1] += b;  
	state[2] += c;  
	state[3] += d;  

	memset((char *) x, 0, sizeof(x)); 
} 


/* MD5 initialization. Begins an MD5 operation, writing a new context. */
/*初始化md5的结构*/
void MD5_Init(MD5Context * context)   
{   
	/*将当前的有效信息的长度设成0,这个很简单,还没有有效信息,长度当然是0了*/
	context->count[0] = context->count[1] = 0;
	
	/* Load magic initialization constants.*/
	/*初始化链接变量，算法要求这样，这个没法解释了*/
	context->state[0] = 0x67452301;   
	context->state[1] = 0xefcdab89;   
	context->state[2] = 0x98badcfe;   
	context->state[3] = 0x10325476;   
} 

/* MD5 block update operation. Continues an MD5 message-digest
operation, processing another message block, and updating the
context. */
/*将与加密的信息传递给md5结构，可以多次调用
context：初始化过了的md5结构
buf：欲加密的信息，可以任意长
bufLen：指定input的长度
*/ 
void MD5_Update(MD5Context * context, unsigned char * buf, int len) 
{    
	unsigned int i, index, partLen;   

	/* Compute number of bytes mod 64 */
	/*计算已有信息的bits长度的字节数的模64, 64bytes=512bits。
	用于判断已有信息加上当前传过来的信息的总长度能不能达到512bits，
	如果能够达到则对凑够的512bits进行一次处理*/
	index = (unsigned int) ((context->count[0] >> 3) & 0x3F); 

	/* Update number of bits *//*更新已有信息的bits长度*/
	if ((context->count[0] += ((unsigned int) len << 3)) < ((unsigned int)len << 
3)) 
		context->count[1]++;    
	context->count[1] += ((unsigned int) len >> 29);    

	/*计算已有的字节数长度还差多少字节可以 凑成64的整倍数*/
	partLen = 64 - index; 

	/* Transform as many times as possible.*/
	/*如果当前输入的字节数 大于 已有字节数长度补足64字节整倍数所差的字节数*/
	if (len >= partLen)   
	{
		/*用当前输入的内容把context->buffer的内容补足512bits*/
		memcpy((char *) &context->buffer[index], (char *) buf, partLen);  

		/*用基本函数对填充满的512bits（已经保存到context->buffer中）
做一次转换，转换结果保存到context->state中*/
		MD5_Transform(context->state, context->buffer); 

		/*
		对当前输入的剩余字节做转换（如果剩余的字节<在输入的input缓冲区中>大于512bits
的话 ），
		转换结果保存到context->state中
		*/
		for (i = partLen; i + 63 < len; i += 64)  
			MD5_Transform(context->state, &buf[i]);     
		index = 0;  
	}   
	else
	{
		i = 0;
	}   

	/* Buffer remaining input */
	/*将输入缓冲区中的不足填充满512bits的剩余内容填充到context->buffer
中，留待以后再作处理*/
	memcpy((char *) &context->buffer[index], (char *) &buf[i], len - i);  
} 
  
void MD5_Final(MD5Context * context, unsigned char digest[16])
{    
	unsigned char bits[8];
	unsigned int index, padLen;
	
	/* Save number of bits */
	/*将要被转换的信息(所有的)的bits长度拷贝到bits中*/
	MD5_Encode(bits, context->count, 8);
	
	/* Pad out to 56 mod 64. */
	/* 计算所有的bits长度的字节数的模64, 64bytes=512bits*/
	index = (unsigned int)((context->count[0] >> 3) & 0x3f);
	
	/*计算需要填充的字节数，padLen的取值范围在1-64之间*/
	padLen = (index < 56) ? (56 - index) : (120 - index);
	
	/*这一次函数调用绝对不会再导致MD5Transform的被调用，因为这一次不会填满512bits
*/
	MD5_Update(context, PADDING, padLen);
	
	/* Append length (before padding) */
	/*补上原始信息的bits长度（bits长度固定的用64bits表示），这一次能够恰巧凑够
512bits，不会多也不会少*/
	MD5_Update(context, bits, 8);
	
	/* Store state in digest */
	/*将最终的结果保存到digest中。ok，终于大功告成了*/
	MD5_Encode(digest, context->state, 16);
	
	/* Zeroize sensitive information. */
	memset((char *) context, 0, sizeof(*context));
} 
  
// 计算文件的 MD5
// filename 文件名, 计算的 MD5 放入缓冲区 buff 中
// buff 长度为16 字节
int MD5_File ( const char * filename,unsigned char *buff )   
{    
	FILE *file;     
	MD5Context context;   
	//    unsigned char buff[16];   
	int i,len;
	unsigned char buffer[0x0400];     

	if (!(file = fopen (filename, "rb")))   
	{
		printf ("%s can''t be opened ", filename);
		return -1;     
	}   
	else
	{
		MD5_Init (&context);    
		while (len = fread (buffer, 1, 1024, file))     
			MD5_Update (&context, buffer, len);   
		MD5_Final(&context,buff);     
		fclose (file);    
		for(i=0;i<16;i++) 
		{  
			printf("%x",(buff[i] & 0xF0)>>4);     
			printf("%x",buff[i] & 0x0F);    
		}     
		printf(" ");
		return 0;
	}   
} 

#ifdef DEBUG_MD5_FUNC
int main(int argc,char *argv[])
{
	int i =0,j,len,startTime,endTime;
	MD5Context context;
	unsigned char buff[16];

	len = strlen(argv[1]);

	MD5_Init(&context);
	MD5_Update(&context,(unsigned char *)argv[1], len);
	MD5_Final(&context,buff);

	printf("MD5(\"%s\")=",argv[1]);

	for(j=0;j<16;j++)
	{
		printf("%x",(buff[j] & 0xF0)>>4);
		printf("%x",buff[j] & 0x0F);
	}
	printf("\nMD5 end\n");
	return 0;
}
#endif

/**********************************************************
*******SHA1 algorithm definition
***********************************************************/
/*
 *	Define the circular shift macro
 */
#define SHA1CircularShift(bits,word) \
		((((word) << (bits)) & 0xFFFFFFFF) | \
		((word) >> (32-(bits))))
	
/* Function prototypes */
/*	
 *	SHA1ProcessMessageBlock
 *
 *	Description:
 *		This function will process the next 512 bits of the message
 *		stored in the Message_Block array.
 *
 *	Parameters:
 *		None.
 *
 *	Returns:
 *		Nothing.
 *
 *	Comments:
 *		Many of the variable names in the SHAContext, especially the
 *		single character names, were used because those were the names
 *		used in the publication.
 *		   
 *
 */
void SHA1ProcessMessageBlock(SHA1Context *context)
{
	const unsigned K[] =			/* Constants defined in SHA-1	*/		
	{
		0x5A827999,
		0x6ED9EBA1,
		0x8F1BBCDC,
		0xCA62C1D6
	};
	int 		t;					/* Loop counter 				*/
	unsigned	temp;				/* Temporary word value 		*/
	unsigned	W[80];				/* Word sequence				*/
	unsigned	A, B, C, D, E;		/* Word buffers 				*/

	/*
	 *	Initialize the first 16 words in the array W
	 */
	for(t = 0; t < 16; t++)
	{
		W[t] = ((unsigned) context->Message_Block[t * 4]) << 24;
		W[t] |= ((unsigned) context->Message_Block[t * 4 + 1]) << 16;
		W[t] |= ((unsigned) context->Message_Block[t * 4 + 2]) << 8;
		W[t] |= ((unsigned) context->Message_Block[t * 4 + 3]);
	}

	for(t = 16; t < 80; t++)
	{
	   W[t] = SHA1CircularShift(1,W[t-3] ^ W[t-8] ^ W[t-14] ^ W[t-16]);
	}

	A = context->Message_Digest[0];
	B = context->Message_Digest[1];
	C = context->Message_Digest[2];
	D = context->Message_Digest[3];
	E = context->Message_Digest[4];

	for(t = 0; t < 20; t++)
	{
		temp =	SHA1CircularShift(5,A) +
				((B & C) | ((~B) & D)) + E + W[t] + K[0];
		temp &= 0xFFFFFFFF;
		E = D;
		D = C;
		C = SHA1CircularShift(30,B);
		B = A;
		A = temp;
	}

	for(t = 20; t < 40; t++)
	{
		temp = SHA1CircularShift(5,A) + (B ^ C ^ D) + E + W[t] + K[1];
		temp &= 0xFFFFFFFF;
		E = D;
		D = C;
		C = SHA1CircularShift(30,B);
		B = A;
		A = temp;
	}

	for(t = 40; t < 60; t++)
	{
		temp = SHA1CircularShift(5,A) +
			   ((B & C) | (B & D) | (C & D)) + E + W[t] + K[2];
		temp &= 0xFFFFFFFF;
		E = D;
		D = C;
		C = SHA1CircularShift(30,B);
		B = A;
		A = temp;
	}

	for(t = 60; t < 80; t++)
	{
		temp = SHA1CircularShift(5,A) + (B ^ C ^ D) + E + W[t] + K[3];
		temp &= 0xFFFFFFFF;
		E = D;
		D = C;
		C = SHA1CircularShift(30,B);
		B = A;
		A = temp;
	}

	context->Message_Digest[0] =
						(context->Message_Digest[0] + A) & 0xFFFFFFFF;
	context->Message_Digest[1] =
						(context->Message_Digest[1] + B) & 0xFFFFFFFF;
	context->Message_Digest[2] =
						(context->Message_Digest[2] + C) & 0xFFFFFFFF;
	context->Message_Digest[3] =
						(context->Message_Digest[3] + D) & 0xFFFFFFFF;
	context->Message_Digest[4] =
						(context->Message_Digest[4] + E) & 0xFFFFFFFF;

	context->Message_Block_Index = 0;
}

/*	
 *	SHA1PadMessage
 *
 *	Description:
 *		According to the standard, the message must be padded to an even
 *		512 bits.  The first padding bit must be a '1'.  The last 64
 *		bits represent the length of the original message.	All bits in
 *		between should be 0.  This function will pad the message
 *		according to those rules by filling the Message_Block array
 *		accordingly.  It will also call SHA1ProcessMessageBlock()
 *		appropriately.	When it returns, it can be assumed that the
 *		message digest has been computed.
 *
 *	Parameters:
 *		context: [in/out]
 *			The context to pad
 *
 *	Returns:
 *		Nothing.
 *
 *	Comments:
 *
 */
void SHA1PadMessage(SHA1Context *context)
{
	/*
	 *	Check to see if the current message block is too small to hold
	 *	the initial padding bits and length.  If so, we will pad the
	 *	block, process it, and then continue padding into a second
	 *	block.
	 */
	if (context->Message_Block_Index > 55)
	{
		context->Message_Block[context->Message_Block_Index++] = 0x80;
		while(context->Message_Block_Index < 64)
		{
			context->Message_Block[context->Message_Block_Index++] = 0;
		}

		SHA1ProcessMessageBlock(context);

		while(context->Message_Block_Index < 56)
		{
			context->Message_Block[context->Message_Block_Index++] = 0;
		}
	}
	else
	{
		context->Message_Block[context->Message_Block_Index++] = 0x80;
		while(context->Message_Block_Index < 56)
		{
			context->Message_Block[context->Message_Block_Index++] = 0;
		}
	}

	/*
	 *	Store the message length as the last 8 octets
	 */
	context->Message_Block[56] = (context->Length_High >> 24) & 0xFF;
	context->Message_Block[57] = (context->Length_High >> 16) & 0xFF;
	context->Message_Block[58] = (context->Length_High >> 8) & 0xFF;
	context->Message_Block[59] = (context->Length_High) & 0xFF;
	context->Message_Block[60] = (context->Length_Low >> 24) & 0xFF;
	context->Message_Block[61] = (context->Length_Low >> 16) & 0xFF;
	context->Message_Block[62] = (context->Length_Low >> 8) & 0xFF;
	context->Message_Block[63] = (context->Length_Low) & 0xFF;

	SHA1ProcessMessageBlock(context);
}


/*	
 *	SHA1_Reset
 *
 *	Description:
 *		This function will initialize the SHA1Context in preparation
 *		for computing a new message digest.
 *
 *	Parameters:
 *		context: [in/out]
 *			The context to reset.
 *
 *	Returns:
 *		Nothing.
 *
 *	Comments:
 *
 */
void SHA1_Reset(SHA1Context *context)
{
	context->Length_Low 			= 0;
	context->Length_High			= 0;
	context->Message_Block_Index	= 0;

	context->Message_Digest[0]		= 0x67452301;
	context->Message_Digest[1]		= 0xEFCDAB89;
	context->Message_Digest[2]		= 0x98BADCFE;
	context->Message_Digest[3]		= 0x10325476;
	context->Message_Digest[4]		= 0xC3D2E1F0;

	context->Computed	= 0;
	context->Corrupted	= 0;
}

/*	
 *	SHA1_Result
 *
 *	Description:
 *		This function will return the 160-bit message digest into the
 *		Message_Digest array within the SHA1Context provided
 *
 *	Parameters:
 *		context: [in/out]
 *			The context to use to calculate the SHA-1 hash.
 *
 *	Returns:
 *		1 if successful, 0 if it failed.
 *
 *	Comments:
 *
 */
int SHA1_Result(SHA1Context *context)
{

	if (context->Corrupted)
	{
		return 0;
	}

	if (!context->Computed)
	{
		SHA1PadMessage(context);
		context->Computed = 1;
	}

	return 1;
}

/*	
 *	SHA1_Input
 *
 *	Description:
 *		This function accepts an array of octets as the next portion of
 *		the message.
 *
 *	Parameters:
 *		context: [in/out]
 *			The SHA-1 context to update
 *		message_array: [in]
 *			An array of characters representing the next portion of the
 *			message.
 *		length: [in]
 *			The length of the message in message_array
 *
 *	Returns:
 *		Nothing.
 *
 *	Comments:
 *
 */
void SHA1_Input( SHA1Context 	*context,const unsigned char *message_array, unsigned length)
{
	if (!length)
	{
		return;
	}

	if (context->Computed || context->Corrupted)
	{
		context->Corrupted = 1;
		return;
	}

	while(length-- && !context->Corrupted)
	{
		context->Message_Block[context->Message_Block_Index++] =
												(*message_array & 0xFF);

		context->Length_Low += 8;
		/* Force it to 32 bits */
		context->Length_Low &= 0xFFFFFFFF;
		if (context->Length_Low == 0)
		{
			context->Length_High++;
			/* Force it to 32 bits */
			context->Length_High &= 0xFFFFFFFF;
			if (context->Length_High == 0)
			{
				/* Message is too long */
				context->Corrupted = 1;
			}
		}

		if (context->Message_Block_Index == 64)
		{
			SHA1ProcessMessageBlock(context);
		}

		message_array++;
	}
}

#ifdef DEBUG_SHA1_FUNC
/*  
 *  usage
 *
 *  Description:
 *      This function will display program usage information to the
 *      user.
 *
 *  Parameters:
 *      None.
 *
 *  Returns:
 *      Nothing.
 *
 *  Comments:
 *
 */
void usage()
{
    printf("usage: sha <file> [<file> ...]\n");
    printf("\tThis program will display the message digest\n");
    printf("\tfor files using the Secure Hashing Algorithm (SHA-1).\n");
}


int main(int argc, char *argv[])
{
    SHA1Context sha;                /* SHA-1 context                 */
    FILE        *fp;                /* File pointer for reading files*/
    char        c;                  /* Character read from file      */
    int         i;                  /* Counter                       */
    int         reading_stdin;      /* Are we reading standard in?   */
    int         read_stdin = 0;     /* Have we read stdin?           */

    /*
     *  Check the program arguments and print usage information if -?
     *  or --help is passed as the first argument.
     */
    if (argc > 1 && (!strcmp(argv[1],"-?") ||
        !strcmp(argv[1],"--help")))
    {
        usage();
        return 1;
    }

    /*
     *  For each filename passed in on the command line, calculate the
     *  SHA-1 value and display it.
     */
    for(i = 0; i < argc; i++)
    {
        /*
         *  We start the counter at 0 to guarantee entry into the for
         *  loop. So if 'i' is zero, we will increment it now.  If there
         *  is no argv[1], we will use STDIN below.
         */
        if (i == 0)
        {
            i++;
        }

        if (argc == 1 || !strcmp(argv[i],"-"))
        {
#ifdef WIN32
            setmode(fileno(stdin), _O_BINARY);
#endif
            fp = stdin;
            reading_stdin = 1;
        }
        else
        {
            if (!(fp = fopen(argv[i],"rb")))
            {
                fprintf(stderr, "sha: unable to open file %s\n",argv[i]);
                return 2;
            }
            reading_stdin = 0;
        }

        /*
         *  We do not want to read STDIN multiple times
         */
        if (reading_stdin)
        {
            if (read_stdin)
            {
                continue;
            }

            read_stdin = 1;
        }

        /*
         *  Reset the SHA-1 context and process input
         */
        SHA1_Reset(&sha);

        c = fgetc(fp);
        while(!feof(fp))
        {
            SHA1_Input(&sha, &c, 1);
            c = fgetc(fp);
        }

        if (!reading_stdin)
        {
            fclose(fp);
        }

        if (!SHA1_Result(&sha))
        {
            fprintf(stderr,
                    "sha: could not compute message digest for %s\n",
                    reading_stdin?"STDIN":argv[i]);
        }
        else
        {
            printf( "%08X %08X %08X %08X %08X - %s\n",
                    sha.Message_Digest[0],
                    sha.Message_Digest[1],
                    sha.Message_Digest[2],
                    sha.Message_Digest[3],
                    sha.Message_Digest[4],
                    reading_stdin?"STDIN":argv[i]);
        }
    }

    return 0;
}


#endif

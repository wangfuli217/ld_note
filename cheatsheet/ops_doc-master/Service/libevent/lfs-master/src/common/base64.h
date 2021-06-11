#ifndef _BASE64_H_
#define _BASE64_H_

#ifdef __cplusplus
extern "C"{
#endif
	int Base64decode(char *bufplain, const char *bufcoded);
	int Base64encode(char *out, const char *in, unsigned int inlen);
#ifdef __cplusplus
}
#endif
#endif

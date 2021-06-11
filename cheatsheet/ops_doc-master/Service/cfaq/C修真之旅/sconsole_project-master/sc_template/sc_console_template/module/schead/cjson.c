#include <cjson.h>
#include <schead.h>
#include <sclog.h>
#include <tstring.h>
#include <float.h>
#include <limits.h>
#include <math.h>

// ɾ��cjson
static void __cjson_delete(cjson_t c)
{
	cjson_t next;
	while (c) {
		next = c->next;
		//�ݹ�ɾ������
		if (!(c->type & _CJSON_ISREF)) {
			if (c->child) //�������β�ݹ�,�Ǿ��ȵݹ�
				__cjson_delete(c->child);
			if (c->vs)
				free(c->vs);
		}
		else if (!(c->type & _CJSON_ISCONST) && c->key)
			free(c->key);
		free(c);
		c = next;
	}
}

/*
*  ɾ��json������,����������廪����ѧ�����, ��������......
* c		: ���ͷ�json_t������
*/
void 
cjson_delete(cjson_t* pc)
{
	if (!pc || !*pc)
		return;
	__cjson_delete(*pc);
	*pc = NULL;
}

//����һ���� cjson ����
static inline cjson_t __cjson_new(void)
{
	cjson_t c = calloc(1, sizeof(struct cjson));
	if (!c) {
		SL_FATAL("calloc sizeof struct cjson error!");
		exit(_RT_EM);
	}
	return c;
}

// �򻯵Ĵ����,�ú����򻯴�����д , 16���ƴ���
#define __parse_hex4_code(c, h) \
	if (c >= '0' && c <= '9') \
		h += c - '0'; \
	else if (c >= 'A' && c <= 'F') \
		h += 10 + c - 'A'; \
	else if (c >= 'a' && c <= 'z') \
		h += 10 + c - 'F'; \
	else \
		return 0

// �ȵ�unicode char����
static unsigned __parse_hex4(const char* str)
{
	unsigned h = 0;
	char c = *str;
	//��һ��
	__parse_hex4_code(c, h);
	h <<= 4;
	c = *++str;
	//�ڶ���
	__parse_hex4_code(c, h);
	h <<= 4;
	c = *++str;
	//������
	__parse_hex4_code(c, h);
	h <<= 4;
	c = *++str;
	//������
	__parse_hex4_code(c, h);

	return h;
}

// �����ַ������Ӻ���,
static const char* __parse_string(cjson_t item, const char* str)
{
	static unsigned char __marks[] = { 0x00, 0x00, 0xC0, 0xE0, 0xF0, 0xF8, 0xFC };
	const char *ptr;
	char *nptr, *out;
	int len;
	char c;
	unsigned uc, nuc;

	if (*str != '\"') { // ����Ƿ����ַ�������
		SL_WARNING("need \\\" str => %s error!", str);
		return NULL;
	}

	for (ptr = str + 1, len = 0; (c = *ptr++) != '\"' && c; ++len)
		if (c == '\\') //����ת���ַ�
			++ptr;
	if (!(out = malloc(len + 1))) {
		SL_FATAL("malloc %d size error!", len + 1);
		return NULL;
	}
	// ���︴�ƿ�������
	for (ptr = str + 1, nptr = out; (c = *ptr) != '\"' && c; ++ptr) {
		if (c != '\\') {
			*nptr++ = c;
			continue;
		}
		// ����ת���ַ�
		switch ((c = *++ptr)) {
		case 'b': *nptr++ = '\b'; break;
		case 'f': *nptr++ = '\f'; break;
		case 'n': *nptr++ = '\n'; break;
		case 'r': *nptr++ = '\r'; break;
		case 't': *nptr++ = '\t'; break;
		case 'u': // ��utf16 => utf8, ר�ŵ�utf�������
			uc = __parse_hex4(ptr + 1);
			ptr += 4;//���������ĸ��ַ�, unicode
			if ((uc >= 0xDC00 && uc <= 0xDFFF) || uc == 0)	break;	/* check for invalid.	*/

			if (uc >= 0xD800 && uc <= 0xDBFF)	/* UTF16 surrogate pairs.	*/
			{
				if (ptr[1] != '\\' || ptr[2] != 'u')	
					break;	/* missing second-half of surrogate.	*/
				nuc = __parse_hex4(ptr + 3);
				ptr += 6;
				if (nuc < 0xDC00 || nuc>0xDFFF)		
					break;	/* invalid second-half of surrogate.	*/
				uc = 0x10000 + (((uc & 0x3FF) << 10) | (nuc & 0x3FF));
			}

			len = 4;
			if (uc < 0x80) 
				len = 1;
			else if (uc < 0x800) 
				len = 2;
			else if (uc < 0x10000) 
				len = 3; 
			nptr += len;

			switch (len) {
			case 4: *--nptr = ((uc | 0x80) & 0xBF); uc >>= 6;
			case 3: *--nptr = ((uc | 0x80) & 0xBF); uc >>= 6;
			case 2: *--nptr = ((uc | 0x80) & 0xBF); uc >>= 6;
			case 1: *--nptr = (uc | __marks[len]);
			}
			nptr += len;
			break;
		default: *nptr++ = c;
		}
	}

	*nptr = '\0';
	if (c == '\"')
		++ptr;
	item->vs = out;
	item->type = _CJSON_STRING;
	return ptr;
}

// ������ֵ���Ӻ���,д�Ŀ���
static const char* __parse_number(cjson_t item, const char* str)
{
	double n = 0.0, ns = 1.0, nd = 0.0; //n��ż����ֵ, ns��ʾ��ʼ����, ��Ϊ-1, nd ��ʾС������λ��
	int e = 0, es = 1; //e��ʾ����ָ��, es��ʾ ָ��������,��Ϊ-1
	char c;

	if ((c = *str) == '-' || c == '+') {
		ns = c == '-' ? -1.0 : 1.0; //�����ż��, 1��ʾ����
		++str;
	}
	//������������
	for (c = *str; c >= '0' && c <= '9'; c = *++str)
		n = n * 10 + c - '0';
	if (c == '.')
		for (; (c = *++str) >= '0' && c <= '9'; --nd)
			n = n * 10 + c - '0';

	// �����ѧ������
	if (c == 'e' || c == 'E') {
		if ((c = *++str) == '+') //����ָ������
			++str;
		else if (c == '-')
			es = -1, ++str;
		for (; (c = *str) >= '0' && c <= '9'; ++str)
			e = e * 10 + c - '0';
	}

	//�������ս�� number = +/- number.fraction * 10^+/- exponent
	n = ns * n * pow(10.0, nd + es * e);
	item->vd = n;
	item->type = _CJSON_NUMBER;
	return str;
}

// ��������Ҫ������ַ�
static const char* __skip(const char* in)
{
	if (in && *in && *in <= 32) {
		unsigned char c;
		while ((c = *++in) && c <= 32)
			;
	}
	return in;
}

// �ݹ��½����� ��Ҫ������Щ����
static const char* __parse_array(cjson_t item, const char* str);
static const char* __parse_object(cjson_t item, const char* str);
static const char* __parse_value(cjson_t item, const char* value);

// ����������Ӻ���, ���õݹ��½�����
static const char* __parse_array(cjson_t item, const char* str)
{
	cjson_t child;
	if (*str != '[') {
		SL_WARNING("array str error start: %s.", str);
		return NULL;
	}

	item->type = _CJSON_ARRAY;
	str = __skip(str + 1);
	if (*str == ']') // �͹���ǰ����
		return str + 1;

	item->child = child = __cjson_new();
	str = __skip(__parse_value(child, str));
	if (!str) {//����ʧ�� ֱ�ӷ���
		SL_WARNING("array str error e n d one: %s.", str);
		return NULL;
	}
	while (*str == ',') {
		cjson_t nitem = __cjson_new();
		child->next = nitem;
		nitem->prev = child;
		child = nitem;
		str = __skip(__parse_value(child, __skip(str + 1)));
		if (!str) {// д������һ����ˬ����
			SL_WARNING("array str error e n d two: %s.", str);
			return NULL;
		}
	}

	if (*str != ']') {
		SL_WARNING("array str error e n d: %s.", str);
		return NULL;
	}
	return str + 1; // ����']'
}

// ����������Ӻ���
static const char* __parse_object(cjson_t item, const char* str)
{
	cjson_t child;
	if (*str != '{') {
		SL_WARNING("object str error start: %s.", str);
		return NULL;
	}

	item->type = _CJSON_OBJECT;
	str = __skip(str + 1);
	if (*str == '}')
		return str + 1;

	//������, ��ʼ��ȡһ�� key
	item->child = child = __cjson_new();
	str = __skip(__parse_string(child, str));
	if (!str || *str != ':') {
		SL_WARNING("__skip __parse_string is error : %s!", str);
		return NULL;
	}
	child->key = child->vs;
	child->vs = NULL;

	str = __skip(__parse_value(child, __skip(str + 1)));
	if (!str) {
		SL_WARNING("__skip __parse_string is error 2!");
		return NULL;
	}

	// �ݹ����
	while (*str == ',') {
		cjson_t nitem = __cjson_new();
		child->next = nitem;
		nitem->prev = child;
		child = nitem;
		str = __skip(__parse_string(child, __skip(str + 1)));
		if (!str || *str != ':'){
			SL_WARNING("__parse_string need name or no equal ':' %s.", str);
			return NULL;
		}
		child->key = child->vs;
		child->vs = NULL;

		str = __skip(__parse_value(child, __skip(str+1)));
		if (!str) {
			SL_WARNING("__parse_string need item two ':' %s.", str);
			return NULL;
		}
	}

	if (*str != '}') {
		SL_WARNING("object str error e n d: %s.", str);
		return NULL;
	}
	return str + 1;
}

// ��value ת������ item jsonֵ��һ����
static const char* __parse_value(cjson_t item, const char* value)
{
	char c; 
	if ((value) && (c = *value)) {
		switch (c) {
			// n = null, f = false, t = true
		case 'n' : return item->type = _CJSON_NULL, value + 4;
		case 'f' : return item->type = _CJSON_FALSE, value + 5;
		case 't' : return item->type = _CJSON_TRUE, item->vd = 1.0, value + 4;
		case '\"': return __parse_string(item, value);
		case '0' : case '1': case '2': case '3': case '4': case '5': case '6': case '7': case '8': case '9':
		case '+' : case '-': return __parse_number(item, value);
		case '[' : return __parse_array(item, value);
		case '{' : return __parse_object(item, value);
		}
	}
	// ѭ�������������� ����
	SL_WARNING("params value = %s!", value);
	return NULL;
}

/*
* ��json�ַ����������ؽ�����Ľ��
* jstr		: ���������ַ���
*			: ���ؽ����õ��ַ�������
*/
cjson_t 
cjson_parse(const char* jstr)
{
	cjson_t c = __cjson_new();
	const char* end;

	if (!(end = __parse_value(c, __skip(jstr)))) {
		SL_WARNING("__parse_value params end = %s!", end);
		cjson_delete(&c);
		return NULL;
	}

	//�����Ƿ��� ���ز�������
	return c;
}

/*
* ���� item��ǰ���� next һֱѰ�ҵ� NULL, ���ظ���
*�Ƽ�������ʹ��
* array	: �������cjson_t�������
*			: ������������г���
*/
int 
cjson_getlen(cjson_t array)
{
	int len = 0;
	if (array)
		for (array = array->child; array; array = array->next)
			++len;

	return len;
}

/*
* ���������õ���������ж���
* array	: �������
* idx		: ���ҵ����� ���� [0,cjson_getlen(array)) ��Χ��
*			: ���ز��ҵ��ĵ�ǰ����
*/
cjson_t 
cjson_getarray(cjson_t array, int idx)
{
	cjson_t c;
	DEBUG_CODE({
		if (!array || idx < 0) {
			SL_FATAL("array:%p, idx=%d params is error!", array, idx);
			return NULL;
		}
	});

	for (c = array->child; c&&idx > 0; c = c->next)
		--idx;

	return c;
}

/*
* ����key�õ�������� ��Ӧλ�õ�ֵ
* object	: �����������ֵ
* key		: Ѱ�ҵ�key
*			: ���� ���� cjson_t ����
*/
cjson_t 
cjson_getobject(cjson_t object, const char* key)
{
	cjson_t c;
	DEBUG_CODE({
		if (!object || !key || !*key) {
			SL_FATAL("object:%p, key=%s params is error!", object, key);
			return NULL;
		}
	});

	for (c = object->child; c && str_icmp(key, c->key); c = c->next)
		;

	return c;
}

// --------------------------------- ������ cjson ������ֵĴ������ -----------------------------------------

// 2^n>=x , n����С������
static int __pow2gt(int x)
{
	--x;
	x |= x >> 1;
	x |= x >> 2;
	x |= x >> 4;
	x |= x >> 8;
	x |= x >> 16;
	return x + 1;
}

/*
 *	 ����ʹ�� tstring �ṹ size �����ʾ �ַ����ܴ�С,û�б仯
 * len ��ʾ��ǰ�ַ������ַ�����ʼƫ���� �� tstring->str + tstring->len ��ʼ��
 */
static char* __ensure(tstring p, int need)
{
	char* nbuf;
	int nsize;
	if (!p || !p->str) {
		SL_FATAL("p:%p need:%p is error!", p, need);
		return NULL;
	}
	need += p->len;
	if (need <= p->size) //�ڴ湻��ֱ�ӷ��ؽ��
		return p->str + p->len;
	nsize = __pow2gt(need);
	if ((nbuf = malloc(nsize*sizeof(char))) == NULL) {
		free(p->str);
		p->size = p->len = 0;
		p->str = NULL;
		SL_FATAL("malloc nsize = %d error!", nsize);
		return NULL;
	}
	//���︴������
	memcpy(nbuf, p->str, p->size);
	free(p->str);
	p->size = nsize;
	p->str = nbuf;
	return nbuf + p->len;
}

// �������һ�� ��ǰ�ַ���, ���ص�ǰ�ַ����ĳ���
inline static int __update(tstring p) 
{
	return (!p || !p->str) ? 0 : p->len + (int)strlen(p->str+p->len);
}

// ��item ��ֵת�����ַ��� ���浽p��
static char* __print_number(cjson_t item, tstring p)
{
	char* str = NULL;
	double d = item->vd;
	int i = (int)d;
	
	if (d == 0) {  //��ͨ0
		str = __ensure(p, 2);
		if (str)
			str[0] = '0', str[1] = '\0';
	}
	else if ((fabs(d - i)) <= DBL_EPSILON && d <= INT_MAX && d >= INT_MIN) {
		str = __ensure(p, 21); //int ֵ 
		if (str)
			sprintf(str, "%d", i);
	}
	else {
		str = __ensure(p, 64); //doubleֵ 
		if (str) {
			double nd = fabs(d); //�õ���ֵ��ʼ�Ƚ�
			if(fabs(floor(d) - d) <= DBL_EPSILON && nd < 1.0e60)
				sprintf(str, "%.0f", d);
			else if(nd < 1.0e-6 || nd > 1.0e9) //��ѧ������
				sprintf(str, "%e", d);
			else
				sprintf(str, "%f", d);

		}
	}

	return str;
}

// ����ַ�������
static char* __print_string(char* str, tstring p)
{
	const char* ptr;
	char *nptr, *out;
	int len = 0, flag = 0;
	unsigned char c;

	if (!str || !*str) { //���������,ʲô��û�� ����NULL
		out = __ensure(p, 3);
		if (!out)
			return NULL;
		out[0] = '\"', out[1] = '\"', out[2] = '\0';
		return out;
	}


	for (ptr = str; (c=*ptr); ++ptr)
		flag |= ((c > 0 && c < 32) || c == '\"' || c == '\\');
	
	if (!flag) {  //û�������ַ�ֱ�Ӵ�����
		len = (int)(ptr - str);
		out = __ensure(p,len + 3);
		if (!out)
			return NULL;
		nptr = out;
		*nptr++ = '\"';
		strcpy(nptr, str);
		nptr[len] = '\"';
		nptr[len + 1] = '\0';
		return out;
	}

	//���� ���� "��ת���ַ�����
	for (ptr = str; (c = *ptr) && ++len; ++ptr) {
		if (strchr("\"\\\b\f\n\r\t", c))
			++len;
		else if (c < 32) //�����ַ��Ĵ���, ������Ը�
			len += 5;
	}

	if ((out = __ensure(p, len + 3)) == NULL)
		return NULL;
	//����� \"
	nptr = out;
	*nptr++ = '\"';
	for (ptr = str; (c = *ptr); ++ptr) {
		if (c > 31 && c != '\"' && c != '\\') {
			*nptr++ = c;
			continue;
		}
		*nptr++ = '\\';
		switch (c){
		case '\\':	*nptr++ = '\\';	break;
		case '\"':	*nptr++ = '\"';	break;
		case '\b':	*nptr++ = 'b';	break;
		case '\f':	*nptr++ = 'f';	break;
		case '\n':	*nptr++ = 'n';	break;
		case '\r':	*nptr++ = 'r';	break;
		case '\t':	*nptr++ = 't';	break;
		default: sprintf(nptr, "u%04x", c);nptr += 5;	/* ���ɼ��ַ� ���� 4�ֽ��ַ����� */
		}
	}
	*nptr++ = '\"';
	*nptr = '\0';
	return out;
}

//������ �ݹ��½� �ĺ���������, �ֱ��Ǵ���ֵ, ����, object
static char* __print_value(cjson_t item, tstring p);
static char* __print_array(cjson_t item, tstring p);
static char* __print_object(cjson_t item, tstring p);

// ����ʵ�ֲ���, �ڲ�˽�к��� ��Ϊ item �� p���Ǵ��ڵ�
static char* __print_value(cjson_t item, tstring p) 
{
	char* out = NULL;
	switch ((item->type) & UCHAR_MAX) { // 0xff
	case _CJSON_FALSE: if ((out = __ensure(p, 6))) strcpy(out, "false"); break;
	case _CJSON_TRUE: if ((out = __ensure(p, 5))) strcpy(out, "true"); break;
	case _CJSON_NULL: if ((out = __ensure(p, 5))) strcpy(out, "null"); break;
	case _CJSON_NUMBER:	out = __print_number(item, p); break;
	case _CJSON_STRING:	out = __print_string(item->vs, p); break;
	case _CJSON_ARRAY:	out = __print_array(item, p); break;
	case _CJSON_OBJECT:	out = __print_object(item, p); break;
	}

	return out;
}

// ͬ�� �ٶ� item �� p���Ǵ����Ҳ�ΪNULL
static char* __print_array(cjson_t item, tstring p)
{
	char* ptr;
	cjson_t child = item->child;
	int ncut, i;
	// �õ����ӽ������
	for (ncut = 0; (child); child = child->child)
		++ncut;
	if (!ncut) { //û�к��ӽ�� ֱ�ӿ����鷵�ؽ��
		char* out = NULL;
		if (!(out = __ensure(p, 3))) 
			strcpy(out, "[]");
		return out;
	}

	i = p->len;
	if (!(ptr = __ensure(p, 1)))
		return NULL;
	*ptr = '[';
	++p->len;
	for (child = item->child; (child); child = child->next) {
		__print_value(child, p);
		p->len = __update(p);
		if (child->next) {
			if (!(ptr = __ensure(p, 2)))
				return NULL;
			*ptr++ = ',';
			*ptr = '\0';
			p->len += 1;
		}
	}
	if (!(ptr = __ensure(p, 2)))
		return NULL;
	*ptr++ = ']';
	*ptr = '\0';
	return p->str + i;

}

// ͬ�� �ٶ� item �� p���Ǵ����Ҳ�ΪNULL, ������Щ�����ǰ�ȫ��
static char* __print_object(cjson_t item, tstring p)
{
	char* ptr;
	int i, ncut, len;
	cjson_t child = item->child;

	// �õ����ӽ������
	for (ncut = 0; child; child = child->child)
		++ncut;
	if (!ncut) {
		char* out = NULL;
		if (!(out = __ensure(p, 3)))
			strcpy(out, "{}");
		return out;
	}

	i = p->len;
	if (!(ptr = __ensure(p, 2)))
		return NULL;
	*ptr++ = '{';
	*ptr -= '\0';
	p->len += 1;
	// �����ӽ�� ����
	for (child = item->child; (child); child = child->next) {
		__print_string(child->key, p);
		p->len = __update(p);

		//����һ��ð��
		if (!(ptr = __ensure(p, 1)))
			return NULL;
		*ptr++ = ':';
		p->len += 1;

		//������ӡһ��ֵ
		__print_value(child, p);
		p->len = __update(p);

		//�����������
		len = child->next ? 1 : 0;
		if ((ptr = __ensure(p, len + 1)) == NULL)
			return NULL;
		if (child->next)
			*ptr++ = ',';
		*ptr = '\0';
		p->len += len;
	}
	if (!(ptr = __ensure(p, 2)))
		return NULL;
	*ptr++ = '}';
	*ptr = '\0';
	return p->str + i;
}

#define _INT_CJONSTR	(256)
/*
*  �����ǽ� cjson_t item ת�����ַ�������,��Ҫ�Լ�free
* item		: cjson�ľ�����
*			: �������ɵ�item��json������
*/
char* 
cjson_print(cjson_t item)
{
	struct tstring p;
	char* out;
	if ((!item) || !(p.str = malloc(sizeof(char)*_INT_CJONSTR))) {
		SL_FATAL("item:%p, p.str = malloc is error!", item);
		return NULL;
	}
	p.size = _INT_CJONSTR;
	p.len = 0;

	out = __print_value(item, &p); //��ֵ����ʼ, �������ս��
	if (out == NULL) {
		free(p.str);
		SL_FATAL("__print_value item:%p, p:%p is error!", item, &p);
		return NULL;
	}
	return realloc(out,strlen(out) + 1); // �����С realloc����һ���ɹ�
}

// --------------------------------- ������ cjson ������ֵĸ������� -----------------------------------------

/*
 * ����һ��bool�Ķ��� b==0��ʾfalse,������true, ��Ҫ�Լ��ͷ� cjson_delete
 * b		: bool ֵ ����� _Bool
 *			: ���� �����õ�json ����
 */
cjson_t 
cjson_newnull()
{
	cjson_t item = __cjson_new();
	item->type = _CJSON_NULL; 
	return item;
}

cjson_t 
cjson_newbool(int b)
{
	cjson_t item = __cjson_new();
	item->vd = item->type = b ? _CJSON_TRUE : _CJSON_FALSE; 
	return item;
}

cjson_t 
cjson_newnumber(double vd)
{
	cjson_t item = __cjson_new();
	item->type = _CJSON_NUMBER;
	item->vd = vd;
	return item;
}

cjson_t 
cjson_newstring(const char* vs)
{
	cjson_t item = __cjson_new();
	item->type = _CJSON_STRING;
	item->vs = str_dup(vs);
	return item;
}

cjson_t 
cjson_newarray(void)
{
	cjson_t item = __cjson_new();
	item->type = _CJSON_ARRAY;
	return item;
}

cjson_t 
cjson_newobject(void)
{
	cjson_t item = __cjson_new();
	item->type = _CJSON_OBJECT;
	return item;
}

/*
 * ��������,���� ��ӳ���͵����� cjson����
 *Ŀǰ֧�� _CJSON_NULL _CJSON_BOOL/FALSE or TRUE , _CJSON_NUMBER, _CJSON_STRING
 * NULL => array ����NULL, FALSE ʹ��char[],Ҳ���Դ���NULL, NUMBER ֻ����double, string ֻ����char**
 * type		: ����Ŀǰ֧�� ���漸������
 * array	: ����ԭʼ����
 * len		: ������Ԫ�س���
 *			: ���ش������������
 */
cjson_t 
cjson_newtypearray(int type, const void* array, int len)
{
	int i;
	cjson_t n = NULL, p = NULL, a;
	// _DEBUG ģʽ�¼򵥼��һ��
	DEBUG_CODE({
		if(type < _CJSON_FALSE || type > _CJSON_STRING || len <=0){
			SL_FATAL("check param is error! type = %d, len = %d.", type, len);
			return NULL;
		}
	});
	
	// ������ʵ��ִ�д���
	a = cjson_newarray();
	for(i=0; i<len; ++i){
		switch(type){
		case _CJSON_NULL: n = cjson_newnull(); break;
		case _CJSON_FALSE: n = cjson_newbool(array? ((char*)array)[i] : 0); break;
		case _CJSON_TRUE: n = cjson_newbool(array? ((char*)array)[i] : 1); break;
		case _CJSON_NUMBER: n = cjson_newnumber(((double*)array)[i]); break;
		case _CJSON_STRING: n = cjson_newstring(((char**)array)[i]);break;
		}
		if(i){ //�������
			p->next = n;
			n->prev = p;
		}
		else
			a->child = n;
		p = n;
	}
	return a;
}

/*
 * �� jstr�� ����Ҫ�������ַ�����ȥ��,���Ҽ���mini ���еĻ�ƽ
 * jstr		: �������json��
 *			: ����ѹ�����json������
 */
char* 
cjson_mini(char* jstr)
{
	char* in = jstr;
	char* to = jstr;
	char c;
	while(!!(c=*to)){
		if(sh_isspace(c)) ++to;
		else if(c == '/' && to[1] == '/') while((c=*++to) && c!='\n');
		else if(c == '/' && to[1] == '*'){
			while((c=*++to) && !(c=='*' && to[1] =='/'))
				;
			if(c) to+=2;
		}
		else if(c=='"'){
			*in++ = c;
			while((c=*++to) && (c!='"' || to[-1]=='\\'))
				*in++ = c;
			if(c) {
				*in++=c;
				++to;
			}
		}
		else
			*in++ = *to++;
	}
	
	*in = '\0';
	return jstr;
}

/*
 *	��json�ļ�������json���ݷ���, ��Ҫ�Լ����� cjson_delete
 * jpath	: json��·��
 *			: ���ش���õ�cjson_t ����,ʧ�ܷ���NULL
 */
cjson_t 
cjson_dofile(char* jpath)
{
	cjson_t root;
	tstring tstr = file_malloc_readend(jpath);
	if(!tstr){
		SL_WARNING("readend jpath:%s is error!", jpath);
		return NULL;
	}
	root = cjson_parse(tstr->str);
	tstring_destroy(&tstr);
	return root;
}

/*
 * ��array�з����idx������������.
 * array	: �������json_t ��������
 * idx		: ��������
 *			: ���ط����json_t����
 */
cjson_t 
cjson_detacharray(cjson_t array, int idx)
{
	cjson_t c;
	DEBUG_CODE({
		if(!array || idx<0){
			SL_WARNING("check param is array:%p, idx:%d.", array, idx);
			return NULL;
		}
	});
	
	for(c=array->child; idx>0 && c; c = c->next)
		--idx;
	if(c>0){
		SL_WARNING("check param is too dig idx:sub %d.", idx);
		return NULL;
	}
	//���￪ʼƴ����
	if(c->prev)
		c->prev->next = c->next;
	if(c->next)
		c->next->prev = c->prev;
	if(c == array->child)
		array->child = c->next;
	c->prev = c->next = NULL;
	return c;
}

/*
 * ��object json �з��� key �����ȥ
 * object	: ������Ķ�����������
 * key		: �����ļ�
 *			: ���ط���� object�� key����json_t
 */
cjson_t 
cjson_detachobject(cjson_t object, const char* key)
{
	cjson_t c;
	DEBUG_CODE({
		if(!object || !object->child || !key || !*key){
			SL_WARNING("check param is object:%p, key:%s.", object, key);
			return NULL;
		}
	});
	
	for(c=object->child; c && str_icmp(c->key, key); c=c->next)
		;
	if(!c) {
		SL_WARNING("check param key:%s => vlaue is empty.", key);
		return NULL;
	}
	if(c->prev)
		c->prev->next = c->next;
	if(c->next)
		c->next->prev = c->prev;
	if(c == object->child)
		object->child = c->next;
	c->prev = c->next = NULL;
	return c;
}

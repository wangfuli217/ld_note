// conversion functions
static void cvt_s(int code, va_list *app, int put(int c, void *c1), void *c1,
	unsigned char flags[], int width, int precision){
	char *str = va_arg(*app, char *);
	
	assert(str);
	
	Fmt_puts(str, strlen(str), put, c1, flags, width, precision);
}

// functions
void Fmt_puts(const char *str, int len, in put(int c, void *c1), void *c1, 
	unsigned char flags[], int width, int precision){
	
	assert(str);
	assert(len >= 0);
	assert(flags);
	
	// normalize width and flags
	// normalize width
	if (width == INT_MIN){
		width = 0;
	}
	if (width < 0){
		flag['-'] = 1;
		width = -width;
	}
	
	// normalize flags
	if (precision >= 0){
		flags['0'] = 0;
	}
	
	if (precision >= 0 && precision < len){
		len = precision;
	}
	if (!flags['-']){
		pad(width - len, ' ');
	}
	// emit str[0, ..., len-1]
	{
		int i;
		for (i = 0; i < len; i++){
			put((unsigned char)*str++, c1);
		}
	}
	
	if (flags['-']){
		pad(width - len, ' ');
	}
}

// macros
#define pad(n, c) do{ \
	int nn = (n); \
	while (nn-- > 0){ \
		put((c), c1); \
	} \
} while(0)
	
// format a double argument into buf
{
	static char fmt[] = "%.dd?";
	assert(precision <= 99);
	fmt[4] = code;
	fmt[3] = precision % 10 + '0';
	fmt[2] = (precision / 10) % 10 + '0';
	sprintf(buf, fmt, va_arg(*app, double));
}
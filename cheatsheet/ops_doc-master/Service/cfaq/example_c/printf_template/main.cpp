#include <iostream>
#include <stdarg.h>

using namespace std;

void PRINTF(const char *format)
{
	cout << format;
}
template<typename T, typename...Args>
void PRINTF(const char *format, T t, Args...args)
{
	if (!format || *format == '\0')
		return;
	if (*format == '%')    //处理格式提示符
	{
		format++;
		char c = *format;
		if (c == 'd' || c == 'f' || c == 'c' || c == 'g')   //我们暂且只处理这几种
		{
			cout << t;
			format++;
			PRINTF(format, args...);
		}
		else if (c == '%')
		{
			cout << '%';
			format++;
			PRINTF(format, t, args...);
		}
		else
		{
			cout << *format;
			format++;
			PRINTF(format, t, args...);
		}
	}
	else
	{
		cout << *format;
		PRINTF(++format, t, args...);
	}
}
int main()
{
	PRINTF("%asdljl%5234la;jdfl;\n");
	PRINTF("%d alsd, %fasdf..%g..%c\n", 12, 3.4, 5.897, 'a');
	cin.get();
	return 0;
}




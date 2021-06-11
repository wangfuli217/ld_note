 2.10 stdarg.h

The stdarg header defines several macros used to get the arguments in a function when the number of arguments is not known.

Macros:

    va_start();
    va_arg();
    va_end();

Variables:

    typedef va_list 

2.10.1 Variables and Definitions

The va_list type is a type suitable for use in accessing the arguments of a function with the stdarg macros.

A function of variable arguments is defined with the ellipsis (,...) at the end of the parameter list.

2.10.2 va_start

Declaration:

    void va_start(va_list ap, last_arg); 

Initializes ap for use with the va_arg and va_end macros. last_arg is the last known fixed argument being passed to the function (the argument before the ellipsis).

Note that va_start must be called before using va_arg and va_end.

2.10.3 va_arg

Declaration:

    type va_arg(va_list ap, type); 

Expands to the next argument in the paramater list of the function with type type. Note that ap must be initialized with va_start. If there is no next argument, then the result is undefined.

2.10.4 va_end

Declaration:

    void va_end(va_list ap); 

Allows a function with variable arguments which used the va_start macro to return. If va_end is not called before returning from the function, the result is undefined. The variable argument list ap may no longer be used after a call to va_end without a call to va_start.

Example:

    #include<stdarg.h>
    #include<stdio.h>

    void sum(char *, int, ...);

    int main(void)
    {
      sum("The sum of 10+15+13 is %d.\n",3,10,15,13);
      return 0;
    }

    void sum(char *string, int num_args, ...)
    {
      int sum=0;
      va_list ap;
      int loop;

      va_start(ap,num_args);
      for(loop=0;loop<num_args;loop++)
        sum+=va_arg(ap,int);

      printf(string,sum);
      va_end(ap);
    }

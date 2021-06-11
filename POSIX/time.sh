2.15 time.h

The time header provides several functions useful for reading and converting the current time and date. Some functions behavior is defined by the LC_TIME category of the location setting.

Macros:

    NULL
    CLOCKS_PER_SEC 

Variables:

    typedef size_t
    typedef clock_t
    typedef size_t
    struct tm 

Functions:

    asctime();
    clock();
    ctime();
    difftime();
    gmtime();
    localtime();
    mktime();
    strftime();
    time(); 

2.15.1 Variables and Definitions

    NULL is the value of a null pointer constant.
    CLOCKS_PER_SEC is the number of processor clocks per second.

    size_t is the unsigned integer result of the sizeof keyword.
    clock_t is a type suitable for storing the processor time.
    time_t is a type suitable for storing the calendar time.

    struct tm is a structure used to hold the time and date. Its members are as follows:

         int tm_sec;    /* seconds after the minute (0 to 61) */
         int tm_min;    /* minutes after the hour (0 to 59) */
         int tm_hour;   /* hours since midnight (0 to 23) */
         int tm_mday;   /* day of the month (1 to 31) */
         int tm_mon;    /* months since January (0 to 11) */
         int tm_year;   /* years since 1900 */
         int tm_wday;   /* days since Sunday (0 to 6 Sunday=0) */
         int tm_yday;   /* days since January 1 (0 to 365) */
         int tm_isdst;  /* Daylight Savings Time */

If tm_isdst is zero, then Daylight Savings Time is not in effect. If it is a positive value, then Daylight Savings Time is in effect. If it is negative, then the function using it is requested to attempt to calculate whether or not Daylight Savings Time is in effect for the given time.

Note that tm_sec may go as high as 61 to allow for up to two leap seconds.
2.15.2 asctime

Declaration:

    char *asctime(const struct tm *timeptr); 

Returns a pointer to a string which represents the day and time of the structure timeptr. The string is in the following format:

    DDD MMM dd hh:mm:ss YYYY 

DDD	Day of the week (Sun, Mon, Tue, Wed, Thu, Fri, Sat)
MMM	Month of the year (Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec)
dd	Day of the month (1,...,31)
hh	Hour (0,...,23)
mm 	Minute (0,...,59)
ss	Second (0,...,59)
YYYY	Year
The string is terminated with a newline character and a null character. The string is always 26 characters long (including the terminating newline and null characters).

A pointer to the string is returned.

Example:

    #include<time.h>
    #include<stdio.h>

    int main(void)
    {
      time_t timer;

      timer=time(NULL);
      printf("The current time is %s.\n",asctime(localtime(&timer)));
      return 0;
    }

2.15.3 clock

Declaration:

    clock_t clock(void); 

Returns the processor clock time used since the beginning of an implementation-defined era (normally the beginning of the program). The returned value divided by CLOCKS_PER_SEC results in the number of seconds. If the value is unavailable, then -1 is returned.

Example:

    #include<time.h>
    #include<stdio.h>

    int main(void)
    {
      clock_t ticks1, ticks2;

      ticks1=clock();
      ticks2=ticks1;
      while((ticks2/CLOCKS_PER_SEC-ticks1/CLOCKS_PER_SEC)<1)
        ticks2=clock();

      printf("Took %ld ticks to wait one second.\n",ticks2-ticks1);
      printf("This value should be the same as CLOCKS_PER_SEC which is %ld.\n",CLOCKS_PER_SEC);
      return 0;
    }

2.15.4 ctime

Declaration:

    char *ctime(const time_t *timer); 

Returns a string representing the localtime based on the argument timer. This is equivalent to:

    asctime(locatime(timer)); 

The returned string is in the following format:

    DDD MMM dd hh:mm:ss YYYY 

DDD	Day of the week (Sun, Mon, Tue, Wed, Thu, Fri, Sat)
MMM	Month of the year (Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec)
dd	Day of the month (1,...,31)
hh	Hour (0,...,23)
mm	Minute (0,...,59)
ss	Second (0,...,59)
YYYY	Year
The string is terminated with a newline character and a null character. The string is always 26 characters long (including the terminating newline and null characters).

A pointer to the string is returned.
2.15.5 difftime

Declaration:

    double difftime(time_t time1, time_t time2); 

Calculates the difference of seconds between time1 and time2 (time1-time2).

Returns the number of seconds.
2.15.6 gmtime

Declaration:

    struct tm *gmtime(const time_t *timer); 

The value of timer is broken up into the structure tm and expressed in Coordinated Universal Time (UTC) also known as Greenwich Mean Time (GMT).

A pointer to the structure is returned. A null pointer is returned if UTC is not available.
2.15.7 localtime

Declaration:

    struct tm *localtime(const time_t *timer); 

The value of timer is broken up into the structure tm and expressed in the local time zone.

A pointer to the structure is returned.

Example:

    #include<time.h>
    #include<stdio.h>

    int main(void)
    {
      time_t timer;

      timer=time(NULL);
      printf("The current time is %s.\n",asctime(localtime(&timer)));
      return 0;
    }

2.15.8 mktime

Declaration:

    time_t mktime(struct tm *timeptr); 

Converts the structure pointed to by timeptr into a time_t value according to the local time zone. The values in the structure are not limited to their constraints. If they exceed their bounds, then they are adjusted accordingly so that they fit within their bounds. The original values of tm_wday (day of the week) and tm_yday (day of the year) are ignored, but are set correctly after the other values have been constrained. tm_mday (day of the month) is not corrected until after tm_mon and tm_year are corrected.

After adjustment the structure still represents the same time.

The encoded time_t value is returned. If the calendar time cannot be represented, then -1 is returned.

Example:

    #include<time.h>
    #include<stdio.h>

    /* find out what day of the week is January 1, 2001 
      (first day of the 21st century) */

    int main(void)
    {
      struct tm time_struct;
      char days[7][4]={"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"};

      time_struct.tm_year=2001-1900;
      time_struct.tm_mon=0;
      time_struct.tm_mday=1;
      time_struct.tm_sec=0;
      time_struct.tm_min=0;
      time_struct.tm_hour=0;
      time_struct.tm_isdst=-1;

      if(mktime(&time_struct)==-1)
       {
        printf("Error getting time.\n");
        exit(0);
       }

      printf("January 1, 2001 is a %s.\n",days[time_struct.tm_wday]);
      return 0;
    }

2.15.9 strftime

Declaration:

    size_t strftime(char *str, size_t maxsize, const char *format, const struct tm *timeptr); 

Formats the time represented in the structure timeptr according to the formatting rules defined in format and stored into str. No more than maxsize characters are stored into str (including the terminating null character).

All characters in the format string are copied to the str string, including the terminating null character, except for conversion characters. A conversion character begins with the % sign and is followed by another character which defines a special value that it is to be replaced by.
Conversion
Character	What it is replaced by
%a	abbreviated weekday name
%A	full weekday name
%b	abbreviated month name
%B	full month name
%c	appropriate date and time representation
%d	day of the month (01-31)
%H	hour of the day (00-23)
%I	hour of the day (01-12)
%j	day of the year (001-366)
%m	month of the year (01-12)
%M	minute of the hour (00-59)
%p	AM/PM designator
%S	second of the minute (00-61)
%U	week number of the year where Sunday is the first day of week 1 (00-53)
%w	weekday where Sunday is day 0 (0-6)
%W	week number of the year where Monday is the first day of week 1 (00-53)
%x	appropriate date representation
%X	appropriate time representation
%y	year without century (00-99)
%Y	year with century
%Z	time zone (possibly abbreviated) or no characters if time zone isunavailable
%%	%
Returns the number of characters stored into str not including the terminating null character. On error zero is returned.
2.15.10 time

Declaration:

    time_t time(time_t *timer); 

Calculates the current calender time and encodes it into time_t format.

The time_t value is returned. If timer is not a null pointer, then the value is also stored into the object it points to. If the time is unavailable, then -1 is returned.
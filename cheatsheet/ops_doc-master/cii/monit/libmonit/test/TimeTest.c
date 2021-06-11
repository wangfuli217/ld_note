#include "Config.h"

#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <time.h>
#include <sys/time.h>
#include <stdarg.h>
#include <stdlib.h>

#include "Bootstrap.h"
#include "Str.h"
#include "system/Time.h"

/**
 * Time.c unity tests.
 */


int main(void) {

        setenv("TZ", "CET", 1);
        tzset();
        
        Bootstrap(); // Need to initialize library

        printf("============> Start Time Tests\n\n");


        printf("=> Test1: check string ouput\n");
        {
                char result[STRLEN];
                Time_string(1267441200, result); /* 01 Mar 2010 12:00:00 */
                printf("\tResult: unix time 1267441200 to localtime:\n\t %s\n", result);
                assert(Str_isEqual(result, "Mon, 01 Mar 2010 12:00:00"));
                Time_gmtstring(1267441200, result); /* 01 Mar 2010 12:00:00 GMT */
                printf("\tResult: unix time 1267441200 to UTC:\n\t %s\n", result);
                assert(Str_isEqual("Mon, 01 Mar 2010 11:00:00 GMT", result));
                Time_fmt(result, STRLEN, "%D %T", 1267441200);
                printf("\tResult: 1267441200 -> %s\n", result);
                assert(Str_isEqual(result, "03/01/10 12:00:00"));
                Time_fmt(result, STRLEN, "%D %z", 1267441200);
                printf("\tResult: 1267441200 -> %s\n", result);
#ifdef AIX
                assert(Str_startsWith(result, "03/01/10 CET"));
#else
                assert(Str_startsWith(result, "03/01/10 +"));
#endif
        }
        printf("=> Test1: OK\n\n");

        printf("=> Test2: check current time\n");
        {
                struct timeval tv;
                assert(!gettimeofday(&tv, NULL));
                assert(Time_now() == tv.tv_sec);
        }
        printf("=> Test2: OK\n\n");

        printf("=> Test3: sleep 1s\n");
        {
                time_t now;
                now = Time_now();
                Time_usleep(1000000);
                assert((now + 1) == Time_now());
        }
        printf("=> Test3: OK\n\n");

        printf("=> Test4: uptime\n");
        {
                time_t days = 668040;
                time_t hours = 63240;
                time_t min = 2040;
                char result[24];
                printf("\tResult: uptime days: %s\n", Time_uptime(days, result));
                assert(Str_isEqual(result, "7d, 17h, 34m"));
                printf("\tResult: uptime hours: %s\n", Time_uptime(hours, result));
                assert(Str_isEqual(result, "17h, 34m"));
                printf("\tResult: uptime min: %s\n", Time_uptime(min, result));
                assert(Str_isEqual(result, "34m"));
                printf("\tResult: uptime 0: %s\n", Time_uptime(0, result));
                assert(Str_isEqual(result, ""));
                assert(Time_uptime(0, NULL) == NULL);
        }
        printf("=> Test4: OK\n\n");

        printf("=> Test5: Time attributes\n");
        {
                char b[STRLEN];
                time_t time = 730251059; // Sun, 21. Feb 1993 00:30:59
                printf("\tResult: %s (winter time)\n", Time_string(time, b));
                assert(Time_seconds(time) == 59);
                assert(Time_minutes(time) == 30);
                assert(Time_hour(time) == 0);
                assert(Time_weekday(time) == 0);
                assert(Time_day(time) == 21);
                assert(Time_month(time) == 2);
                assert(Time_year(time) == 1993);
                time = 1253045894; // Tue, 15 Sep 2009 22:18:14 +0200
                printf("\tResult: %s (DTS/summer time)\n", Time_string(time, b));
                assert(Str_startsWith(b, "Tue, 15 Sep 2009 22:18:14"));
        }
        printf("=> Test5: OK\n\n");

        printf("=> Test6: Time_build\n");
        {
                time_t time = Time_build(2001, 1, 29, 12, 0, 0);
                assert(Time_seconds(time) == 0);
                assert(Time_minutes(time) == 0);
                assert(Time_hour(time) == 12);
                assert(Time_day(time) == 29);
                assert(Time_month(time) == 1);
                assert(Time_year(time) == 2001);
                // Verify assert on out of range
                TRY
                {
                        Time_build(1969, 1, 29, 12, 0, 0);
                        printf("Test failed\n");
                        exit(1);
                }
                CATCH (AssertException)
                END_TRY;
                TRY
                {
                        Time_build(1970, 0, 29, 12, 0, 0);
                        printf("Test failed\n");
                        exit(1);
                }
                CATCH (AssertException)
                END_TRY;
        }
        printf("=> Test6: OK\n\n");

        printf("=> Test7: Time_incron\n");
        {
                const char *exactmatch = "27 11 5 7 2";
                const char *matchall = "* * * * *";
                const char *invalid1 = "a bc d";
                const char *invalid2 = "* * * *  "; // Too few fields
                const char *invalid3 = "* * * * * * "; // Too many fields
                const char *range1 = "* 10-11 1-5 * 1-5";
                const char *rangeoutside = "1-10 9-10 1-5 * 1-5";
                const char *sequence = "* 10,11 1-3,5,6 * *";
                const char *sequenceoutside = "* 10,11,12 4,5,6 * 0,6";
                time_t time = Time_build(2011, 7, 5, 11, 27, 5);
                assert(Time_incron(exactmatch, time));
                assert(Time_incron(matchall, time));
                assert(! Time_incron(invalid1, time));
                assert(! Time_incron(invalid2, time));
                assert(! Time_incron(invalid3, time));
                assert(Time_incron(range1, time));
                assert(! Time_incron(rangeoutside, time));
                assert(Time_incron(sequence, time));
                assert(! Time_incron(sequenceoutside, time));
        }
        printf("=> Test7: OK\n\n");

        printf("=> Test8: Time_toDateTime\n");
        {
#if HAVE_STRUCT_TM_TM_GMTOFF
#define TM_GMTOFF tm_gmtoff
#else
#define TM_GMTOFF tm_wday
#endif
                struct tm t;
                // DateTime ISO-8601 format
                assert(Time_toDateTime("2013-12-14T09:38:08Z", &t));
                assert(t.tm_year == 2013);
                assert(t.tm_mon  == 11);
                assert(t.tm_mday == 14);
                assert(t.tm_hour == 9);
                assert(t.tm_min  == 38);
                assert(t.tm_sec  == 8);
                // Date
                assert(Time_toDateTime("2013-12-14", &t));
                assert(t.tm_year == 2013);
                assert(t.tm_mon  == 11);
                assert(t.tm_mday == 14);
                // Time
                assert(Time_toDateTime("09:38:08", &t));
                assert(t.tm_hour == 9);
                assert(t.tm_min  == 38);
                assert(t.tm_sec  == 8);
                // Compressed DateTime
                assert(Time_toDateTime(" 20131214093808", &t));
                assert(t.tm_year == 2013);
                assert(t.tm_mon  == 11);
                assert(t.tm_mday == 14);
                assert(t.tm_hour == 9);
                assert(t.tm_min  == 38);
                assert(t.tm_sec  == 8);
                // Compressed Date
                assert(Time_toDateTime(" 20131214 ", &t));
                assert(t.tm_year == 2013);
                assert(t.tm_mon  == 11);
                assert(t.tm_mday == 14);
                // Compressed Time
                assert(Time_toDateTime("093808", &t));
                assert(t.tm_hour == 9);
                assert(t.tm_min  == 38);
                assert(t.tm_sec  == 8);
                // Reverse DateTime
                assert(Time_toDateTime(" 09:38:08 2013-12-14", &t));
                assert(t.tm_year == 2013);
                assert(t.tm_mon  == 11);
                assert(t.tm_mday == 14);
                assert(t.tm_hour == 9);
                assert(t.tm_min  == 38);
                assert(t.tm_sec  == 8);
                // DateTime with timezone Zulu (UTC)
                assert(Time_toDateTime("The Battle of Stamford Bridge 1066-09-25 12:15:33+00:00", &t));
                assert(t.tm_year == 1066);
                assert(t.tm_mon  == 8);
                assert(t.tm_mday == 25);
                assert(t.tm_hour == 12);
                assert(t.tm_min  == 15);
                assert(t.tm_sec  == 33);
                assert(t.TM_GMTOFF == 0); // offset from UTC in seconds
                // Time with timezone
                assert(Time_toDateTime(" 09:38:08+01:45", &t));
                assert(t.tm_hour == 9);
                assert(t.tm_min  == 38);
                assert(t.tm_sec  == 8);
                assert(t.TM_GMTOFF == 6300);
                // Time with timezone PST compressed
                assert(Time_toDateTime("Pacific Time Zone 09:38:08 -0800 ", &t));
                assert(t.tm_hour == 9);
                assert(t.tm_min  == 38);
                assert(t.tm_sec  == 8);
                assert(t.TM_GMTOFF == -28800);
                // Date without time, tz should not be set
                assert(Time_toDateTime("2013-12-15-0800 ", &t));
                assert(t.TM_GMTOFF == 0);
                // Invalid date
                TRY {
                        Time_toDateTime("1901-123-45", &t);
                        printf("\t Test Failed\n");
                        exit(1);
                } CATCH (AssertException) {
                        // OK
                } ELSE {
                        printf("\t Test Failed with wrong exception\n");
                        exit(1);
                }
                END_TRY;
        }
        printf("=> Test8: OK\n\n");

        printf("=> Test9: Time_toTimestamp\n");
        {
                // Time, fraction of second is ignored. No timezone in string means UTC
                time_t t = Time_toTimestamp("2013-12-15 00:12:58.123456");
                assert(t == 1387066378);
                // TimeZone east
                t = Time_toTimestamp("Tokyo timezone: 2013-12-15 09:12:58+09:00");
                assert(t == 1387066378);
                // TimeZone west
                t = Time_toTimestamp("New York timezone: 2013-12-14 19:12:58-05:00");
                assert(t == 1387066378);
                // TimeZone east with hour and minute offset
                t = Time_toTimestamp("Nepal timezone: 2013-12-15 05:57:58+05:45");
                assert(t == 1387066378);
                // TimeZone Zulu
                t = Time_toTimestamp("Grenwich timezone: 2013-12-15 00:12:58Z");
                assert(t == 1387066378);
                // Compressed
                t = Time_toTimestamp("20131214191258-0500");
                assert(t == 1387066378);
                // Invalid timestamp string
                TRY {
                        Time_toTimestamp("1901-123-45 10:12:14");
                        // Should not come here
                        printf("\t Test Failed\n");
                        exit(1);
                } CATCH (AssertException) {
                        // OK
                } ELSE {
                        printf("\t Test Failed with wrong exception\n");
                        exit(1);
                }
                END_TRY;
        }
        printf("=> Test9: OK\n\n");

        printf("============> Time Tests: OK\n\n");

        return 0;
}



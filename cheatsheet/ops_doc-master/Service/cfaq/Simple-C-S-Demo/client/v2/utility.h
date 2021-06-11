#ifndef UTILITY_H
#define UTILITY_H

#include <string>
using namespace std;

#define SAFE_DELETE(p) {if(p) delete p; p = NULL;}

//整形IP转字符串
inline string Ipltoc(u32 dwIp)
{
    struct in_addr addr;
    addr.s_addr = dwIp;

    return string(inet_ntoa(addr));
}

//字符串IP转整形
inline u32 Ipctol(const s8 *pIp)
{
    try
    {
        if(pIp)
        {
            return inet_addr(pIp);
        }
    }
    catch(...)
    {

    }

    return 0;
}
/*
//格式必须为 20180330000000
inline u32 StrTimeToU32(const s8 *pTime)
{
    if(NULL == pTime)
    {
        return 0;
    }

    u32 dwTime = 0;

    try
    {
        struct tm tm1;
        sscanf(pTime, "%04d%02d%02d%02d%02d%02d",
               &tm1.tm_year,
               &tm1.tm_mon,
               &tm1.tm_mday,
               &tm1.tm_hour,
               &tm1.tm_min,
               &tm1.tm_sec);

        tm1.tm_year -= 1900;
        tm1.tm_mon --;
        tm1.tm_isdst = -1;

        dwTime = mktime(&tm1);
    }
    catch(...)
    {

    }

    return dwTime;
}
*/
#endif //UTILITY_H

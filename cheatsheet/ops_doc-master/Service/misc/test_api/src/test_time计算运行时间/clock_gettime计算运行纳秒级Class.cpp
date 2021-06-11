#include <iostream>
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

using namespace std;

class Statistics
{
#define RECORD_MAX 10
#define DESC_LEN_MAX  32
    struct record
    {
        struct timespec end;
        char desc[DESC_LEN_MAX];
        int pthreadId;
    };
public:
    Statistics(int RecordMax = RECORD_MAX)
    {
        m_Record = new record[RecordMax];
    }
    ~Statistics()
    {
        delete m_Record;
    }

    void Start()
    {
        clear();
        Clock();
        Next();
    }

    void Record(const char * desc = "")
    {
        Clock();
        PthreadId();
        Desc(desc);
        Next();
    }

    void ShowAll()
    {
        printf("==============Time Point====================\n");
        for(int i = 1; i<m_RecordIndex; ++i)
        {
            printf("[%d] %20s, %5llu.%09llus\n",
                    m_Record[i].pthreadId,
                    m_Record[i].desc,
                    m_Record[i].end.tv_sec-m_Record[0].end.tv_sec,
                    m_Record[i].end.tv_nsec-m_Record[0].end.tv_nsec);
        }
        printf("==============Time Diff====================\n");
        for(int i = 1; i<m_RecordIndex; ++i)
        {
            printf("[%d] %20s, %5llu.%09llus\n",
                    m_Record[i].pthreadId,
                    m_Record[i].desc,
                    m_Record[i].end.tv_sec-m_Record[i-1].end.tv_sec,
                    m_Record[i].end.tv_nsec-m_Record[i-1].end.tv_nsec);
        }
    }

private:
    void clear()
    {
        m_RecordIndex = 0;
        memset(m_Record, 0, sizeof(m_Record));
    }
    void Clock()
    {
        clock_gettime(CLOCK_REALTIME, &m_Record[m_RecordIndex].end);
    }
    void Desc(const char * desc)
    {
        snprintf(m_Record[m_RecordIndex].desc, DESC_LEN_MAX, "%s", desc);
    }
    void PthreadId()
    {
        m_Record[m_RecordIndex].pthreadId = pthread_self();
    }
    void Next()
    {
        m_RecordIndex++;
    }
    //时间统计
    struct timespec m_start;
    int m_RecordIndex;
    struct record * m_Record;
};

int main(void)
{
    Statistics S;
    S.Start();
    usleep(1000);
    S.Record();
    usleep(10000);
    S.Record();
    usleep(100000);
    S.Record();
    usleep(1000000);
    S.Record();
//    usleep(10000000);
//    S.Record();
    S.ShowAll();
    return 0;
}
//start time 1500464242s,921989973 ns
//endtime 1500464242s,922064033 ns
//duration:0s 74060ns

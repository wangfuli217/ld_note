#ifndef TRACER_H
#define TRACER_H

#include <QDebug>
#include <iostream>


//如果想要去掉打印，
//把下一行注掉即可
#define TRACER_DEBUG
#ifdef  TRACER_DEBUG
#define TRACER \
   Tracer tracer(__func__)
#else
#define TRACER
#endif

class Tracer
{
public:
   Tracer(const char msg[]):
       m_msg(msg)
   {
       fprintf(stderr, "Enter: %s", m_msg);
   }

   ~Tracer()
   {
       fprintf(stderr, "Leave: %s", m_msg);
   }

private:
   const char* m_msg;
};

#endif // TRACER_H
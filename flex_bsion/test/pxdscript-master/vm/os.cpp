#include "os.h"
#include <unistd.h>
#include <sys/time.h>

timeval startTime;
bool startTimed = false;

timeval getTime() {
  if (!startTimed) {
    gettimeofday(&startTime, NULL);
    startTimed = true;
  }
  
  timeval t;
  gettimeofday(&t, NULL);

  t.tv_sec -= startTime.tv_sec;
  t.tv_usec -= startTime.tv_usec;

  return t;
}

// Get a time measure msec. 
unsigned long GetTimeMsec() {
  timeval t = getTime();
  return t.tv_sec * 1000 + t.tv_usec / 1000;
}

// Get time in seconds (using hi res timer)
float GetTimeSec() {
  timeval t = getTime();
  return t.tv_sec + t.tv_usec / 1000000.0;
}

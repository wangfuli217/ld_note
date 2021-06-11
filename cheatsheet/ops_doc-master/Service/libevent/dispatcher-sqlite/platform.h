#ifndef __PLATFORM_H__
#define __PLATFORM_H__

#ifdef _WIN32
#include <winsock2.h>
#include <io.h>
#define ERRNO GetLastError()
typedef int socklen_t;

#else
#include <unistd.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <sys/select.h>
#include <sys/wait.h>
#include <sys/mman.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <errno.h>

#define ERRNO errno

#endif

#include <fcntl.h>

#endif

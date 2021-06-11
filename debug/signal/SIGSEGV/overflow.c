//
//  overflow.c -- demonstrates capturing the SIGABRT for a signed numeric overflow
//
//  Compile with 'gcc -W -Wall -ftrapv overflow.c -o overflow'
//  Create a list file with 'objdump -d overflow >overflow.lst'
//  Follow the stack backtrace to determine what caused the abort
//

#define _GNU_SOURCE
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>
#include <signal.h>
#include <time.h>
#include <execinfo.h>
#include <limits.h>
#include <ucontext.h>
#include <sys/types.h>

#define arrsizeof(x) (sizeof(x)/sizeof(x[0]))

//
//
//
char *getProcessName (void)
{
  char buffer [128];
  FILE *fp;

  sprintf (buffer, "/proc/%d/stat", getpid ());

  if ((fp = fopen (buffer, "r")))
  {
    if (fgets (buffer, sizeof (buffer), fp))
    {
      char *s;

      if ((s = index (buffer, ')')))
      {
        *s = '\0';

        if ((s = index (buffer, '(')))
          return ++s;
      }
    }
  }

  return NULL;
}

//
//
//
static void sighandlerPrint (FILE *fp, int signo, int code, ucontext_t *context, void *bt [], int bt_size)
{
  char *processName;
  time_t ttime = time (NULL);

  fprintf (fp, "%s", ctime (&ttime));
  fprintf (fp, "PID=%d (%s)\n", getpid (), (processName = getProcessName ()) ? processName : "unknown");
  fprintf (fp, "signo=%d/%s\n", signo, strsignal (signo));
  fprintf (fp, "code=%d (not always applicable)\n", code);
  fprintf (fp, "\nContext: 0x%08lx\n", (unsigned long) context);
  fprintf (fp, "    gs: 0x%08x   fs: 0x%08x   es: 0x%08x   ds: 0x%08x\n"
               "   edi: 0x%08x  esi: 0x%08x  ebp: 0x%08x  esp: 0x%08x\n"
               "   ebx: 0x%08x  edx: 0x%08x  ecx: 0x%08x  eax: 0x%08x\n"
               "  trap:   %8u  err: 0x%08x  eip: 0x%08x   cs: 0x%08x\n"
               "  flag: 0x%08x   sp: 0x%08x   ss: 0x%08x  cr2: 0x%08lx\n",
               context->uc_mcontext.gregs [REG_GS],     context->uc_mcontext.gregs [REG_FS],   context->uc_mcontext.gregs [REG_ES],  context->uc_mcontext.gregs [REG_DS],
               context->uc_mcontext.gregs [REG_EDI],    context->uc_mcontext.gregs [REG_ESI],  context->uc_mcontext.gregs [REG_EBP], context->uc_mcontext.gregs [REG_ESP],
               context->uc_mcontext.gregs [REG_EBX],    context->uc_mcontext.gregs [REG_EDX],  context->uc_mcontext.gregs [REG_ECX], context->uc_mcontext.gregs [REG_EAX],
               context->uc_mcontext.gregs [REG_TRAPNO], context->uc_mcontext.gregs [REG_ERR],  context->uc_mcontext.gregs [REG_EIP], context->uc_mcontext.gregs [REG_CS],
               context->uc_mcontext.gregs [REG_EFL],    context->uc_mcontext.gregs [REG_UESP], context->uc_mcontext.gregs [REG_SS],  context->uc_mcontext.cr2
  );

  fprintf (fp, "\n%d elements in backtrace\n", bt_size);
  fflush (fp);

  backtrace_symbols_fd (bt, bt_size, fileno (fp));
}

//
//
//
static void sighandlerABRT (int signo, struct siginfo *si, void *ctx)
{
  void *bt [128];
  int bt_size;

  bt_size = backtrace (bt, arrsizeof (bt));

  sighandlerPrint (stderr, signo, si->si_code, (ucontext_t *) ctx, bt, bt_size);

  exit (1);
}

//
//
//
int installSignalHandlers (void)
{
  struct sigaction sa;

  sigemptyset (&sa.sa_mask);
  sigaddset (&sa.sa_mask, SIGABRT);

  sa.sa_flags = SA_ONESHOT | SA_SIGINFO;
  sa.sa_sigaction = sighandlerABRT;

  if (sigaction (SIGABRT, &sa, NULL))
  {
    fprintf (stderr, "sigaction failed, line %d, %d/%s\n", __LINE__, errno, strerror (errno));
    exit (1);
  }

  return 1;
}

//
//
//
int main (void)
{
  int a = INT_MAX;
  int b = 2;
  int c = 0;

  installSignalHandlers ();

  c = a + b;

  printf ("c=%d\n", c);

  exit (0);
}
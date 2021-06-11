#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>
#include <string.h>

/* gcc -pg a.c  gprof-helper.so
    ./a.out
    分析gmon.out:
    gprof -b a.out gmon.out
 */
void fun1 ();
void fun2 ();
void *fun (void *argv);
int main (int argc, char *argv[])
{

  int i = 0;
  int id;
  pthread_t thread[100];
  for (i = 0; i < 100; i++)
    {
      id = pthread_create (&thread[i], NULL, fun, NULL);
      printf ("thread =%d/n", i);
    }
  printf ("dsfsd/n");
  return 0;

}

void *
fun (void *argv)
{

  fun1 ();

  fun2 ();

  return NULL;

}

void
fun1 ()
{

  int i = 0;

  while (i < 100)

    {

      i++;

      printf ("fun1/n");

    }

}

void
fun2 ()
{

  int i = 0;

  int b;

  while (i < 50)

    {

      i++;

      printf ("fun2/n");

      //b+=i;        

    }

}

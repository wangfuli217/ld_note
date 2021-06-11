
/* memory allocations debug */
static bool mdebug = false;

void *mymalloc (const char* fname, const char* func, int lineno, size_t  size)
{
   void* ptr = (void*)::malloc( size );
   if (mdebug)
     printf("\n%s.%s:%d malloc(%lu): ptr=%p\n",fname, func, lineno, size, ptr);

   return (void *) ptr;
}

void *myrealloc  (void * ptr, size_t  size )
{
   void* p = (void *) ::realloc( (char *) ptr, size );
   if (mdebug)
     printf("\nrealloc(%p, %lu): newptr=%p\n", ptr, size, p);
   return p;
}

void myfree (void * ptr)
{
   if (mdebug)
     printf("\nfree: ptr=%p\n", ptr);
   ::free( (char *) ptr );  
}

#define malloc(s) mymalloc(__FILE__, __FUNCTION__, __LINE__, (s))
#define realoc myrealloc
#define free myfree

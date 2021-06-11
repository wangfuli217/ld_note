static void *
persistent_realloc (void *ptr, size_t size)
{
    for (;;){
      void *newptr = realloc (ptr, size);

      if (newptr)
        return newptr;

      sleep (60);
    }
}

...
ev_set_allocator (persistent_realloc);
/* $Id$ */
#ifndef ATOM_INCLUDED
#define ATOM_INCLUDED
extern       int   Atom_length(const char *str);
extern const char *Atom_new   (const char *str, int len);
extern const char *Atom_string(const char *str);
extern const char *Atom_int   (long n);

/**************** added by Guoji ********************/
void Atom_hash_count(int *result, int length);
#endif

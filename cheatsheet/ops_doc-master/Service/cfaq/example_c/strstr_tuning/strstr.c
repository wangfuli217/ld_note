/*
 * My personal strstr() implementation that beats most other algorithms.
 * Until someone tells me otherwise, I assume that this is the
 * fastest implementation of strstr() in C.
 * I deliberately chose not to comment it.  You should have at least
 * as much fun trying to understand it, as I had to write it :-).
 *
 * Stephen R. van den Berg, berg@pool.informatik.rwth-aachen.de */
#include "stdlib.h"
#include "stdio.h"
typedef unsigned chartype;

	char *
strstrBerg (phaystack, pneedle)
	const char *phaystack;
	const char *pneedle;
{
	const unsigned char *haystack, *needle;
	chartype b;
	const unsigned char *rneedle;

	haystack = (const unsigned char *) phaystack;

	if ((b = *(needle = (const unsigned char *) pneedle)))
	{
		chartype c;
		haystack--;       /* possible ANSI violation */

		{
			chartype a;
			do
				if (!(a = *++haystack))
					goto ret0;
			while (a != b);
		}

		if (!(c = *++needle))
			goto foundneedle;
		++needle;
		goto jin;

		for (;;)
		{
			{
				chartype a;
				if (0)
					jin:{
						if ((a = *++haystack) == c)
							goto crest;
					}
				else
					a = *++haystack;
				do
				{
					for (; a != b; a = *++haystack)
					{
						if (!a)
							goto ret0;
						if ((a = *++haystack) == b)
							break;
						if (!a)
							goto ret0;
					}
				}
				while ((a = *++haystack) != c);
			}
crest:
			{
				chartype a;
				{
					const unsigned char *rhaystack;
					if (*(rhaystack = haystack-- + 1) == (a = *(rneedle = needle)))
						do
						{
							if (!a)
								goto foundneedle;
							if (*++rhaystack != (a = *++needle))
								break;
							if (!a)
								goto foundneedle;
						}
						while (*++rhaystack == (a = *++needle));
					needle = rneedle; /* took the register-poor aproach */
				}
				if (!a)
					break;
			}
		}
	}
foundneedle:
	return (char *) haystack;
ret0:
	return 0;
}

/* String matching by maximal suffices. */
char* strstrToy(const char*haystack, const char*needle) {
  size_t ul;
  if (!*needle) return (char*)haystack;
  if (!needle[1]) return strchr(haystack, *needle);

  /* Here follow some heuristics for finding a reasonable place to start
   * the search, since this code is slower by a decently large constant factor
   * than Stephen van den Berg's code in easy cases, particularly on short
   * strings.
   */
  {
    size_t s;
    /* use naive algorithm on short patterns. */
    for (s = 2; s < 8; s++)
      if (!needle[s]) return strstrBerg(haystack, needle);

    /* find the first occurrence of needle as a subsequence of haystack. */
    for (s = 0; needle[s]; s++) {
      while (haystack[s] != needle[s] && haystack[s]) haystack++;
      if (!haystack[s]) return NULL;
    }
      
    /* look for the first 7 chars of needle in haystack. */
    char foo[8];
    for (s = 0; s < 7; s++) foo[s] = needle[s];
    foo[7] = 0;
    haystack = (const char*)strstrBerg(haystack, foo);
    if (haystack == NULL) return NULL;
  }

  const char *v;
  /* find a maximal suffix of needle, and store it in v. */
  {
    size_t i, j = 0, p;
    while (1) {
      /* find the longest self-maximal prefix of needle[j...strlen(needle)].
       * i is its end, and p is its period. */
      for (i = j+1, p = 1; needle[i]; i++) {
        if (needle[i] < needle[i - p]) p = i - j + 1;
        else if (needle[i] > needle[i - p]) break;
      }
      /* needle[j...i-1] is the longest self-maximal prefix of needle+j. */
      if (needle[i]) j = i - (i - j) % p;
      else break;
    }
    v = needle + j;
    ul = j;
  }

  /* use Stephen's code for short v. */
  if (strlen(v) < 10) {
    const char *prev = haystack;
    const char *hay = haystack + ul;
    while (1) {
      hay = strstrBerg(hay, v);
      if (hay == NULL) goto retnull;
      if (hay - prev >= ul && !memcmp(hay - ul, needle, ul))
        return (char*)(hay - ul);
      prev = hay;
      hay++;
    }
  }

  /* now do the searching. */
  {
    size_t p = 1, j = 0;
    const char *hi = haystack+ul;
    const char *prev = haystack;
  
    while (1) {
      /* match pattern characters against text characters. */
      while (v[j] == hi[j] && v[j]) {
        /* The character v[j] breaks the periodicity of v.
         * We therefore have the situation depicted in the following cartoon:
         *
         *            /---p---\            j
         * v: [a b c d|a b c d|a b c d|a b x.............]
         *
         * The period of this string is at least j, so we update p accordingly.
         *
         * Why can't it be less than j?
         * Suppose that the period of v[0...j] were less than j, even though
         * v[j] != v[j - p].  There are two cases:
         *   Case 1: v[j] > v[j - p]
         *       Then v[0...j] is less than v[p...j], since
         *       v[0...j-p-1] = v[p...j-1] while v[j] > v[j-p], a contradiction.
         *   Case 2: v[j] < v[j - p]
         *       Let q be the actual period of v[0...j].
         *       Then v[j % q] < v[j - p].
         *       Thus, v[j - p - (j % q)...j] > v[0...j], since
         *       v[j - p - (j % q)...j - p - 1] = v[0...(j % q) - 1]
         *       while v[j - p] > v[j] = v[j % q].
         *       This is again a contradiction.
         */ 
        if (j > p && v[j] != v[j-p])
          p = j;
        j++;
      }
  
      if (!v[j]) { /* v matches. */
        if (hi >= prev) {
          if (!memcmp(hi-ul, needle, ul)) /* whole string matches. */
            return (char*)(hi-ul);
          /* u doesn't match. */
        }
        /* else, u cannot possibly match since v was a maximal suffix. */
        prev = hi+ul; /* u doesn't match. set prev accordingly. */
      }
      else if (!hi[j]) goto retnull;
  
      /* We know that v[0...j] has period p.  We also know that j characters of
       * the text match.  We can therefore shift the pattern over by p, since at
       * least the first p characters of haystack+i must match the first p
       * characters of v.
       */
        hi += p;
      /* Similarly, if we matched the first 2p characters of v, we must match
       * the first p characters of the needle against the first p characters of
       * the haystack, so we shift v by p.
       */
      if (j >= p+p) j -= p;
      else p=1, j = 0;
    }
  }

  retnull:
  return NULL;
}

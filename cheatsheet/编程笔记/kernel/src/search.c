/* 
 * ===  FUNCTION  ======================================================================
 *         Name:  brute_search
 *  Description:  Search for string in text using lookup table.
 *		  Returns a pointer to the first instance of
 *		  string, or NULL at end of text.
 * =====================================================================================
 */
char *brute_search(const char *text, const char *string)
{
	int len = strlen(string);

    /*-----------------------------------------------------------------------------
     *  "static" instead of calloc, namely initialize all elements to '\0'
     *  UCHAR_MAX == 255, limit.h
     *  so, lookup[256]
     *  if the pattern string's 1st char is 'a', then lookup[97] = 2
     *-----------------------------------------------------------------------------*/
	static char lookup[UCHAR_MAX + 1];
        lookup[0] = 1;                                          /* EOT process */
        lookup[(unsigned char)(*string)] = 2;                   /* a match, just 1st char */

	for (;; text++) {
		switch (lookup[(unsigned char)(*text)]) {	/* check the 1st char by *text */
		case 0:
                        break;                                  /* it's not EOT or a match */
		case 1:
                        return (NULL);                          /* EOT */
		case 2:                                         /* this assures every char to b checked just 1 time */
			if (strncmp(string + 1, text + 1, len - 1) == 0)
                                return ((char *)text);          /* a match */
			break;
                default:                                        /* good coding to include default */
			break;
		}
	}
}

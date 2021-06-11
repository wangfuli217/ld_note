/**
 * fgetc, getc
 *   Defined in header <stdio.h>
 * _____________________________________________________________________________
 *  int fgetc( FILE *stream);
 * _____________________________________________________________________________
 *  int getc( FILE *stream);
 * _____________________________________________________________________________
 * Reads the next character from the given input stream. getc() may be
 * implemented as a macro.
 *
 * Parameters:
 *  stream - to read the character from
 *
 * Return value
 *  The obtained character on success or EOF on failure.
 *  If the failure has been caused by end-of-file condition, additionally sets
 *  the oef indicator (see feof()) on stream. If the failure has been caused
 *  by some other error, sets the error indicator (see ferror()) on stream.
 *
 * Compilation:
 *  gcc -o fgetc fgetc.c
 * Created@:
 *  2015-08-10
 */

#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    FILE* tmpf = tmpfile();
    fputs("abcde\n", tmpf);

    rewind(tmpf);

    int ch;
    while ((ch=fgetc(tmpf)) != EOF) /* read/print characters including newline */
        printf("%c", ch);

    /* Test reason for reaching EOF */
    if (feof(tmpf)) /* if failure caused by end-of-file condition */
        puts("End of file reached");
    else if (ferror(tmpf))  /* if failure caused by some other error */
    {
        perror("fgetc()");
        fprintf(stderr, "fgetc() failed in file %s at line # %d\n",
                __FILE__, __LINE__-9);
        exit(EXIT_FAILURE);
    }
    
    return EXIT_SUCCESS;
}
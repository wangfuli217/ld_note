/**
 * fopen, fopen_s
 *   Defined in header <stdio.h>
 * _____________________________________________________________________________
 *  FILE *fopen( const char *filename, const char *mode );           (until C99)
 * ------------------------------------------------------------ (1)
 *  FILE *fopen( const char *restrict filename, 
 *               const char *restrict mode );                        (since C99)
 * _____________________________________________________________________________
 *  errno_t fopen_s( FILE *restrict *restrict streamptr,
 *                   const char *restrict filename,             (2)  (since C11)
 *                   const char *restrict mode);
 * _____________________________________________________________________________
 *  1) Opens a file indicated by filename and returns a pointer to the file
 *     stream associated with that file. mode is used to determine the file
 *     access mode
 *  2) Same as (1), except that the pointer to the file stream is written to
 *     <streamptr> and the following errors are detected at runtime and call the
 *     currently installed constraint handler function:
 *      * streamptr is a null pointer
 *      * filename is a null pointer
 *      * mode is a null pointer
 */

#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    FILE *fp = fopen("fopen.txt", "r");
    if (!fp) {
        perror("File opening failed!");
        return EXIT_FAILURE;
    }

    int c; // note: int, not char, required to handle EOF
    while ((c = fgetc(fp)) != EOF) { // standard C I/O file reading loop
        putchar(c);
    }

    if (ferror(fp))
        puts("I/O error when reading");
    else if (feof(fp))
        puts("End of file reached successfully");

    fclose(fp);
}
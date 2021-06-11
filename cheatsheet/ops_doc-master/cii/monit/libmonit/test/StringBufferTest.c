#include "Config.h"

#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <stdarg.h>
#include <stdlib.h>

#include "Bootstrap.h"
#include "Str.h"
#include "StringBuffer.h"

/**
 * StringBuffer.c unity tests. 
 */


static void append(StringBuffer_T B, const char *s, ...) {
 	va_list ap;
	va_start(ap, s);
        StringBuffer_vappend(B, s, ap);
	va_end(ap);
}


int main(void) {
        StringBuffer_T sb;

        Bootstrap(); // Need to initialize library

        printf("============> Start StringBuffer Tests\n\n");

        printf("=> Test1: create/destroy\n");
        {
                sb = StringBuffer_new("");
                assert(sb);
                assert(StringBuffer_length(sb)==0);
                StringBuffer_free(&sb);
                assert(sb==NULL);
                sb = StringBuffer_create(1024);
                assert(sb);
                StringBuffer_free(&sb);
                assert(sb==NULL);
        }
        printf("=> Test1: OK\n\n");

        printf("=> Test2: Append NULL value\n");
        {
                sb = StringBuffer_new("");
                assert(sb);
                StringBuffer_append(sb, NULL);
                assert(StringBuffer_length(sb)==0);
                StringBuffer_free(&sb);
                assert(sb==NULL);
        }
        printf("=> Test2: OK\n\n");

        printf("=> Test3: Create with string\n");
        {
                sb = StringBuffer_new("abc");
                assert(sb);
                assert(StringBuffer_length(sb)==3);
                StringBuffer_free(&sb);
                assert(sb==NULL);
        }
        printf("=> Test3: OK\n\n");

        printf("=> Test4: Append string value\n");
        {
                sb = StringBuffer_new("abc");
                assert(sb);
                printf("\tTesting StringBuffer_append:..");
                StringBuffer_append(sb, "def");
                assert(StringBuffer_length(sb)==6);
                printf("ok\n");
                printf("\tTesting StringBuffer_vappend:..");
                append(sb, "%c%s", 'g', "hi");
                assert(StringBuffer_length(sb)==9);
                assert(Str_isEqual(StringBuffer_toString(sb), "abcdefghi"));
                printf("ok\n");
                StringBuffer_free(&sb);
                assert(sb==NULL);
        }
        printf("=> Test4: OK\n\n");

        printf("=> Test5: trim\n");
        {
                sb = StringBuffer_new("\t 'foo bar' \n ");
                assert(Str_isEqual(StringBuffer_toString(StringBuffer_trim(sb)), "'foo bar'"));
                StringBuffer_clear(sb);
                StringBuffer_append(sb, "'foo bar'");
                StringBuffer_trim(sb);
                assert(Str_isEqual(StringBuffer_toString(sb), "'foo bar'"));
                StringBuffer_clear(sb);
                StringBuffer_append(sb, "\t \r \n  ");
                assert(Str_isEqual(StringBuffer_toString(StringBuffer_trim(sb)), ""));
                StringBuffer_free(&sb);
                sb = StringBuffer_create(10);
                StringBuffer_trim(sb);
                assert(StringBuffer_toString(sb)[0] == 0);
                StringBuffer_free(&sb);
        }
        printf("=> Test5: OK\n\n");

        printf("=> Test6: deleteFrom\n");
        {
                sb = StringBuffer_new("abcdefgh");
                assert(sb);
                StringBuffer_delete(sb,3);
                assert(StringBuffer_length(sb)==3);
                StringBuffer_free(&sb);
                assert(sb==NULL);
        }
        printf("=> Test6: OK\n\n");

        printf("=> Test7: indexOf and lastIndexOf\n");
        {
                sb = StringBuffer_new("jan-henrik haukeland");
                assert(sb);
                assert(StringBuffer_indexOf(sb, "henrik")==4);
                assert(StringBuffer_indexOf(sb, "an")==1);
                assert(StringBuffer_indexOf(sb, "-")==3);
                assert(StringBuffer_lastIndexOf(sb, "an")==17);
                assert(StringBuffer_indexOf(sb, "")==-1);
                assert(StringBuffer_indexOf(sb, 0)==-1);
                assert(StringBuffer_indexOf(sb, "d")==19);
                assert(StringBuffer_indexOf(sb, "j")==0);
                assert(StringBuffer_lastIndexOf(sb, "d")==19);
                assert(StringBuffer_lastIndexOf(sb, "j")==0);
                assert(StringBuffer_lastIndexOf(sb, "x")==-1);
                assert(StringBuffer_indexOf(sb, "jane")==-1);
                assert(StringBuffer_indexOf(sb, "jan-henrik haukeland")==0);
                assert(StringBuffer_indexOf(sb, "haukeland")==11);
                StringBuffer_free(&sb);
                assert(sb==NULL);
        }
        printf("=> Test7: OK\n\n");

        printf("=> Test8: length and clear\n");
        {
                sb = StringBuffer_new("jan-henrik haukeland");
                assert(sb);
                assert(StringBuffer_length(sb)==20);
                StringBuffer_clear(sb);
                assert(StringBuffer_length(sb)==0);
                StringBuffer_free(&sb);
                assert(sb==NULL);
        }
        printf("=> Test8: OK\n\n");

        printf("=> Test9: toString value\n");
        {
                sb = StringBuffer_new("abc");
                assert(sb);
                StringBuffer_append(sb, "def");
                assert(Str_isEqual(StringBuffer_toString(sb), "abcdef"));
                StringBuffer_free(&sb);
                assert(sb==NULL);
        }
        printf("=> Test9: OK\n\n");

        printf("=> Test10: internal resize\n");
        {
                int i;
                sb = StringBuffer_new("");
                assert(sb);
                for (i = 0; i<1024; i++)
                        StringBuffer_append(sb, "a");
                assert(StringBuffer_length(sb)==1024);
                assert(StringBuffer_toString(sb)[1023]=='a');
                assert(StringBuffer_toString(sb)[1024]==0);
                StringBuffer_free(&sb);
                assert(sb==NULL);
        }
        printf("=> Test10: OK\n\n");

        printf("=> Test11: substring\n");
        {
                sb = StringBuffer_new("jan-henrik haukeland");
                assert(sb);
                assert(Str_isEqual(StringBuffer_substring(sb, StringBuffer_indexOf(sb, "-")),
                                                 "-henrik haukeland"));
                StringBuffer_free(&sb);
                assert(sb==NULL);
        }
        printf("=> Test11: OK\n\n");

        printf("=> Test12: replace\n");
        {
                printf("\tNothing to replace\n");
                sb = StringBuffer_new("abc?def?");
                assert(sb);
                StringBuffer_replace(sb, "x", "$x");
                assert(Str_isEqual(StringBuffer_toString(sb), "abc?def?"));
                StringBuffer_free(&sb);
                assert(sb==NULL);
                printf("\tReplace and expand\n");
                sb = StringBuffer_new("abc?def?");
                assert(sb);
                StringBuffer_replace(sb, "?", "$x");
                assert(Str_isEqual(StringBuffer_toString(sb), "abc$xdef$x"));
                StringBuffer_free(&sb);
                assert(sb==NULL);
                printf("\tReplace and shrink\n");
                sb = StringBuffer_new("abc$xdef$x");
                assert(sb);
                StringBuffer_replace(sb, "$x", "?");
                assert(Str_isEqual(StringBuffer_toString(sb), "abc?def?"));
                StringBuffer_free(&sb);
                assert(sb==NULL);
                printf("\tReplace with empty string\n");
                sb = StringBuffer_new("abc$xdef$x");
                assert(sb);
                StringBuffer_replace(sb, "$x", "");
                assert(Str_isEqual(StringBuffer_toString(sb), "abcdef"));
                StringBuffer_free(&sb);
                assert(sb==NULL);
                printf("\tReplace with same length\n");
                sb = StringBuffer_new("foo bar baz foo bar baz");
                assert(sb);
                StringBuffer_replace(sb, "baz", "bar");
                assert(Str_isEqual(StringBuffer_toString(sb), "foo bar bar foo bar bar"));
                StringBuffer_free(&sb);
                assert(sb==NULL);
                printf("\tRemove words and test traceback\n");
                sb = StringBuffer_new("foo bar baz foo foo bar baz");
                assert(sb);
                StringBuffer_replace(sb, "baz", "bar");
                assert(Str_isEqual(StringBuffer_toString(sb), "foo bar bar foo foo bar bar"));
                StringBuffer_replace(sb, "foo bar ", "");
                assert(Str_isEqual(StringBuffer_toString(sb), "bar foo bar"));
                StringBuffer_free(&sb);
                assert(sb==NULL);
                printf("\tReplace all elements\n");
                sb = StringBuffer_new("aaaaaaaaaaaaaaaaaaaaaaaa");
                assert(sb);
                StringBuffer_replace(sb, "a", "b");
                assert(Str_isEqual(StringBuffer_toString(sb), "bbbbbbbbbbbbbbbbbbbbbbbb"));
                StringBuffer_free(&sb);
                assert(sb==NULL);
                printf("\tReplace and expand with resize of StringBuffer\n");
                sb = StringBuffer_new("insert into(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) values (1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,01,2,3);");
                assert(sb);
                StringBuffer_replace(sb, "?", "$x");
                assert(Str_isEqual(StringBuffer_toString(sb), "insert into($x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x, $x) values (1,2,3,4,5,6,7,8,9,0,1,2,3,4,5,6,7,8,9,01,2,3);"));
                StringBuffer_free(&sb);
                assert(sb==NULL);
        }
        printf("=> Test12: OK\n\n");

#ifdef HAVE_LIBZ
        printf("=> Test13: compression\n");
        {
                const char *input = "<aaaaaaaaaa>"
                                    "<bbbbbbbbbb>"
                                    "<cccccccccc></cccccccccc>"
                                    "<cccccccccc></cccccccccc>"
                                    "<cccccccccc></cccccccccc>"
                                    "<cccccccccc></cccccccccc>"
                                    "<cccccccccc></cccccccccc>"
                                    "<cccccccccc></cccccccccc>"
                                    "<cccccccccc></cccccccccc>"
                                    "</bbbbbbbbbb>"
                                    "</aaaaaaaaaa>";
                const char compressedInput[] = {
                        0x1f, 0x8b, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03,                                                                                                             // Header
                        0xb3, 0x49, 0x84, 0x03, 0x3b, 0x9b, 0x24, 0x38, 0xb0, 0xb3, 0x49, 0x86, 0x03, 0x3b, 0x1b, 0x7d, 0x64, 0xce, 0xe0, 0x94, 0xd0, 0x47, 0x76, 0xbb, 0x3e, 0x92, 0xa7, 0x00, // Compressed blocks
                        0xdd, 0x84, 0x33, 0xe7,                                                                                                                                                 // CRC
                        0xe1, 0x00, 0x00, 0x00                                                                                                                                                  // Input size
                };
                sb = StringBuffer_new(input);
                assert(StringBuffer_length(sb) == 225);
                size_t compressedLength;
                const void *compressed = StringBuffer_toCompressed(sb, 6, &compressedLength);
                assert(compressed);
                assert(compressedLength == 46);
                for (int i = 0; i < compressedLength; i++) {
                        // Skip header OS type as it is platform dependent (see 2.3.1 in https://www.ietf.org/rfc/rfc1952.txt)
                        if (i != 9) {
                                assert(compressedInput[i] == *(unsigned char *)(compressed + i));
                        }
                }
                StringBuffer_free(&sb);
                assert(sb == NULL);
        }
        printf("=> Test13: OK\n\n");

        printf("=> Test14: empty string compression\n");
        {
                const char *input = "";
                sb = StringBuffer_new(input);
                assert(StringBuffer_length(sb) == 0);
                size_t compressedLength;
                const void *compressed = StringBuffer_toCompressed(sb, 6, &compressedLength);
                assert(compressed == NULL);
                assert(compressedLength == 0);
                StringBuffer_free(&sb);
                assert(sb == NULL);
        }
        printf("=> Test14: OK\n\n");

        printf("=> Test15: StringBuffer set-compress -> clear-compress -> append-compress\n");
        {
                printf("\tStage 1: set content + compress\n");
                const char *input1 = "<aaaaaaaaaa>"
                                     "<bbbbbbbbbb>"
                                     "<cccccccccc></cccccccccc>"
                                     "<cccccccccc></cccccccccc>"
                                     "<cccccccccc></cccccccccc>"
                                     "<cccccccccc></cccccccccc>"
                                     "<cccccccccc></cccccccccc>"
                                     "<cccccccccc></cccccccccc>"
                                     "<cccccccccc></cccccccccc>"
                                     "</bbbbbbbbbb>"
                                     "</aaaaaaaaaa>";
                const char output1[] = {
                        0x1f, 0x8b, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03,                                                                                                             // Header
                        0xb3, 0x49, 0x84, 0x03, 0x3b, 0x9b, 0x24, 0x38, 0xb0, 0xb3, 0x49, 0x86, 0x03, 0x3b, 0x1b, 0x7d, 0x64, 0xce, 0xe0, 0x94, 0xd0, 0x47, 0x76, 0xbb, 0x3e, 0x92, 0xa7, 0x00, // Compressed blocks
                        0xdd, 0x84, 0x33, 0xe7,                                                                                                                                                 // CRC
                        0xe1, 0x00, 0x00, 0x00                                                                                                                                                  // Input size
                };
                sb = StringBuffer_new(input1);
                assert(StringBuffer_length(sb) == 225);
                size_t compressedLength;
                const void *compressed = StringBuffer_toCompressed(sb, 6, &compressedLength);
                assert(compressed);
                assert(compressedLength == 46);
                for (int i = 0; i < compressedLength; i++) {
                        // Skip header OS type as it is platform dependent (see 2.3.1 in https://www.ietf.org/rfc/rfc1952.txt)
                        if (i != 9) {
                                assert(output1[i] == *(unsigned char *)(compressed + i));
                        }
                }

                //////////////////////////////////////////////////////////////////////////////

                printf("\tStage 2: clear content + compress\n");
                const char *input2 = "<dddddddddd>"
                                     "<eeeeeeeeee>"
                                     "<ffffffffff></ffffffffff>"
                                     "</eeeeeeeeee>"
                                     "</dddddddddd>";
                const char output2[] = {
                        0x1f, 0x8b, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03,                                                                                     // Header
                        0xb3, 0x49, 0x81, 0x03, 0x3b, 0x9b, 0x54, 0x38, 0xb0, 0xb3, 0x49, 0x83, 0x03, 0x3b, 0x1b, 0x7d, 0x14, 0x0e, 0xb2, 0x2a, 0x7d, 0x24, 0xed, 0x00, // Compressed blocks
                        0xa9, 0x23, 0x54, 0xf5,                                                                                                                         // CRC
                        0x4b, 0x00, 0x00, 0x00                                                                                                                          // Input size
                };
                StringBuffer_clear(sb);
                StringBuffer_append(sb, "%s", input2);
                assert(StringBuffer_length(sb) == 75);
                compressed = StringBuffer_toCompressed(sb, 6, &compressedLength);
                assert(compressed);
                assert(compressedLength == 42);
                for (int i = 0; i < compressedLength; i++) {
                        // Skip header OS type as it is platform dependent (see 2.3.1 in https://www.ietf.org/rfc/rfc1952.txt)
                        if (i != 9) {
                                assert(output2[i] == *(unsigned char *)(compressed + i));
                        }
                }

                //////////////////////////////////////////////////////////////////////////////

                printf("\tStage 3: append content + compress\n");
                const char *input3 = "<gggggggggg></gggggggggg>";
                const char output3[] = {
                        0x1f, 0x8b, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x03,                                                                                                                               // Header
                        0xb3, 0x49, 0x81, 0x03, 0x3b, 0x9b, 0x54, 0x38, 0xb0, 0xb3, 0x49, 0x83, 0x03, 0x3b, 0x1b, 0x7d, 0x14, 0x0e, 0xb2, 0x2a, 0x7d, 0x64, 0xed, 0xe9, 0x70, 0x00, 0x94, 0x40, 0xe2, 0x00, 0x00, // Compressed blocks
                        0x4c, 0x64, 0x9a, 0x52,                                                                                                                                                                   // CRC
                        0x64, 0x00, 0x00, 0x00                                                                                                                                                                    // Input size
                };
                StringBuffer_append(sb, "%s", input3);
                assert(StringBuffer_length(sb) == 100); // length of input2 + input3
                compressed = StringBuffer_toCompressed(sb, 6, &compressedLength);
                assert(compressed);
                assert(compressedLength == 49);
                for (int i = 0; i < compressedLength; i++) {
                        // Skip header OS type as it is platform dependent (see 2.3.1 in https://www.ietf.org/rfc/rfc1952.txt)
                        if (i != 9) {
                                assert(output3[i] == *(unsigned char *)(compressed + i));
                        }
                }

                //////////////////////////////////////////////////////////////////////////////

                StringBuffer_free(&sb);
                assert(sb == NULL);
        }
        printf("=> Test15: OK\n\n");
#endif
        printf("============> StringBuffer Tests: OK\n\n");

        return 0;
}

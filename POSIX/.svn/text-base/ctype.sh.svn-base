The ctype header is used for testing and converting characters. A control character refers to a character that is not part of the normal printing set. In the ASCII character set, the control characters are the characters from 0 (NUL) through 0x1F (US), and the character 0x7F (DEL). Printable characters are those from 0x20 (space) to 0x7E (tilde).

Functions:

    isalnum();
    isalpha();
    iscntrl();
    isdigit();
    isgraph();
    islower();
    isprint();
    ispunct();
    isspace();
    isupper();
    isxdigit();
    tolower();
    toupper();

2.2.1 is... Functions

Declarations:

    int isalnum(int character);
    int isalpha(int character);
    int iscntrl(int character);
    int isdigit(int character);
    int isgraph(int character);
    int islower(int character);
    int isprint(int character);
    int ispunct(int character);
    int isspace(int character);
    int isupper(int character);
    int isxdigit(int character);

The is... functions test the given character and return a nonzero (true) result if it satisfies the following conditions. If not, then 0 (false) is returned.

Conditions:
isalnum 	a letter (A to Z or a to z) or a digit (0 to 9)
isalpha 	a letter (A to Z or a to z)
iscntrl 	any control character (0x00 to 0x1F or 0x7F)
isdigit 	a digit (0 to 9)
isgraph 	any printing character except for the space character (0x21 to 0x7E)
islower 	a lowercase letter (a to z)
isprint 	any printing character (0x20 to 0x7E)
ispunct 	any punctuation character (any printing character except for space character or isalnum)
isspace 	a whitespace character (space, tab, carriage return, new line, vertical tab, or formfeed)
isupper 	an uppercase letter (A to Z)
isxdigit 	a hexadecimal digit (0 to 9, A to F, or a to f)
2.2.2 to... Functions

Declarations:

    int tolower(int character);
    int toupper(int character);

The to... functions provide a means to convert a single character. If the character matches the appropriate condition, then it is converted. Otherwise the character is returned unchanged.

Conditions:
tolower 	If the character is an uppercase character (A to Z), then it is converted to lowercase (a to z)
toupper 	If the character is a lowercase character (a to z), then it is converted to uppercase (A to Z)
Example:

    #include<ctype.h>
    #include<stdio.h>
    #include<string.h>

    int main(void)
    {
      int loop;
      char string[]="THIS IS A TEST";

      for(loop=0;loop<strlen(string);loop++)
        string[loop]=tolower(string[loop]);

      printf("%s\n",string);
      return 0;
    }
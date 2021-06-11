#https://github.com/jobbole/awesome-c-cn
#http://careferencemanual.com/contents.htm
#C语言参考手册
#C99 完全参考手册


C(Standard Language Additions)
{
11.1 NULL, ptrdiff_t, size_t, offsetof 325
11.2 EDOM, ERANGE, EILSEQ, errno, strerror, perror 327
11.3 bool, false, true 329
11.4 va_list, va_start, va_arg, va_end 329
11.5 Standard C Operator Macros 333
}

C(Character Processing)
{
12.1 isalnum, isalpha, iscntrl, iswalnum, iswalpha, iswcntrl 336
12.2 iscsym, iscsymf 338
12.3 isdigit, isodigit, isxdigit, iswdigit, iswxdigit 338
12.4 isgraph, isprint, ispunct, iswgraph, iswprint, iswpunct 339
12.5 islower, isupper, iswlower, iswupper 340
12.6 isblank, isspace, iswhite, iswspace 341
12.7 toascii 341
12.8 toint 342
12.9 tolower, toupper, towlower, towupper 342
12.10 wctype_t, wctype, iswctype 343
12.11 wctrans_t, wctrans 344
}

C(String Processing)
{
13.1 strcat, strncat, wcscat, wcsncat 348
13.2 strcmp, strncmp, wcscmp, wcsncmp 349
13.3 strcpy, strncpy, wcscpy, wcsncpy 350
13.4 strlen, wcslen 351
13.5 strchr, strrchr, wcschr, wcsrchr 351
13.6 strspn, strcspn, strpbrk, strrpbrk, wcsspn, wcscspn, wcspbrk 352
13.7 strstr, strtok, wcsstr, wcstok 354
13.8 strtod, strtof, strtold, strtol, strtoll, strtoul, strtoull 355
13.9 atof, atoi, atol, atoll 356
13.10 strcoll, strxfrm, wcscoll, wcsxfrm 356
}

C(Memory Functions)
{
14.1 memchr, wmemchr 359
14.2 memcmp, wmemcmp 360
14.3 memcpy, memccpy, memmove, wmemcpy, wmemmove 361
14.4 memset, wmemset 362
}

C(Input/Output Facilities)
{
15.1 FILE, EOF, wchar_t, wint_t, WEOF 365
15.2 fopen, fclose, fflush, freopen, fwide 366
15.3 setbuf, setvbuf 370
15.4 stdin, stdout, stderr 371
15.5 fseek, ftell, rewind, fgetpos, fsetpos 372
15.6 fgetc, fgetwc, getc, getwc, getchar, getwchar, ungetc, ungetwc 374
15.7 fgets, fgetws, gets 376
15.8 fscanf, fwscanf, scanf, wscanf, sscanf, swscanf 377
15.9 fputc, fputwc, putc, putwc, putchar, putwchar 385
15.10 fputs, fputws, puts 386
15.11 fprintf, printf, sprintf, snprintf, fwprintf, wprintf, swprintf 387
15.12 vfprintf, vfwprintf, vprintf, vwprintf, vsprintf, vswprintf, vfscanf, vfwscanf, vscanf, vwscanf, vsscanf, vswscanf 401
15.13 fread, fwrite 402
15.14 feof, ferror, clearerr 404
15.15 remove, rename 404
15.16 tmpfile, tmpnam, mktemp 405
}

C(General Utilities)
{
16.1 malloc, calloc, mlalloc, clalloc, free, cfree 407
16.2 rand, srand, RAND_MAX 410
16.3 atof, atoi, atol, atoll l 411
16.4 strtod, strtof, strtold, strtol, strtoll, strtoul, strtoull 412
16.5 abort, atexit, exit, _Exit, EXIT_FAILURE, EXIT_SUCCESS 414
16.6 getenv 415
16.7 system 416
16.8 bsearch, qsort 417
16.9 abs, labs, llabs, div, ldiv, lldiv 419
16.10 mblen, mbtowc, wctomb 420
16.11 mbstowcs, wcstombs 422

}

C(Mathematical Functions)
{
17.1 abs, labs, llabs, div, ldiv, lldiv 426
17.2 fabs 426
17.3 ceil, floor, lrint, llrint, lround, llround, nearbyint, round, rint, trunc 427
17.4 fmod, remainder, remquo 428
17.5 frexp, ldexp, modf, scalbn 429
17.6 exp, exp2, expm1, ilogb, log, log10, log1p, log2, logb 430
17.7 cbrt, fma, hypot, pow, sqrt 432
17.8 rand, srand, RAND_MAX 432
17.9 cos, sin, tan, cosh, sinh, tanh 433
17.10 acos, asin, atan, atan2, acosh, asinh, atanh 434
17.11 fdim, fmax, fmin 435
17.12 Type-Generic Macros 435
17.13 erf, erfc, lgamma, tgamma 439
17.14 fpclassify, isfinite, isinf, isnan, isnormal, signbit 440
17.15 copysign, nan, nextafter, nexttoward 441
17.16 isgreater, isgreaterequal, isless, islessequal, islessgreater, isunordered 442
}

C(Time and Date Functions)
{
18.1 clock, clock_t, CLOCKS_PER_SEC, times 443
18.2 time, time_t 445
18.3 asctime, ctime 445
18.4 gmtime, localtime, mktime 446
18.5 difftime 447
18.6 strftime, wcsftime 448

}

C(Control Functions)
{
19.1 assert, NDEBUG 453
19.2 system, exec 454
19.3 exit, abort 454
19.4 setjmp, longjmp, jmp_buf 454
19.5 atexit 456
19.6 signal, raise, gsignal, ssignal, psignal 456
19.7 sleep, alarm 458
}

C(Locale)
{
20.1 setlocale 461
20.2 localeconv 463
21 Extended Integer Types 467
}

C(General Rules)
{
21.1 General Rules 467
21.2 Exact-Size Integer Types 470
21.3 Least-Size Types of a Minimum Width 471
21.4 Fast Types of a Minimum Width 472
21.5 Pointer-Size and Maximum-Size Integer Types 473
21.6 Ranges of ptrdiff_t, size_t, wchar_t, wint_t, and sig_atomic_t 474
21.7 imaxabs, imaxdiv, imaxdiv_t 474
21.8 strtoimax, strtouimax 475
21.9 wcstoimax, wcstoumax 475
}

C(Floating-Point Environment)
{
22.1 Overview 477
22.2 Floating-Point Environment 478
22.3 Floating-Point Exceptions 479
22.4 Floating-Point Rounding Modes 481
}

C(Complex Arithmetic)
{
23 Complex Arithmetic 483
23.1 Complex Library Conventions 483
23.2 complex, _Complex_I, imaginary, _Imaginary_I, I 484
23.3 CX_LIMITED_RANGE 484
23.4 cacos, casin, catan, ccos, csin, ctan 485
23.5 cacosh, casinh, catanh, ccosh, csinh, ctanh 486
23.6 cexp, clog, cabs, cpow, csqrt 487
23.7 carg, cimag, creal, conj, cproj 488
}
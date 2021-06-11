# flex-tutor
> Flex scanner by example.


#### Tools needed to compile examples

* _rm_, _ls_, _sed_, _grep_
* _make_
* _flex_
* _g++_ or another C++ compiler

#### List of examples

- _f0.l_ - Minimal flex scanner that doesn't require linking with flex library. It copies ```stdin``` to ```stdout```.
- _f0b.l_ - Equivalent to _f0.l_ but it explicitly defines the default rule and introduces ```%noyywrap``` option.
- _f1.l_ - Flex scanner program illustrating different ways of including code sections in the generated file (sections with ```%{ ... %}``` and ```%top{ ... }```). It also illustrates how to instruct scanner to use a string instead of files for input (```yy_scan_string()``` and ```yy_delete_buffer()``` functions). It uses ```__FUNCTION__``` and ```__LINE__``` predefined macros to display where the code sections were included in the generated file (requires _--noline_ _flex_ option).
- _fwc.l_ - Very simple _wc_ type of utility that works with standard input only.
- _fwc2.l_ - More advanced _wc_ implementation. It supports multiple input files. It shows how to switch between multiple input files using ```yywrap()``` function. And shows how to use ```yyleng``` _flex_ variable (the length of ``yytext``) to update the number of characters count for word matches. 
- _fwc3.l_ - Similar to _fwc2.l_ but it uses ```<<EOF>>``` rule instead of ``yywrap()`` function to set up input files and print counters. 
- _fstr.l_ - Example scanner illustrating different functions that can be used to scan string instead of file input (``yy_scan_string()``, ``yy_scan_bytes()``, and ``yy_scan_buffer()``).
- _fmulstr.l_ - Example scanner illustrating how to switch between multiple input strings.

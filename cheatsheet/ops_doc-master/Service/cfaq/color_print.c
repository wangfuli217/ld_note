#include <stdio.h>

#define COLOR_RESET        "\033[0m"
#define COLOR_BOLD         "\033[1m"

#define COLOR_BLACK        "\033[0;30m"
#define COLOR_RED          "\033[0;31m"
#define COLOR_GREEN        "\033[0;32m"
#define COLOR_YELLOW       "\033[0;33m"
#define COLOR_BLUE         "\033[0;34m"
#define COLOR_MAGENTA      "\033[0;35m"
#define COLOR_CYAN         "\033[0;36m"
#define COLOR_WHITE        "\033[0;37m"
#define COLOR_DEFAULT      "\033[0;39m"

#define COLOR_BOLDBLACK    "\033[1;30m"
#define COLOR_BOLDRED      "\033[1;31m"
#define COLOR_BOLDGREEN    "\033[1;32m"
#define COLOR_BOLDYELLOW   "\033[1;33m"
#define COLOR_BOLDBLUE     "\033[1;34m"
#define COLOR_BOLDMAGENTA  "\033[1;35m"
#define COLOR_BOLDCYAN     "\033[1;36m"
#define COLOR_BOLDWHITE    "\033[1;37m"

#define COLOR_DARKGRAY     "\033[0;90m"
#define COLOR_LIGHTRED     "\033[0;91m"
#define COLOR_LIGHTGREEN   "\033[0;92m"
#define COLOR_LIGHTYELLOW  "\033[0;93m"
#define COLOR_LIGHTBLUE    "\033[0;94m"
#define COLOR_LIGHTMAGENTA "\033[0;95m"
#define COLOR_LIGHTCYAN    "\033[0;96m"
#define COLOR_LIGHTWHITE   "\033[0;97m"


#define Color_black(format, ...)        COLOR_BLACK format COLOR_RESET, ##__VA_ARGS__
#define Color_red(format, ...)          COLOR_RED format COLOR_RESET, ##__VA_ARGS__
#define Color_green(format, ...)        COLOR_GREEN format COLOR_RESET, ##__VA_ARGS__
#define Color_yellow(format, ...)       COLOR_YELLOW format COLOR_RESET, ##__VA_ARGS__
#define Color_blue(format, ...)         COLOR_BLUE format COLOR_RESET, ##__VA_ARGS__
#define Color_magenta(format, ...)      COLOR_MAGENTA format COLOR_RESET, ##__VA_ARGS__
#define Color_cyan(format, ...)         COLOR_CYAN format COLOR_RESET, ##__VA_ARGS__
#define Color_white(format, ...)        COLOR_WHITE format COLOR_RESET, ##__VA_ARGS__
#define Color_boldBlack(format, ...)    COLOR_BOLDBLACK format COLOR_RESET, ##__VA_ARGS__
#define Color_boldRed(format, ...)      COLOR_BOLDRED format COLOR_RESET, ##__VA_ARGS__
#define Color_boldGreen(format, ...)    COLOR_BOLDGREEN format COLOR_RESET, ##__VA_ARGS__
#define Color_boldYellow(format, ...)   COLOR_BOLDYELLOW format COLOR_RESET, ##__VA_ARGS__
#define Color_boldBlue(format, ...)     COLOR_BOLDBLUE format COLOR_RESET, ##__VA_ARGS__
#define Color_boldMagenta(format, ...)  COLOR_BOLDMAGENTA format COLOR_RESET, ##__VA_ARGS__
#define Color_boldCyan(format, ...)     COLOR_BOLDCYAN format COLOR_RESET, ##__VA_ARGS__
#define Color_boldWhite(format, ...)    COLOR_BOLDWHITE format COLOR_RESET, ##__VA_ARGS__
#define Color_darkGray(format, ...)     COLOR_DARKGRAY format COLOR_RESET, ##__VA_ARGS__
#define Color_lightRed(format, ...)     COLOR_LIGHTRED format COLOR_RESET, ##__VA_ARGS__
#define Color_lightGreen(format, ...)   COLOR_LIGHTGREEN format COLOR_RESET, ##__VA_ARGS__
#define Color_lightYellow(format, ...)  COLOR_LIGHTYELLOW format COLOR_RESET, ##__VA_ARGS__
#define Color_lightBlue(format, ...)    COLOR_LIGHTBLUE format COLOR_RESET, ##__VA_ARGS__
#define Color_lightMagenta(format, ...) COLOR_LIGHTMAGENTA format COLOR_RESET, ##__VA_ARGS__
#define Color_lightCyan(format, ...)    COLOR_LIGHTCYAN format COLOR_RESET, ##__VA_ARGS__
#define Color_lightWhite(format, ...)   COLOR_LIGHTWHITE format COLOR_RESET, ##__VA_ARGS__

int main(int argc, char *argv){
    printf(Color_black("Color_black\n"));
    printf(Color_red("Color_red\n"));
    printf(Color_green("Color_green\n"));
    printf(Color_yellow("Color_yellow\n"));
    printf(Color_blue("Color_blue\n"));
    printf(Color_magenta("Color_magenta\n"));
    printf(Color_cyan("Color_cyan\n"));
    printf(Color_white("Color_white\n"));
    
    printf(Color_boldBlack("Color_boldBlack\n"));
    printf(Color_boldRed("Color_boldRed\n"));
    printf(Color_boldGreen("Color_boldGreen\n"));
    printf(Color_boldYellow("Color_boldYellow\n"));
    printf(Color_boldBlue("Color_boldBlue\n"));
    printf(Color_boldMagenta("Color_boldMagenta\n"));
    printf(Color_boldCyan("Color_boldCyan\n"));
    printf(Color_boldWhite("Color_boldWhite\n"));
    
    printf(Color_lightRed("Color_lightRed\n"));
    printf(Color_lightGreen("Color_lightGreen\n"));
    printf(Color_lightYellow("Color_lightYellow\n"));
    printf(Color_lightBlue("Color_lightBlue\n"));
    printf(Color_lightMagenta("Color_lightMagenta\n"));
    printf(Color_lightCyan("Color_lightCyan\n"));
    printf(Color_lightWhite("Color_lightWhite\n"));
    return 0;
}

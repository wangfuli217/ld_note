// 输入某三角形的三个边的长度，判断出这是个什么三角形（等腰、等边、任意，或不能构成）。
#include <stdio.h>

typedef enum {
    NONE,
    GENERAL,
    ISOSCELES,
    EQUILATERAL
} TriangleType;

const char* describe_triangle(TriangleType type){
    static char *arr[] = {"NONE", "GENERAL", "ISOSCELES", "EQUILATERAL"};
    return arr[type];
}

int check_positive(int a, int b, int c){
    return (a>0 && b>0 && c>0);
}
int check_general(int a, int b, int c){
    return (a + b > c) && (a + c > b) && (b + c > a);
}
int check_isosceles(int a, int b, int c){
    return (a==b || b==c || c==a);
}
int check_equilateral(int a, int b, int c){
    return (a==b && b==c);
}
TriangleType get_triangle_type(int a, int b, int c){
    if(!check_positive(a,b,c) || !check_general(a,b,c)) return NONE;
    if(check_equilateral(a,b,c)) return EQUILATERAL;
    if(check_isosceles(a,b,c)) return ISOSCELES;
    return GENERAL;
}

int main(){
    int a = 10, b = 20, c = 25;
    printf("%s\n", describe_triangle(get_triangle_type(a,b,c)));

    a = 10, b = 20, c = 35;
    printf("%s\n", describe_triangle(get_triangle_type(a,b,c)));

    a = 10, b = 20, c = 20;
    printf("%s\n", describe_triangle(get_triangle_type(a,b,c)));

    a = 10, b = 10, c = 10;
    printf("%s\n", describe_triangle(get_triangle_type(a,b,c)));
    return 0;
}
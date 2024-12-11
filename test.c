#include<stdio.h>

int main () {
    const char* str = "helo";
    size_t ln = 0;
    while (str[ln++]);
    printf("len : %d" , ln);
}
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char* concat(const char *str1, const char *str2)
{
    size_t len1 = strlen(str1);
    size_t len2 = strlen(str2);
    char* newStr = (char*)malloc(len1 + len2 + 1);
    strcpy(newStr, str1);
    strcat(newStr, str2);
    return newStr;
}
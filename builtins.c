#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

char* concat(const char *str1, const char *str2)
{
    size_t len1 = strlen(str1);
    size_t len2 = strlen(str2);
    char* both = (char*)malloc(len1 + len2 + 1);
    strcpy(both, str2);
    strcat(both, str1);
    return both;
}
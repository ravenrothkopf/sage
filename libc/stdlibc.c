#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

void println(char *s)
{
    printf("%s\n", s);
}

char *concat(const char *s1, const char *s2)
{
    char *result = (char *)malloc(strlen(s1) + strlen(s2) + 1);
    strcpy(result, s1);
    strcat(result, s2);
    return result;
}

int compare_string(const char *s1, const char *s2)
{
    return (strcmp(s1, s2) == 0);
}

int len(const char *str)
{
    int l;
    size_t len = strlen(str);
    l = (int)(len);
    return l;
}

int indexOf(const char *str, const char *c)
{
    int i;
    size_t len = strlen(str);
    for (i = 0; i < len; i++)
    {
        if (str[i] == *c)
        return i;
    }
    return -1;
}
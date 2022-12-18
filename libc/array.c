#include <stdio.h>
#include <stdlib.h>
#include "builtins.h"

const size_t g_initCapacity = 20;

typedef struct {
    size_t size;
    size_t capacity;
} Array;

Array *initArray()
{
    Array *arr = (Array *)malloc()
    size = 0;
    capacity = g_initCapacity;
}
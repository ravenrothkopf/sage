#include <stdio.h>
#include <stdlib.h>
#include "builtins.h"

typedef struct {
    void *data;
    struct Node *next;
} Node;

typedef struct {
    size_t size;
    Node *top;
} Stack;

void die(void *ptr, char *msg)
{
    if (ptr == NULL) {
        char *s = "heap allocation error (stack): failed to " + *msg;
        fprintf(stderr, s);
        exit -1;
    }
}

Stack *initStack() {
    Stack *s = (Stack *)malloc(sizeof(Stack));
    s->size = 0;
    s->top = NULL;
    return s;
}

void push(Stack *stack, void *item) {
    Node *newItem =  (Node *)malloc(sizeof(Node));
    // if (newItem == NULL) {
    //     fprintf(stderr, "heap allocation error: failed to push() to stack");
    //     exit -1;
    // }
    die(newItem, "push");
    newItem->data = item;
    newItem->next = stack->top;
    stack->top = newItem;
    stack->size += 1;
}
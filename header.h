#ifndef HEADER_H
#define HEADER_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Symbol table structure
typedef struct {
    char name[50];
    int value;
} Symbol;

// Three address code structure
typedef struct {
    char op[10];
    char arg1[50];
    char arg2[50];
    char result[50];
} ThreeAddressCode;

extern int yylex();
extern int yyparse();
extern FILE* yyin;
extern void yyerror(const char* s);

// Symbol table functions
Symbol* lookup(char* name);
void insert(char* name, int value);

// Three address code functions
void emit(char* op, char* arg1, char* arg2, char* result);
void printThreeAddressCode();

#endif
#ifndef HEADER_H
#define HEADER_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Error handling structure
typedef struct {
    int error_count;
    char last_error[256];
} ErrorInfo;

// Symbol table structure
typedef struct {
    char name[50];
    int value;
    int initialized;  // Track if variable is initialized
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
extern int yylineno;  // Track line numbers

// Global error info
extern ErrorInfo error_info;

// Symbol table functions
Symbol* lookup(char* name);
void insert(char* name, int value);
int is_initialized(char* name);

// Error handling functions
void report_error(const char* format, ...);
void reset_errors();
int get_error_count();

// Three address code functions
void emit(char* op, char* arg1, char* arg2, char* result);
void printThreeAddressCode();

#endif
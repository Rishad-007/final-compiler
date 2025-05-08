#include "header.h"

int main(int argc, char** argv) {
    if (argc != 2) {
        printf("Usage: %s input_file\n", argv[0]);
        return 1;
    }

    FILE* input = fopen(argv[1], "r");
    if (!input) {
        printf("Cannot open input file!\n");
        return 1;
    }

    yyin = input;
    printf("Code output:\n");
    printf("----------------\n");
    yyparse();
    printThreeAddressCode();
    
    fclose(input);
    return 0;
}
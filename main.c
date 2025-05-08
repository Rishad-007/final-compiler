#include "header.h"

ErrorInfo error_info = {0, ""};

void reset_errors() {
    error_info.error_count = 0;
    error_info.last_error[0] = '\0';
}

int get_error_count() {
    return error_info.error_count;
}

int main(int argc, char** argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s input_file\n", argv[0]);
        return 1;
    }

    FILE* input = fopen(argv[1], "r");
    if (!input) {
        fprintf(stderr, "Cannot open input file!\n");
        return 1;
    }

    // Reset error tracking
    reset_errors();
    
    yyin = input;
    printf("Code output:\n");
    printf("----------------\n");
    
    int parse_result = yyparse();
    
    if (get_error_count() > 0) {
        printf("\nCompilation finished with %d error(s)\n", get_error_count());
    } else {
        printThreeAddressCode();
    }
    
    fclose(input);
    return (get_error_count() > 0) ? 1 : 0;
}
#include "header.h"

// Global variable definitions
int loop_depth = 0;

void print_three_address_code() {
    ThreeAddressCode* current = code_head;
    int line_num = 1;
    int indent = 0;
    
    printf("\nThree Address Code Section:\n");
    printf("--------------------------\n");
    
    while (current != NULL) {
        // Handle indentation for nested blocks
        if (strcmp(current->op, "endif") == 0 || strcmp(current->op, "else") == 0) {
            indent--;
        }
        
        // Print line number and indentation
        printf("%3d: ", line_num++);
        for (int i = 0; i < indent; i++) {
            printf("    ");
        }
        
        // Print the three-address code with proper formatting
        if (strcmp(current->op, "label") == 0) {
            printf("%s:\n", current->result);
        } else if (strcmp(current->op, "goto") == 0) {
            printf("goto %s\n", current->result);
        } else if (strcmp(current->op, "ifFalse") == 0) {
            printf("if %s == false goto %s\n", current->arg1, current->arg2);
        } else if (strcmp(current->op, "if") == 0) {
            printf("if %s begin\n", current->arg1);
            indent++;
        } else if (strcmp(current->op, "else") == 0) {
            printf("else begin\n");
            indent++;
        } else if (strcmp(current->op, "endif") == 0) {
            printf("endif\n");
        } else if (strcmp(current->op, "=") == 0) {
            printf("%s := %s\n", current->result, current->arg1);
        } else if (strcmp(current->op, "printf") == 0) {
            printf("print %s\n", current->arg1);
        } else {
            printf("%s := %s %s %s\n", current->result, current->arg1, current->op, current->arg2);
        }
        
        current = current->next;
    }
    printf("\n");
}

void evaluate_three_address_code() {
    ThreeAddressCode* current = code_head;
    ThreeAddressCode* start = code_head;  // Keep track of start for jumping
    int should_execute = 1;
    char* jump_to_label = NULL;
    
    printf("\nCode Output Section:\n");
    printf("------------------\n");
    
    while (current != NULL) {
        // Label handling
        if (strcmp(current->op, "label") == 0) {
            if (jump_to_label && strcmp(current->result, jump_to_label) == 0) {
                should_execute = 1;
                jump_to_label = NULL;
            }
        }
        // Condition and jump handling
        else if (strcmp(current->op, "ifFalse") == 0) {
            int val = get_symbol_value(current->arg1);
            if (!val) {  // If condition is false, we should jump
                jump_to_label = current->arg2;
                should_execute = 0;  // Stop executing until we reach the label
            }
        }
        else if (strcmp(current->op, "goto") == 0) {
            jump_to_label = current->result;
            should_execute = 0;
        }
        // Execute operations only when should_execute is true
        else if (should_execute) {
            if (strcmp(current->op, "=") == 0) {
                if (current->arg1[0] >= '0' && current->arg1[0] <= '9') {
                    set_symbol_value(current->result, atoi(current->arg1));
                } else {
                    set_symbol_value(current->result, get_symbol_value(current->arg1));
                }
            } 
            else if (strcmp(current->op, "+") == 0) {
                int val1 = (current->arg1[0] >= '0' && current->arg1[0] <= '9') ? 
                          atoi(current->arg1) : get_symbol_value(current->arg1);
                int val2 = (current->arg2[0] >= '0' && current->arg2[0] <= '9') ? 
                          atoi(current->arg2) : get_symbol_value(current->arg2);
                set_symbol_value(current->result, val1 + val2);
            }
            else if (strcmp(current->op, "-") == 0) {
                int val1 = (current->arg1[0] >= '0' && current->arg1[0] <= '9') ? 
                          atoi(current->arg1) : get_symbol_value(current->arg1);
                int val2 = (current->arg2[0] >= '0' && current->arg2[0] <= '9') ? 
                          atoi(current->arg2) : get_symbol_value(current->arg2);
                set_symbol_value(current->result, val1 - val2);
            }
            else if (strcmp(current->op, "*") == 0) {
                int val1 = (current->arg1[0] >= '0' && current->arg1[0] <= '9') ? 
                          atoi(current->arg1) : get_symbol_value(current->arg1);
                int val2 = (current->arg2[0] >= '0' && current->arg2[0] <= '9') ? 
                          atoi(current->arg2) : get_symbol_value(current->arg2);
                set_symbol_value(current->result, val1 * val2);
            }
            else if (strcmp(current->op, "/") == 0) {
                int val1 = (current->arg1[0] >= '0' && current->arg1[0] <= '9') ? 
                          atoi(current->arg1) : get_symbol_value(current->arg1);
                int val2 = (current->arg2[0] >= '0' && current->arg2[0] <= '9') ? 
                          atoi(current->arg2) : get_symbol_value(current->arg2);
                if (val2 != 0) {
                    set_symbol_value(current->result, val1 / val2);
                } else {
                    fprintf(stderr, "Error: Division by zero\n");
                }
            }
            else if (strcmp(current->op, ">") == 0) {
                int val1 = (current->arg1[0] >= '0' && current->arg1[0] <= '9') ? 
                          atoi(current->arg1) : get_symbol_value(current->arg1);
                int val2 = (current->arg2[0] >= '0' && current->arg2[0] <= '9') ? 
                          atoi(current->arg2) : get_symbol_value(current->arg2);
                set_symbol_value(current->result, val1 > val2);
            }
            else if (strcmp(current->op, "<") == 0) {
                int val1 = (current->arg1[0] >= '0' && current->arg1[0] <= '9') ? 
                          atoi(current->arg1) : get_symbol_value(current->arg1);
                int val2 = (current->arg2[0] >= '0' && current->arg2[0] <= '9') ? 
                          atoi(current->arg2) : get_symbol_value(current->arg2);
                set_symbol_value(current->result, val1 < val2);
            }
            else if (strcmp(current->op, "==") == 0) {
                int val1 = (current->arg1[0] >= '0' && current->arg1[0] <= '9') ? 
                          atoi(current->arg1) : get_symbol_value(current->arg1);
                int val2 = (current->arg2[0] >= '0' && current->arg2[0] <= '9') ? 
                          atoi(current->arg2) : get_symbol_value(current->arg2);
                set_symbol_value(current->result, val1 == val2);
            }
            else if (strcmp(current->op, "printf") == 0) {
                int value = (current->arg1[0] >= '0' && current->arg1[0] <= '9') ? 
                           atoi(current->arg1) : get_symbol_value(current->arg1);
                printf("%d\n", value);
            }
        }
        
        // Move to next instruction
        current = current->next;
        
        // If we need to jump and we've processed all instructions, start over
        if (jump_to_label != NULL && current == NULL) {
            current = start;
        }
    }
    printf("\n");
}

int get_symbol_value(char* name) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbols[i].name, name) == 0) {
            return symbols[i].value;
        }
    }
    return 0;
}

void set_symbol_value(char* name, int value) {
    for (int i = 0; i < symbol_count; i++) {
        if (strcmp(symbols[i].name, name) == 0) {
            symbols[i].value = value;
            return;
        }
    }
    symbols[symbol_count].name = strdup(name);
    symbols[symbol_count].value = value;
    symbol_count++;
}

int main() {
    FILE* input = fopen("input.txt", "r");
    if (!input) {
        printf("Error: Cannot open input.txt\n");
        return 1;
    }
    yyin = input;

    // Parse input and generate three-address code
    yyparse();

    // First evaluate the code to compute all values
    evaluate_three_address_code();

    // Then print the three-address code
    print_three_address_code();

    // Cleanup
    fclose(input);
    return 0;
}
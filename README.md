# Mini Compiler Project

A simple compiler implementation that can evaluate arithmetic expressions, handle if-else statements, and process for loops. The compiler generates three-address code as an intermediate representation.

## Author

**MD. Rishad Nur**  
Department of Computer Science and Engineering  
Begum Rokeya University, Rangpur (BRUR)

### Contact
- Email: rishad.nur007@gmail.com
- Facebook: [www.facebook.com/rishad.nur](https://www.facebook.com/rishad.nur)

## Features

1. **Arithmetic Expression Evaluation**
   - Supports basic arithmetic operations (+, -, *, /)
   - Evaluates expressions and prints results
   - Generates corresponding three-address code

2. **Control Structures**
   - If-else statements with condition evaluation
   - For loops with counter-based iteration
   - Nested control structures support

3. **Output Generation**
   - Printf function support for output
   - Three-address code generation
   - Intermediate code representation

## Project Structure

```
compilerProject/
├── header.h        # Header file with data structures and declarations
├── lexer.l         # Flex (lexical analyzer) source file
├── parser.y        # Bison (parser) source file
├── main.c          # Main program file
└── input.txt       # Sample input file for testing
```

## Prerequisites

- GCC (GNU Compiler Collection)
- Flex (Fast Lexical Analyzer)
- Bison (Parser Generator)

## Building the Project

1. Generate the parser and header files:
   ```bash
   bison -d parser.y
   ```

2. Generate the lexical analyzer:
   ```bash
   flex lexer.l
   ```

3. Compile all source files:
   ```bash
   gcc -o compiler main.c parser.tab.c lex.yy.c -ly -ll
   ```

## Usage

1. Create an input file with your code (e.g., input.txt)
2. Run the compiler:
   ```bash
   ./compiler input.txt
   ```

## Input File Format

The compiler accepts input files with the following syntax:

```c
// Arithmetic operations
x = 5;
y = 10;
Printf(x + y);

// If-else statements
if (x < y) {
    z = x * 2;
    Printf(z);
} else {
    z = y * 2;
    Printf(z);
}

// For loops
for (i = 0; i < 3; i = i + 1) {
    Printf(i);
}
```

## Output Format

The compiler generates two types of output:

1. **Code Output**: Results of executed statements
   ```
   Code output:
   ----------------
   Output: 15
   Output: 10
   ...
   ```

2. **Three Address Code**: Intermediate representation
   ```
   Three Address Code:
   ------------------
   x := 5
   y := 10
   t0 := 5 + 10
   ...
   ```

## Error Handling

The compiler includes basic error handling for:
- Undefined variables
- Division by zero
- Syntax errors
- Lexical errors

## Contributing

Feel free to submit issues and enhancement requests.
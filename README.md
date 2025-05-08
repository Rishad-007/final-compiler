# Simple Compiler with Flex and Bison

A basic compiler implementation using Flex (lexical analyzer) and Bison (parser) that can handle arithmetic operations, if-else statements, and for loops. The compiler reads input from a file and generates three-address code as an intermediate representation.

## Author

**MD. Rishad Nur**  
Department of Computer Science and Engineering  
Begum Rokeya University, Rangpur (BRUR)

Contact:

- Email: rishad.nur007@gmail.com
- Facebook: [www.facebook.com/rishad.nur](https://www.facebook.com/rishad.nur)

## License and Usage Rights

This project is completely free and open for anyone to use, modify, and redistribute under the MIT License. You are welcome to:

- Use this code in your projects (commercial or non-commercial)
- Modify and adapt the code to your needs
- Share and distribute the code
- Use it for educational purposes

The only requirement is to include the copyright notice and the MIT license text in any substantial portions of the code that you use.

## Features

- Lexical analysis using Flex
- Parsing using Bison
- Support for:
  - Arithmetic operations (+, -, \*, /)
  - If-else statements
  - For loops
  - Variable assignments
  - Comparison operators (<, >, ==)
- Three-address code generation
- Symbol table management

## Prerequisites

To build and run this compiler, you need:

- Flex (The Fast Lexical Analyzer)
- Bison (GNU Parser Generator)
- GCC (GNU Compiler Collection)
- Make (Optional, but recommended)

On macOS, you can install these using Homebrew:

```bash
brew install flex bison gcc make
```

On Ubuntu/Debian:

```bash
sudo apt-get install flex bison gcc make
```

## Project Structure

```
.
├── README.md
├── header.h        # Common header file with data structures and declarations
├── lexer.l         # Flex lexical analyzer specification
├── parser.y        # Bison parser specification
├── main.c         # Main program file
└── input.txt      # Sample input file
```

## Building the Compiler

1. Generate the parser source files:

   ```bash
   bison -d parser.y
   ```

2. Generate the lexer source files:

   ```bash
   flex lexer.l
   ```

3. Compile all source files:
   ```bash
   gcc lex.yy.c parser.tab.c main.c -o compiler
   ```

## Usage

1. Create an input file (`input.txt`) with your code. Example:

   ```
   x = 5;
   y = 10;
   z = x + y * 2;

   if (z > 20) {
       result = z - 5;
   } else {
       result = z + 5;
   }

   for (i = 0; i < 5; i = i + 1) {
       sum = sum + i;
   }
   ```

2. Run the compiler:
   ```bash
   ./compiler
   ```

The compiler will read the input file and generate three-address code as output.

## Three-Address Code Generation

The compiler generates three-address code as an intermediate representation. Examples of generated code:

```
t0 = y * 2
t1 = x + t0
z = t1
t2 = z > 20
if t2 == false goto L0
t3 = z - 5
result = t3
goto L1
L0:
t4 = z + 5
result = t4
L1:
```

## Features Explanation

1. **Arithmetic Operations**

   - Supports basic arithmetic operations (+, -, \*, /)
   - Handles operator precedence correctly
   - Generates temporary variables for intermediate results

2. **Control Structures**

   - If-else statements with proper branching
   - For loops with initialization, condition, and increment
   - Proper label generation for control flow

3. **Symbol Table**
   - Maintains a symbol table for variables
   - Tracks variable assignments and values
   - Supports variable lookup and modification

## Limitations

- No support for functions or procedures
- Limited to integer arithmetic
- No type checking
- No optimization of the generated code
- No error recovery mechanism

## Contributing

Feel free to contribute to this project by:

1. Forking the repository
2. Creating a feature branch
3. Committing your changes
4. Creating a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Future Improvements

- Add support for floating-point numbers
- Implement function declarations and calls
- Add type checking and error recovery
- Optimize the generated three-address code
- Add support for arrays and pointers
- Implement a more sophisticated symbol table
- Add support for string operations
- Implement constant folding and propagation

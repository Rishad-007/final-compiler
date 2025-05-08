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

   - Supports basic arithmetic operations (+, -, \*, /)
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


## Detailed Examples

### Example 1: Arithmetic Operations

**Input:**

```c
// Basic arithmetic
a = 10;
b = 5;
c = 2;

// Addition and multiplication
result1 = a + b;
Printf(result1);    // Output: 15

// Complex expression
result2 = (a * b) + (c * c);
Printf(result2);    // Output: 54

// Division
result3 = a / c;
Printf(result3);    // Output: 5
```

**Generated Three Address Code:**

```
Three Address Code:
------------------
a := 10
b := 5
c := 2
t0 := 10 + 5
result1 := t0
print 15
t1 := 10 * 5
t2 := 2 * 2
t3 := t1 + t2
result2 := t3
print 54
t4 := 10 / 2
result3 := t4
print 5
```

### Example 2: If-Else Statements

**Input:**

```c
x = 5;
y = 10;

if (x < y) {
    result = x * 2;
    Printf(result);    // Output: 10
} else {
    result = y * 2;
    Printf(result);
}
```

**Generated Three Address Code:**

```
Three Address Code:
------------------
x := 5
y := 10
t0 := 5 < 10
if_false t0 goto else_label
t1 := 5 * 2
result := t1
print 10
goto end_if
else_label:
t2 := 10 * 2
result := t2
print 20
end_if:
```

### Example 3: For Loop

**Input:**

```c
sum = 0;
for (i = 1; i <= 5; i = i + 1) {
    sum = sum + i;
    Printf(sum);    // Outputs: 1, 3, 6, 10, 15
}
```

**Generated Three Address Code:**

```
Three Address Code:
------------------
sum := 0
i := 1
loop_start:
t0 := i <= 5
if_false t0 goto loop_end
t1 := sum + i
sum := t1
print sum
t2 := i + 1
i := t2
goto loop_start
loop_end:
```

### Example 4: Combined Features

**Input:**

```c
// Initialize variables
max = 100;
sum = 0;
count = 0;

// Calculate sum of numbers divisible by both 3 and 5
for (i = 1; i <= max; i = i + 1) {
    if ((i / 3) * 3 == i) {
        if ((i / 5) * 5 == i) {
            sum = sum + i;
            count = count + 1;
            Printf(i);    // Prints numbers divisible by both 3 and 5
        }
    }
}

Printf(sum);     // Print total sum
Printf(count);   // Print count of numbers found
```

**Generated Three Address Code:**

```
Three Address Code:
------------------
max := 100
sum := 0
count := 0
i := 1
loop_start:
t0 := i <= max
if_false t0 goto loop_end
t1 := i / 3
t2 := t1 * 3
t3 := t2 == i
if_false t3 goto continue
t4 := i / 5
t5 := t4 * 5
t6 := t5 == i
if_false t6 goto continue
t7 := sum + i
sum := t7
t8 := count + 1
count := t8
print i
continue:
t9 := i + 1
i := t9
goto loop_start
loop_end:
print sum
print count
```

## Error Handling

The compiler includes basic error handling for:

- Undefined variables
- Division by zero
- Syntax errors
- Lexical errors

## Error Examples and Handling

### 1. Division by Zero

**Input:**

```c
a = 10;
b = 0;
c = a / b;    // Error: Division by zero!
```

### 2. Undefined Variable

**Input:**

```c
x = y + 5;    // Error: Undefined variable y
```

### 3. Syntax Error

**Input:**

```c
if x < 10 {    // Error: Missing parentheses
    Printf(x);
}
```

## Performance Considerations

- The compiler performs single-pass parsing
- Three-address code generation is optimized for readability
- Symbol table uses linear search for variable lookup
- Error recovery is basic - stops at first error encountered

## Limitations

1. No support for:

   - Floating point numbers
   - String operations
   - Function definitions
   - Arrays or complex data structures

2. Control structures:

   - No switch statements
   - No do-while loops
   - No break/continue statements

3. Error handling:
   - Basic error recovery
   - Limited semantic error checking

## Contributing

Feel free to submit issues and enhancement requests.

# Umbra

Umbra is a minimal, high-level programming language that compiles to the Syzygy B100's assembly language.

## Status

* Tokens: DONE
* Grammar: DONE
* Parser: DONE
* Compiler: In progress

## Features

* Variables can have values from 0 - 65535
* Strings will be supported as character arrays
* Conditional branching (if, else if, else)
* Loops (while, for)
* Standard arithmetic operators (+, -, *, /, %)
* Standard bitwise operators (|, &, ~, ^)
* Bit count operator (?)
* Function calls
* Recursion
* Arrays

## Examples

```

# Constants can be declared
param LOOP_MAX = 100;

# Main function must come first; execution begins here
main {

  # For loop syntax is C-like
  for(var i = 0; i < LOOP_MAX; set i = i + 1) {
    
    # If statement, function calls start with "." (for earlier parsing decisions)
    if(.isPowerOfTwo(i)) {
      .print(i);
    }
  }
}

# Function declarations besides main start with "func"
# Multiple function arguments are allowed, but must be comma-separated
func isPowerOfTwo(var n) {
  
  # If the number of bits set in n is 1, it is a power of two.
  return ?n == 1;
}

```

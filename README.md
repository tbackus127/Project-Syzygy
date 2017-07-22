# SyzygyB100
A 16-bit CPU created with the Vivado development suite from Xilinx, written in Verilog.

## Architecture
The B100, unlike its 8\-bit counterpart, the A100, has 16 registers available (R0\-RF):
* R0: Instruction register (not directly writeable)
* R1: Program counter (not directly writeable)
* R2: ALU accumulator, comparison register, push instruction destination
* R3: Jump address
* R4: Bits 0-15 of peripheral I/O
* R5: Bits 16-31 of peripheral I/O (if peripheral has 32-bit mode enabled)
* R6: ALU operand 0 (A-side)
* R7: ALU operand 1 (B-side)
* R8\-RF: General purpose

## Instruction Set
Format: <4x: Opcode\> <12x: Options\>
```
sys - System Instructions.
0000 pppp cccc cccc
  p: Operation to perform:
    0: NO-OP
    1: System command
    2-15: (UNUSED)
  c: When p=1: command:
    0: Von Neumann mode ON
    1: Von Neumann mode OFF
    2-255: (UNUSED)

push - Sets R2 to the specified number.
1nnn nnnn nnnn nnnn
  n: 15-bit value to write to R2
  
copy - Copy the contents of one register to another
0001 ssss dddd n___
  s: source register
  d: destination register
  n: negate value before writing
  
Branching operations
0010 leg_ ____ ____
  l: Set R1 to the value in R3 if R0's value is less than 0.
  e: Set R1 to the value in R3 if R0's value equal to 0.
  g: Set R1 to the value in R3 if R0's value is greater than 0.
  
ALU operations
0011 _ppp abzn rff_
  p: Operation to perform:
    0: A (pass)
    1: A | B (logical OR)
    2: A + B (addition)
    3: Left shift A by B (only bits 0-3 of B are used)
    4: A XOR B
    5: Count bits of A
    6: (unused)
    7: (unused)
  a: Negate input A (does not overwrite contents of R6)
  b: Negate input B (does not overwrite contents of R6)
  z: Zero input B (does not overwrite contents of R6)
  n: Negate output
  r: Operation argument:
    when p=2: Increment result of addition
    when p=3: Shift right instead of left
  f: Shift argument:
    0: Logical shift
    1: Logical rotation
    2: Arithmetic shift
    3: Arithmetic rotation

io - Peripheral I/O operations
0100 dddd rrrr xm__
  d: Peripheral ID
  r: Peripheral register (ignored if x=1)
  x: Execute command
  m: Access mode
    0: Read the 32-bit value from peripheral ID d's register r and copy its bits 0-15 to R4, and its bits 16-31 bits to R5.
    1: Write R4 (bits 0-15) and R5 (bits 16-31) with the 32-bit value from peripheral ID d's register r.

(unused)
0101 ____ ____ ____

(unused)
0110 ____ ____ ____

(unused)
0111 ____ ____ ____

```

# SyzOS (Currently planning; everything is tentative)

An original minimal command line operating system for the Syzygy B100 CPU, written in SYZ assembly.

## Memory layout

* 0x0000: Stack frame pointer
* 0x0001 - 0x000F: (unknown)
* 0x0010 - 0x1FFF: OS Instructions
* 0x2000 - 0x2FFF: Call stack (4KB)
* 0x3000 - 0x3FFF: Allocation tracker (4KB, but only need 2KB)
* 0x4000 - 0x7FFF: Program memory (16KB, loaded from SD card when a program is ran)
* 0x8000 - 0xFFFF: Heap (32KB)

### Call stack frame

Measured in offset (16-bit words) from address in stack pointer

* 0: Return address
* 2: Return value's address
* 4: Number of arguments
* 6: Arguments pointer (to heap)
* 8: Number of local variables
* A: Variables pointer (to heap)
* C: (unknown)
* E: (unknown)

## Planned features
* Create and edit text files
* Boots from SD card; not hard-coded on FPGA
* Assemble and run programs within the operating system

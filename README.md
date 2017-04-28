# SyzygyB100
A 16-bit CPU created in Logisim.

## Architecture
The B100, unlike its 8\-bit counterpart, the A100, has 16 registers available (R0\-RF):
* R0: Instruction register
* R1: Program counter
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
0000 ???? ???? ????
(to be decided)

push - Sets R2 to the specified number.
1nnn nnnn nnnn nnnn
  n: 15-bit value to write to R2
  
copy - Copy the contents of one register to another
0010 ssss dddd n___
  s: source register
  d: destination register
  n: negate value before writing
  
ALU operations
0011 _ppp abzq rff_
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
  q: Negate output
  r: Operation argument:
    when p=2: Increment result of addition
    when p=3: Shift right instead of left
  f: Shift argument:
    0: Logical shift
    1: Logical rotation
    2: Arithmetic shift
    3: Arithmetic rotation

Branching operations
0100 leg_ ____ ____
  l: Set R1 to the value in R3 if R0's value is less than 0.
  e: Set R1 to the value in R3 if R0's value equal to 0.
  g: Set R1 to the value in R3 if R0's value is greater than 0.

io - Peripheral I/O operations
0101 dddd rrrr xmb_
  d: Peripheral ID
  r: Peripheral register (ignored if x=1)
  x: Execute command
  m: Access mode
    0: Read the value from peripheral ID d's register r and copy it to R4 (and R5 if b=1)
    1: Write R4 (and R5 if b=1) with the value from peripheral ID d's register r
  b: Enables 32-bit I/O mode. The peripheral must support 32-bit values, or only bits 0-15 will be transferred

(unused)
0110 ____ ____ ____

(unused)
0111 ____ ____ ____

```

# SyzOS (WIP!)

An original minimal command line operating system for the Syzygy B100 CPU, written in SYZ assembly.

### Planned features
* Create and edit text files
* Boots from SD card; not hard-coded on FPGA
* Assemble and run programs within the operating system

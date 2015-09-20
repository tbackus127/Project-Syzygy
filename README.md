# SyzygyB100
A 16-bit CPU created in Logisim.

## Architecture
The B100, unlike its 8\-bit counterpart, the A100, has 16 registers available (R0\-RF):
* R0: ALU output
* R1: Jump address, instruction input

## Instruction Set
Format: <4x: Opcode\> <12x: Options\>

sys - System Instructions.
0000 ???? ???? ????

push - Sets R1 to the specified number.
0001 nnnn nnnn nnnn
  n: 12-bit value to set R1 to.
  
mov - Swap, copy, or move a value from one register to another.
0010 oooo aaaa bbbb
  a: Register source
  b: Register destination
  o: Move operation to perform:
    0: Move \- Sets b to a's value, and clears a.
    1: Copy \- Sets b to a's value while retaining the value of a.
    2: Swap \- Switches the values in a and b.

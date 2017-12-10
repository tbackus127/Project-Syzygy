# SyzygyB100
A 16-bit CPU created with the Vivado development suite from Xilinx, written in Verilog.

## Architecture
The B100, unlike its 8\-bit counterpart, the A100, has 16 registers available (R0\-RF):
* R0: Instruction register (not directly writeable)
* R1: Program counter (not directly writeable)
* R2: ALU accumulator, comparison register, push instruction destination
* R3: Jump address
* R4: Bits 0-15 of peripheral I/O
* R5: Bits 16-31 of peripheral I/O (if peripheral can accept 32-bit values; ignored otherwise)
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
  s: source register; if s = 0, 0xF000 will be copied; if s = 1, 0xFFFF will be copied
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

## How to Use

You will need the Basys 3 FPGA, a license for the Vivado development suite, the pmodSD module for the Basys 3, an 8GB standard-size SDHC card, a VGA cable and VGA monitor, and a USB keyboard to use this CPU.

1. Install the latest version of Vivado.
2. Import this project into Vivado from the cpu/ directory.
3. Configure Vivado to target the Basys 3.
4. Perform a low-level format on the 8GB SD card (so it has no file system).
5. Use either the assembler or compiler to create a small program for the CPU to run.
6. Copy the binary data from the compiled .bin file onto sector 0 of the SD card using a hex editor. Programs that span more than one sector will need to have the bootloader edited to enable multiple sector reads. You can find the bootloader in os/boot/bootloader.syz. The BootRom.v file will also need to have its internal ROM capacity expanded (cpu/SyzygyB100\.srcs/sources_1/new/BootRom\.v).
7. Synthesize and implement the system (this takes a little more than 3 minutes on an overclocked 2500K, so be patient)
8. In Vivado, open the hardware manager, and generate the bitstream.
9. Make sure your Basys 3 is turned on and connected to your computer, and that the pmodSD module is inserted in the JB PMod port (top-right) with the SD card inside.
10. Click 'write bitstream' in Vivado. The CPU should now be running the program on the SD card after it boots.

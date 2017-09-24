# SyzOS (Currently planning; everything is tentative)

An original minimal command line operating system for the Syzygy B100 CPU.

## Memory layout

* 0x0000 - 0x1FFF: OS Instructions
* 0x2000: Call Stack Pointer (address of start of current stack frame)
* 0x2001: Arguments Pointer (address of first argument in the current stack frame)
* 0x2002: Environment Stack Pointer (address of first word of the current variable scope frame)
* 0x2003: Working Stack Pointer (address of the top operand in the evaluation stack)
* 0x2004: Heap Head (address of the next free segment of memory for arrays/objects)
* 0x2005 - 0x200F: TBD
* 0x2010 - 0x20FF: Working Stack
* 0x2100 - 0x27FF: Call Stack
* 0x2800 - 0x2FFF: Environment Stack
* 0x3000 - 0x4DFF: Heap Space
* 0x4E00 - 0x4FFF: Heap Allocation Tracker (each bit corresponds to one memory address in the heap> If 0, that address is unused; if 1, it is allocated)
* 0x5000 - 0xAFFF: Program Instructions (empty unless a program is running; loaded from SD card)
* 0xB000 - 0xFAFF: Video Memory (640x480, monochrome; one bit represents one pixel)

### Call stack frame

Offsets are relative to the stack pointer's value.

* 0: Return address
* 1: Return value's address
* 2: Number of function arguments
* 3 - End: Function argument values/pointers

### Environment stack frame

* 0: Previous frame's start
* 1: Number of variables in this scope (environment variables)
* 2 - End: Environment variables

## Planned features
* Create and edit text files
* Boots from SD card; not hard-coded on FPGA (DONE!)
* Assemble and run programs within the operating system

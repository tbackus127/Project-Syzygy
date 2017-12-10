# Syz Assembler

An assembler for the Syzygy B100 CPU written in Java.

## Features

* Converts human-readable Syz Assembly (.syz files) into binary files the CPU can execute.
* Assembler allows named labels and config file values.
* Also includes a binary to hex converter for use in Vivado.

## How to Use

1. Ensure the latest version of the JDK is installed and configured properly.
2. Open a terminal in tools/assembler/src.
3. Enter: 'javac com/rath/syzasm/\*.java' to compile.
4. Create a .syz assembly file.
5. Enter: 'java com/rath/syzasm/Assembler PATH_TO_SYZ_FILE', replacing PATH_TO_SYZ_FILE with the relative path to the assembly file you want to convert.
6. Optional, to write hex values out for the machine code, enter: 'java com/rath/syzasm/HexWriter PATH_TO_BIN_FILE', replacing PATH_TO_SYZ_FILE with the relative path to the binary file that was created by the assembler.

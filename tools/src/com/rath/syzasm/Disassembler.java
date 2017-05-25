package com.rath.syzasm;

public class Disassembler {

  public static final String disassemble(final short val) {

    String result = "NO-OP";

    // If it's a push instruction
    if (isolateBit(val, (short) 15)) {
      result = "push " + (val & 0x7fff);

    } else {

      // Otherwise, isolate the opcode and parse accordingly
      final short opcode = (short) (val >>> 12);

      // Nybble variables
      short arg0 = 0;
      short arg1 = 0;

      // Parse based on opcode
      switch (opcode) {

        // Sys instruction
        case 0:

        // TODO: Finish after decide system instructions

        break;

        // Copy instruction
        case 1:
          arg0 = (short) ((val >>> 8) & 0x000f);
          arg1 = (short) ((val >>> 4) & 0x000f);

          result = "copy " + arg0 + ", " + arg1;
        break;

        // Jump instruction
        case 2:

          arg0 = (short) ((val >>> 9) & 0x0007);

          // Parse jump argument
          switch (arg0) {
            case 0b001:
              result = "jgt";
            break;
            case 0b010:
              result = "jeq";
            break;
            case 0b011:
              result = "jge";
            break;
            case 0b100:
              result = "jlt";
            break;
            case 0b101:
              result = "jne";
            break;
            case 0b110:
              result = "jle";
            break;
            case 0b111:
              result = "jmp";
          }
        break;

        // ALU instruction
        case 3:

          // Isolate ALU operation
          arg0 = (short) ((val >>> 8) & 0x000f);
          switch (arg0) {
            case 0:
              result = "pass";
            break;
            case 1:
              result = "or";
            break;
            case 2:
              result = "add";
            break;
            case 3:

              // arithmetic shift
              if (isolateBit(val, (short) 2)) {
                result = "a";
              } else {
                result = "l";
              }

              // shift/rotate
              if (isolateBit(val, (short) 1)) {
                result += "r";
              } else {
                result += "s";
              }

              // shift direction
              if (isolateBit(val, (short) 4)) {
                result += "r";
              } else {
                result += "l";
              }

            break;
            case 4:
              result = "xor";
            break;
            case 5:
              result = "cnt";
          }

        // pre-ops
        // TODO: pre-ops

        // post-ops
        // TODO: pre-ops

        break;

        // I/O instruction
        case 4:
          result = "io";
          arg0 = (short) ((val >>> 8) & 0x000f);
          arg1 = (short) ((val >>> 4) & 0x000f);

          // Execute
          if (isolateBit(val, (short) 3)) {
            result += "ex " + arg0;
          } else {

            // Mode (0 = read, 1 = write)
            if (isolateBit(val, (short) 2)) {
              result += "s";
            } else {
              result += "g";
            }

            // Check 32-bit mode
            if (isolateBit(val, (short) 1)) {
              result += "d ";
            } else {
              result += "r ";
            }
            result += arg0 + ", " + arg1;
          }
        break;
      }
    }

    return result;
  }

  /**
   * Isolates a bit from a short.
   * 
   * @param val the short to isolate the bit from.
   * @param bit the bit number (15..0) to isolate.
   * @return true if it's a 1, false if it's a 0.
   */
  private static final boolean isolateBit(final short val, final short bit) {

    return ((val >>> bit) & 0x0001) == 1;
  }

}

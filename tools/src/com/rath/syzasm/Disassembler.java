
package com.rath.syzasm;

import java.util.HashMap;

/**
 * This class will decode SyzB machine code into its human-readable assembly language.
 * 
 * @author Tim Backus tbackus127@gmail.com
 *
 */
public class Disassembler {
  
  /**
   * Pre-operation encoding map.
   */
  private static final HashMap<Short, String> PRE_MAP = new HashMap<Short, String>() {
    
    /** Serial version UID. */
    private static final long serialVersionUID = 1L;
    
    {
      put(new Short((short) 0), "");
      put(new Short((short) 1), "z");
      put(new Short((short) 2), "nb");
      put(new Short((short) 3), "nzb");
      put(new Short((short) 4), "n");
      put(new Short((short) 5), "nz");
      put(new Short((short) 6), "nn");
      put(new Short((short) 7), "nnz");
    }
  };
  
  /** Aliased ops. */
  private static final HashMap<String, String> ALIASES = new HashMap<String, String>() {
    
    /** Serial version UID. */
    private static final long serialVersionUID = 1L;
    
    {
      put("nbaddi", "sub");
      put("zaddi", "inc");
      put("nzbadd", "dec");
      put("orn", "nor");
      put("nnorn", "and");
      put("nnor", "nand");
      put("xorn", "xnor");
      put("passn", "neg");
    }
  };
  
  /**
   * Decodes a 16-bit machine instruction into SyzB assembly.
   * 
   * @param val the instruction as a short.
   * @return the assembly String.
   */
  public static final String disassemble(final short val) {
    
    String result = "NO-OP";
    
    // If it's a push instruction
    if (isolateBit(val, (short) 15)) {
      result = "push " + (val & 0x7fff);
      
    } else {
      
      // Otherwise, isolate the opcode and parse accordingly
      final short opcode = isolateBitRange(val, (short) 14, (short) 12);
      
      System.err.println("Opcode: " + opcode);
      
      // Nybble variables
      short arg0 = 0;
      short arg1 = 0;
      
      // Parse based on opcode
      switch (opcode) {
        
        // Sys instruction
        // TODO: Finish after decide system instructions
        case 0:
        
        break;
      
        // Copy instruction
        case 1:
          
          // Read register
          arg0 = isolateBitRange(val, (short) 11, (short) 8);
          
          // Write register
          arg1 = isolateBitRange(val, (short) 7, (short) 4);
          
          result = "copy " + arg0 + ", " + arg1;
        break;
      
        // Jump instruction
        case 2:
          
          // Jump conditions
          arg0 = isolateBitRange(val, (short) 11, (short) 9);
          
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
          arg0 = isolateBitRange(val, (short) 10, (short) 8);
          switch (arg0) {
            
            // Pass value
            case 0:
              result = "pass";
            break;
          
            // Logical OR
            case 1:
              result = "or";
            break;
          
            // Add
            case 2:
              result = "add";
              
              // Check increment bit
              if (isolateBit(val, (short) 3)) {
                result += "i";
              }
            break;
          
            // Shift
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
              if (isolateBit(val, (short) 3)) {
                result += "r";
              } else {
                result += "l";
              }
              
            break;
          
            // Exclusive-OR
            case 4:
              result = "xor";
            break;
          
            // Bit counting
            case 5:
              result = "cnt";
          }
          
          // pre-ops
          arg1 = isolateBitRange(val, (short) 7, (short) 5);
          result = (PRE_MAP.get(arg1)) + result;
          
          // post-op negation flag
          if (isolateBit(val, (short) 4)) {
            result += "n";
          }
          
          // Look up the op's alias if it exists
          if (ALIASES.containsKey(result)) {
            result = ALIASES.get(result);
          }
          
        break;
      
        // I/O instruction
        case 4:
          result = "io";
          arg0 = isolateBitRange(val, (short) 11, (short) 8);
          arg1 = isolateBitRange(val, (short) 7, (short) 4);
          
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
  
  /**
   * Isolates a bit range from a short.
   * 
   * @param val the short to isolate the bits from.
   * @param msb the most significant (inclusive) bit to start at, zero-indexed.
   * @param lsb the least significant (inclusive) bit to end at, zero-indexed.
   * @return the value of the isolated bits, as a short.
   */
  private static final short isolateBitRange(final short val, final short msb, final short lsb) {
    
    final short shiftAmt = (short) (16 - msb - 1);
    final short bitmask = (short) (0xffff >>> shiftAmt);
    final short valMasked = (short) (val & bitmask);
    return (short) (valMasked >>> lsb);
    
  }
  
}

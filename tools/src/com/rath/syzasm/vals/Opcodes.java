
package com.rath.syzasm.vals;

/**
 * This class contains bitmask constants for opcode values.
 * 
 * @author Tim Backus tbackus127@gmail.com
 */
public class Opcodes {
  
  /** Bitmask for push instruction. */
  public static final short PUSH = (short) 0x8000;
  
  /** Bitmask for system instruction (TBD). */
  public static final short SYS = (short) 0x0000;
  
  /** Bitmask for copy instruction. */
  public static final short COPY = (short) 0x1000;
  
  /** Bitmask for jump instruction. */
  public static final short JUMP = (short) 0x2000;
  
  /** Bitmask for ALU instruction. */
  public static final short ALU = (short) 0x3000;
  
  /** Bitmask for I/O instruction. */
  public static final short IO = (short) 0x4000;
  
}

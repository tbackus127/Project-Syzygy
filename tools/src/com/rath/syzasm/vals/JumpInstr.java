
package com.rath.syzasm.vals;

/**
 * This class contains bitmask constants for jump instructions.
 * 
 * @author Tim Backus tbackus127@gmail.com
 */
public class JumpInstr {
  
  /** Always jump. */
  public static final short JMP = (short) 0x0e00;
  
  /** Jump if equal to zero. */
  public static final short JEQ = (short) 0x0400;
  
  /** Jump if not equal to zero. */
  public static final short JNE = (short) 0x0a00;
  
  /** Jump if less than zero. */
  public static final short JLT = (short) 0x0800;
  
  /** Jump if less than or equal to zero. */
  public static final short JLE = (short) 0x0c00;
  
  /** Jump if greater than zero (positive). */
  public static final short JGT = (short) 0x0200;
  
  /** Jump if greater than or equal to zero (not negative). */
  public static final short JGE = (short) 0x0600;
}

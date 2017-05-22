
package com.rath.syzasm.vals;

/**
 * This class contains constants for jump instructions.
 * 
 * @author Tim Backus tbackus127@gmail.com
 */
public class JumpInstr {

  public static final short JMP = (short) 0x0e00;
  public static final short JEQ = (short) 0x0400;
  public static final short JNE = (short) 0x0a00;
  public static final short JLT = (short) 0x0800;
  public static final short JLE = (short) 0x0c00;
  public static final short JGT = (short) 0x0200;
  public static final short JGE = (short) 0x0600;
}

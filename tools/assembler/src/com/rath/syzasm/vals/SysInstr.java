
package com.rath.syzasm.vals;

/**
 * This class contains constants associated with system instructions.
 * 
 * @author Tim Backus tbackus127@gmail.com
 */
public class SysInstr {
  
  /** Operation for stopping the CPU. */
  public static final short OP_HALT = (short) 0x0000;
  
  /** Operation for changing system flags. */
  public static final short OP_FLAG = (short) 0x0100;
}

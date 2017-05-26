
package com.rath.syzasm.vals;

/**
 * This class contains bitmask constants associated with system instructions.
 * 
 * @author Tim Backus tbackus127@gmail.com
 */
public class SysInstr {
  
  /** Operation for stopping the CPU. */
  public static final short OP_HALT = (short) 0x0000;
  
  /** Operation for changing system flags. */
  public static final short OP_FLAG = (short) 0x0100;
  
  /** Operation for changing the clock divider amount. */
  public static final short OP_CDIV = (short) 0x0200;
  
  /** Flag to enable Von-Neumann instruction execution mode. */
  public static final short FLAG_VNX = (short) 0x0000;
}

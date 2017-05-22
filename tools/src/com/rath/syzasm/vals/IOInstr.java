
package com.rath.syzasm.vals;

/**
 * This class contains bitmasks used for I/O instructions.
 * 
 * @author Tim Backus tbackus127@gmail.com
 */
public class IOInstr {

  /** Execute mode bitmask. */
  public static final short IOEX = (short) 0x0008;

  /** Write mode bitmask. */
  public static final short IOSR = (short) 0x0004;

  /** 32-bit mode bitmask. */
  public static final short IODW = (short) 0x0002;
}

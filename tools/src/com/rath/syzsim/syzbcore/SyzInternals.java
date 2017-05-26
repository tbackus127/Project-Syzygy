
package com.rath.syzsim.syzbcore;

/**
 * This class contains all values the CPU deals with.
 * 
 * @author Tim Backus tbackus127@gmail.com
 */
public class SyzInternals {
  
  /** The default execution delay. */
  private static final int DEFAULT_DELAY = 250;
  
  /** All 16 standard registers. */
  private final short[] regs;
  
  /** CPU memory. */
  private final short[] mem;
  
  /** Memory pointer. */
  private int memPtr;
  
  /** Execution delay, in milliseconds. */
  private int delay;
  
  /** Flag if the simulator is running. */
  private boolean isRunning;
  
  /**
   * Default constructor.
   */
  public SyzInternals() {
    this.regs = new short[16];
    this.mem = new short[65536];
    this.memPtr = 0;
    this.delay = 1000;
    this.isRunning = false;
  }
  
  /**
   * Executes an instruction.
   * 
   * @param instr the instruction to execute.
   */
  public void execute(final String instr) {
    
    System.out.println("Executing " + instr);
    
    // TODO: Execute
  }
  
  /**
   * Gets a register's value.
   * 
   * @param regNum the register to get the value of.
   * @return the register's value (16-bit).
   */
  public short getReg(final int regNum) {
    
    return regs[regNum];
  }
  
  /**
   * Sets a register's value.
   * 
   * @param regNum the register to set the value of.
   * @param val the value to set the register to.
   */
  public void setReg(final int regNum, final short val) {
    
    this.regs[regNum] = val;
  }
  
  /**
   * Gets the value at a memory address.
   * 
   * @param addr the memory address (0 - 65535, inclusive) to get.
   * @return the value at the memory address.
   */
  public short getMem(final int addr) {
    
    return mem[addr];
  }
  
  /**
   * Sets a memory address to a given value.
   * 
   * @param addr the memory address (0 - 65535, inclusive) to set.
   * @param val the value to set the address to.
   */
  public void setMem(final int addr, final short val) {
    
    this.mem[addr] = val;
  }
  
  /**
   * Gets the execution delay, in milliseconds.
   * 
   * @return the delay.
   */
  public int getDelay() {
    
    return delay;
  }
  
  /**
   * Sets the execution delay.
   * 
   * @param delay the new delay, in milliseconds.
   */
  public void setDelay(final int delay) {
    
    this.delay = delay;
  }
  
  /**
   * Tests if the simulator is running.
   * 
   * @return true if it is automatically executing instructions; false if not.
   */
  public boolean isRunning() {
    
    return isRunning;
  }
  
  /**
   * Sets the state of the running flag.
   * 
   * @param isRunning the new state to set the flag to.
   */
  public void setRunning(final boolean isRunning) {
    
    this.isRunning = isRunning;
  }
  
  /**
   * Resets all registers and memory values to zero.
   */
  public void resetEverything() {
    for (int i = 0; i < regs.length; i++) {
      this.regs[i] = 0;
    }
    for (int i = 0; i < mem.length; i++) {
      this.mem[i] = 0;
    }
    this.memPtr = 0;
    this.isRunning = false;
    this.delay = DEFAULT_DELAY;
  }
  
}

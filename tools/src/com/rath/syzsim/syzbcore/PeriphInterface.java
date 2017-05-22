package com.rath.syzsim.syzbcore;

/**
 * This class forms the foundation of peripheral interfaces.
 * 
 * @author Tim Backus tbackus127@gmail.com
 */
public abstract class PeriphInterface {

  /** Peripheral register values. */
  private final short[] regs;

  /**
   * Default constructor.
   */
  public PeriphInterface() {
    this.regs = new short[16];
  }

  /**
   * Gets the value of the specified register.
   * 
   * @param idx the register number (0-15) to get the value of.
   * @return the value as a short.
   */
  public final short getRegVal(final short idx) {

    return this.regs[idx];
  }

  /**
   * Sets the specified register to a certain value.
   * 
   * @param idx the register to set.
   * @param val the value to set the register to.
   */
  public final void setRegVal(final short idx, final short val) {

    this.regs[idx] = val;
  }

  /**
   * Executes an instruction in this peripheral's R0.
   */
  public abstract void execute();
}

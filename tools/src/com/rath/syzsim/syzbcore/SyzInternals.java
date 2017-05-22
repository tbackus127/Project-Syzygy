
package com.rath.syzsim.syzbcore;

/**
 * This class contains all values the CPU deals with.
 * 
 * @author Tim Backus tbackus127@gmail.com
 */
public class SyzInternals {

  private final short[] regs;
  private final short[] mem;

  private int memPtr;
  private int delay;
  private boolean isRunning;

  public SyzInternals() {
    this.regs = new short[16];
    this.mem = new short[65536];
    this.memPtr = 0;
    this.delay = 1000;
    this.isRunning = false;
  }

  public void execute(final String instr) {

    System.out.println("Executing " + instr);

    // TODO: Execute
  }

  public short getReg(final int regNum) {

    return regs[regNum];
  }

  public void setReg(final int regNum, final short val) {

    this.regs[regNum] = val;
  }

  public String getCurrInstr() {

    // TODO: Disassemble and return String
    return null;
  }

  public short getMem(final int addr) {

    return mem[addr];
  }

  public void setMem(final int addr, final short val) {

    this.mem[addr] = val;
  }

  public int getDelay() {

    return delay;
  }

  public void setDelay(final int delay) {

    this.delay = delay;
  }

  public boolean isRunning() {

    return isRunning;
  }

  public void setRunning(final boolean isRunning) {

    this.isRunning = isRunning;
  }

}


package com.rath.syzbbck;

public class SyzInternals {
  
  private final byte[] regs;
  private final byte[] aluRegs;
  private final byte[] instr;
  private final byte[] mem;
  
  private short currInstr;
  private short delay;
  private boolean isRunning;
  
  public SyzInternals() {
    this.regs = new byte[4];
    this.aluRegs = new byte[2];
    this.mem = new byte[256];
    this.instr = new byte[256];
    this.currInstr = 0;
    this.delay = 1000;
    this.isRunning = false;
  }
  
  public byte getReg(final byte i) {
    return regs[i];
  }
  
  public void setReg(final byte i, final byte n) {
    this.regs[i] = n;
  }
  
  public byte getAluReg(final int i) {
    return aluRegs[i];
  }
  
  public void setAluReg(final byte i, final byte n) {
    this.aluRegs[i] = n;
  }
  
  public byte getMem(final byte i) {
    return mem[i];
  }
  
  public void setMem(final byte i, final byte n) {
    this.mem[i] = n;
  }
  
  public byte getInstr(final byte i) {
    return instr[i];
  }
  
  public void setInstr(final byte i, final byte n) {
    this.instr[i] = n;
  }
  
  public short getCurrInstr() {
    return currInstr;
  }
  
  public void setCurrInstr(final short currInstr) {
    this.currInstr = currInstr;
  }
  
  public short getDelay() {
    return delay;
  }
  
  public void setDelay(final short delay) {
    this.delay = delay;
  }
  
  public boolean isRunning() {
    return isRunning;
  }
  
  public void setRunning(final boolean isRunning) {
    this.isRunning = isRunning;
  }
  
}

package com.rath.umbra.entity;

public class ForLoop extends ControlStructure {
  
  private final VarInitialization init;
  private final Expression cond;
  private final SetOperation setOp;
  private final List<Statement> body;
  
  public ForLoop(final VarInitialization vi, final Expression c, final SetOperation s, final List<Statement> b) {
    this.init = vi;
    this.cond = c;
    this.setOp = s;
    this.body = b;
  }
  
  public VarInitialization getInit() {
    return this.init;
  }
  
  public Expression getCond() {
    return this.cond;
  }
  
  public SetOperation getSetOp() {
    return this.setOp;
  }
  
  public List<Statement> getBody() {
    return this.body;
  }
  
}
package com.rath.umbra.entity;

public class BinaryOperation extends Operation {
  
  private final Operator op;
  private final Expression exa, exb;
  
  public BinaryOperation(final String p, final Expression ea, final Expression eb) {
    this.op = Operator.getOp(p);
    this.exa = ea;
    this.exb = eb;
  }
  
  public Operator getOp() {
    return this.op;
  }
  
  public Expression getExprA() {
    return this.exa;
  }
  
  public Expression getExprB() {
    return this.exb;
  }
}
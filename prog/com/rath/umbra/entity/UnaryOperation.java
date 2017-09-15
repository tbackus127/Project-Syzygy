package com.rath.umbra.entity;

public class UnaryOperation extends Operation {
  
  private final Operator op;
  private final Expression expr;
  
  public UnaryOperation(final String p, final Expression e) {
    this.op = Operator.getOp(p);
    this.expr = e;
  }
  
  public Operator getOp() {
    return this.op;
  }
  
  public Expression getExpr() {
    return this.expr;
  }
}
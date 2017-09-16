package com.rath.umbra.entity;

public class BinaryOperation extends Operation {
  
  private final UnaryOperation uOp;
  private final Operator op;
  private final Expression expr;
  
  public BinaryOperation(final UnaryOperation u, final String p, final Expression e) {
    this.op = Operator.getOp(p);
    this.uOp = u;
    this.expr = e;
  }
  
  public Operator getOp() {
    return this.op;
  }
  
  public UnaryOperation getHead() {
    return this.uOp;
  }
  
  public Expression getTail() {
    return this.expr;
  }
}
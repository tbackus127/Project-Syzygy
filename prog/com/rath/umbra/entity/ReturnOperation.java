package com.rath.umbra.entity;

public class ReturnOperation extends Operation {
  
  private final Expression expr;
  
  public ReturnOperation(final Expression e) {
    this.expr = e;
  }
  
  public Expression getExpr() {
    return this.expr;
  }
  
}
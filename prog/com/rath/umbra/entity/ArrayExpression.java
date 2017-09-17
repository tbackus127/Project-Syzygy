package com.rath.umbra.entity;

public class ArrayExpression extends Expression {

  private final String var;
  private final Expression index;

  public ArrayExpression(final String c, final Expression e) {
    this.var = c;
    this.index = e;
  }
  
  public String getVar() {
    return this.var;
  }
  
  public Expression getIndexExpr() {
    return this.index;
  }
}
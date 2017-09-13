package com.rath.umbra.entity;

public class SetOperation extends Operation {
  
  private final String var;
  private final Expression expr;
  
  public SetOperation(final String v, final Expression e) {
    this.var = v;
    this.expr = e;
  }
  
  public String getVar() {
    return this.var;
  }
  
  public Expression getExpr() {
    return this.expr;
  }
  
}
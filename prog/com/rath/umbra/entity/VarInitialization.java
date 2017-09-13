package com.rath.umbra.entity;

public class VarInitialization extends Operation {
  
  private final String var;
  private final Expression expr;
  
  public VarInitialization(final String v, final Expression e) {
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
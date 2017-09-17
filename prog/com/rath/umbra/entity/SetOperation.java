package com.rath.umbra.entity;

public class SetOperation extends Operation {
  
  private final VariableReference vr;
  private final Expression expr;

  public SetOperation(final VariableReference v, final Expression e) {
    this.vr = v;
    this.expr = e;
  }
  
  public VariableReference getVarRef() {
    return this.vr;
  }
  
  public Expression getExpr() {
    return this.expr;
  }
  
}
package com.rath.umbra.entity;

public class UnaryOperation extends Operation {
  
  private final Operator op;
  private final Expression expr;
  private final String var;
  private final int val;
  
  public UnaryOperation(final int n) {
    this.val = n;
    this.op = null;
    this.expr = null;
    this.var = null;
  }
  
  public UnaryOperation(final String v) {
    this.var = v;
    this.op = null;
    this.expr = null;
    this.val = -1;
  }
  
  public UnaryOperation(final String p, final Expression e) {
    this.op = Operator.getOp(p);
    this.expr = e;
    this.var = null;
    this.val = -1;
  }
  
  public int getVal() {
    return this.val;
  }
  
  public String getVar() {
    return this.var;
  }
  
  public Operator getOp() {
    return this.op;
  }
  
  public Expression getExpr() {
    return this.expr;
  }
}
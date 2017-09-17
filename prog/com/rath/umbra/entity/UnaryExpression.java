package com.rath.umbra.entity;

import java.util.List;

public class UnaryExpression extends Expression {

  final Expression ea;
  final List<Expression> arrExprs;
  final Operator op;
  final String cls;
  final String var;
  final int val;

  public UnaryExpression(final int n) {
    this.val = n;
    this.var = null;
    this.cls = null;
    this.ea = null;
    this.op = null;
    this.arrExprs = null;
  }
  
  public UnaryExpression(final String v) {
    this.val = -1;
    this.var = v;
    this.cls = null;
    this.ea = null;
    this.op = null;
    this.arrExprs = null;
  }
  
  public UnaryExpression(final String c, final String v) {
    this.val = -1;
    this.var = v;
    this.cls = c;
    this.ea = null;
    this.op = null;
    this.arrExprs = null;
  }
  
  public UnaryExpression(final String v, final List<Expression> e) {
    this.val = -1;
    this.cls = null;
    this.op = null;
    this.var = v;
    this.ea = null;
    this.arrExprs = e;
  }
  
  public UnaryExpression(final Operator p, final Expression ea) {
    this.val = -1;
    this.cls = null;
    this.op = p;
    this.var = null;
    this.ea = ea;
    this.arrExprs = null;
  }
  
  public String getConfigType() {
    return this.cls;
  }
  
  public int getVal() {
    return this.val;
  }
  
  public String getVar() {
    return this.var;
  }
  
  public Expression getExpr() {
    return this.ea;
  }
  
  public Operator getOp() {
    return this.op;
  }
  
  public List<Expression> getArrayRefExprs() {
    return this.arrExprs;
  }

}
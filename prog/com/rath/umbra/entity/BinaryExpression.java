package com.rath.umbra.entity;

public class BinaryExpression extends Expression {

  final Expression ea, eb;
  final Operator op;

  public BinaryExpression(final Expression ea, final String op, final Expression eb) {
    this.ea = ea;
    this.eb = eb;
    this.op = Operator.getOp(op);
  }
  
  public Expression getExprA() {
    return this.ea;
  }
  
  public Expression getExprB() {
    return this.eb;
  }
  
  public Operator getOp() {
    return this.op;
  }

}
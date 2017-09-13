package com.rath.umbra.entity;

public class WhileLoop extends ControlStructure {
  
  private final Expression expr;
  private final List<Statement> body;
  
  public WhileLoop(final Expression e, final List<Statement> b) {
    this.expr = e;
    this.body = b;
  }
  
  public Expression getExpr() {
    return this.expr;
  }
  
  public List<Statement> getBody() {
    return this.body;
  }
  
}
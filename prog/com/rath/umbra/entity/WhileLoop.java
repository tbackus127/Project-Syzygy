package com.rath.umbra.entity;

import java.util.List;

public class WhileLoop extends ControlStructure {
  
  private final Expression expr;
  private final StatementList body;
  
  public WhileLoop(final Expression e, final StatementList b) {
    this.expr = e;
    this.body = b;
  }
  
  public Expression getExpr() {
    return this.expr;
  }
  
  public StatementList getBody() {
    return this.body;
  }
  
}
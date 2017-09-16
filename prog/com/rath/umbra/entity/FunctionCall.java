package com.rath.umbra.entity;

import java.util.List;

public class FunctionCall extends Expression {
  
  private final String name;
  private final List<Expression> args;
  
  public FunctionCall(final String n, final List<Expression> a) {
    this.name = n;
    this.args = a;
  }
  
  public String getName() {
    return this.name;
  }
  
  public List<Expression> getArgs() {
    return this.args;
  }
}
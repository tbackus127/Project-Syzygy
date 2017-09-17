package com.rath.umbra.entity;

import java.util.List;

public class ArgList {
  
  private final List<Expression> args;
  
  public ArgList(final List<Expression> el) {
    this.args = el;
  }
  
  public List<Expression> getList() {
    return this.args;
  }
  
}
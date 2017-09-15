package com.rath.umbra.entity;

import java.util.List;

public class ValueList {
  
  private final List<String> args;
  
  public ValueList(final List<Expression> el) {
    this.args = el;
  }
  
  public List<String> getList() {
    return this.args;
  }
  
}
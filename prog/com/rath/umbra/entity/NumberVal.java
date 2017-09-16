package com.rath.umbra.entity;

public class NumberVal extends Expression {

  private final int val;
  
  public NumberVal(final String s) {
    this.val = (int) Short.decode(s);
  }
  
  public int getVal() {
    return this.val;
  }
  
}
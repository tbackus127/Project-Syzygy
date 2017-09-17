package com.rath.umbra.entity;

public class NumberVal extends UnaryExpression {

  public NumberVal(final String s) {
    super((int) Short.decode(s));
  }
  
}
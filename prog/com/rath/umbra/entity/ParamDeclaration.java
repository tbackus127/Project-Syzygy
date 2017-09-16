package com.rath.umbra.entity;

public class ParamDeclaration {
  
  private final String name;
  private final int value;
  
  public ParamDeclaration(final String n, final String v) {
    this.name = n;
    this.value = Integer.parseInt(v);
  }
  
  public String getName() {
    return this.name;
  }
  
  public int getValue() {
    return this.value;
  }
}
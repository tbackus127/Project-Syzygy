package com.rath.umbra.entity;

public class VarDeclaration extends Operation {
  
  private final String name;
  
  public VarDeclaration(final String n) {
    this.name = n;
  }
  
  public String getName() {
    return this.name;
  }
  
}
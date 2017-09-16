package com.rath.umbra.entity;

public class VariableReference extends Operation {
  
  private final String var;
  
  public VariableReference(final String v) {
    this.var = v;
  }
  
  public String getVar() {
    return this.var;
  }
  
}
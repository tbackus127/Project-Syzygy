package com.rath.umbra.entity;

import java.util.List;

public class FunctionDeclaration {
  
  private final String name;
  private final List<String> params;
  private final List<Statement> body;
  
  public FunctionDeclaration(final StatementList sl, final String n, final ParamList al) {
    this.body = sl.getList();
    this.params = al.getList();
    this.name = n;
  }
  
  public String getName() {
    return this.name;
  }
  
  public List<String> getParams() {
    return this.params;
  }
  
  public List<Statement> getBody() {
    return this.body;
  }
}
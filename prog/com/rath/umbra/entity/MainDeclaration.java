package com.rath.umbra.entity;

import java.util.List;

public class MainDeclaration {
  
  private final List<Statement> body;
  
  public MainDeclaration(final StatementList sl) {
    this.body = sl.getList();
  }
  
  public List<Statement> getBody() {
    return this.body;
  }
}
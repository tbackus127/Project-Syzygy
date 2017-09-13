package com.rath.umbra.entity;

import java.util.List;

public class StatementList {
  
  private final List<Statement> statements;
  
  public StatementList(final List<Statement> l) {
    this.statements = l;
  }
  
  public String getList() {
    return this.statements;
  }
  
}
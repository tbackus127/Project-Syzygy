package com.rath.umbra.entity;

import java.util.List;
import java.util.ArrayList;

public class ConditionalBranch extends ControlStructure {
  
  private final Expression ifExpr;
  private final List<Expression> elseifExprList;
  private final Expression elseExpr;
  
  private final List<Statement> ifBody;
  private final List<List<Statement>> elseifBodyList;
  private final List<Statement> elseBody;
  
  public ConditionalBranch(final Expression ie, final List<Expression> ee, final Expression le, final StatementList il, final List<StatementList> el, final StatementList ll) {
    this.ifExpr = ie;
    this.elseifExprList = ee;
    this.elseExpr = le;
    this.ifBody = il.getList();
    this.elseifBodyList = new ArrayList<List<Statement>>();
    for(StatementList sl : el) {
      this.elseifBodyList.add(sl.getList());
    }
    this.elseBody = ll.getList();
  }
  
  public Expression getIfExpr() {
    return this.ifExpr;
  }
  
  public List<Expression> getElseifExprList() {
    return this.elseIfExprList;
  }
  
  public Expression getElseExpr() {
    return this.elseExpr;
  }
  
  public List<Statement> getIfBody() {
    return this.ifBody;
  }
  
  public List<List<Statement>> getElseifBodyList() {
    return this.elseifBodyList;
  }
  
  public List<Statement> getElseBody() {
    return this.elseBody;
  }
  
}
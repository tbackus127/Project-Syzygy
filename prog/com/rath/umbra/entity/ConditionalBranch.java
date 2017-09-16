package com.rath.umbra.entity;

import java.util.List;
import java.util.ArrayList;

public class ConditionalBranch extends ControlStructure {
  
  private final Expression ifExpr;
  private final List<Expression> elseifExprList;
  private final Expression elseExpr;
  
  private final StatementList ifBody;
  private final List<StatementList> elseifBodyList;
  private final StatementList elseBody;
  
  public ConditionalBranch(final Expression ie, final List<Expression> ee, final Expression le, final StatementList il, final List<StatementList> el, final StatementList ll) {
    this.ifExpr = ie;
    this.elseifExprList = ee;
    this.elseExpr = le;
    this.ifBody = il;
    this.elseifBodyList = new ArrayList<StatementList>();
    for(StatementList sl : el) {
      this.elseifBodyList.add(sl);
    }
    this.elseBody = ll;
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
  
  public StatementList getIfBody() {
    return this.ifBody;
  }
  
  public List<StatementList> getElseifBodyList() {
    return this.elseifBodyList;
  }
  
  public StatementList getElseBody() {
    return this.elseBody;
  }
  
}
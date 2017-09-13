package com.rath.umbra.entity;

import java.util.List;

public class Program {
  
  private final List<ParamDeclaration> params;
  private final List<FunctionDeclaration> funcs;
  private final MainDeclaration mainDecl;
  
  public Program(final List<ParamDeclaration> p, final List<FunctionDeclaration> f, final MainDeclaration m) {
    this.params = p;
    this.funcs = f;
    this.mainDecl = m;
  }
  
  public final List<ParamDeclaration> getParams() {
    return this.params;
  }
  
  public final List<FunctionDeclaration> getFunction() {
    return this.funcs;
  }
  
  public final MainDeclaration getMain() {
    return this.mainDecl;
  }
}
package com.rath.umbra.obj;

public class Program {
  
  private final List<ParamDeclaration> paramDeclList;
  private final List<FunctionDeclaration funcDeclList;
  private final MainDeclaration mainDecl;
  
  public Program(final List<ParamDeclaration> pd, final List<FunctionDeclaration> fd, final MainDeclaration md) {
    this.paramDeclList = pd;
    this.funcDeclList = fd;
    this.mainDecl = md;
  }
  
  public List<ParamDeclaration> getParamDeclarations() {
    return this.paramDeclList;
  }
  
  public List<FunctionDeclaration> getFunctionDeclarations() {
    return this.funcDeclList;
  }
  
  public MainDeclaration getMainDeclaration() {
    return this.mainDecl;
  }
  
}
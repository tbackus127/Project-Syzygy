package com.rath.umbra.entity;

import java.util.List;

public class ArgList {
  
  private final List<String> args;
  
  public ArgList(final ArgListHead h, final List<ArgListTail> t) {
    if(h != null) {
      args.add(h.getName());
      for(ArgListTail tail : t) {
        if(tail != null) {
          args.add(tail.getName());
        }
      }
    }
  }
  
  public List<String> getList() {
    return this.args;
  }
  
}
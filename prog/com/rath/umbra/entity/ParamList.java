package com.rath.umbra.entity;

import java.util.List;
import java.util.ArrayList;

public class ParamList {
  
  private final List<String> params;
  
  public ParamList(final ParamListHead h, final List<ParamListTail> t) {
    params = new ArrayList<String>();
    if(h != null) {
      params.add(h.getName());
      for(ParamListTail tail : t) {
        if(tail != null) {
          params.add(tail.getName());
        }
      }
    }
  }
  
  public List<String> getList() {
    return this.params;
  }
  
}
package com.rath.umbra.entity;

import java.util.List;

public class VariableReference extends UnaryExpression {

  public VariableReference(final String v, final List<Expression> e) {
    super(v, e);
  }
}
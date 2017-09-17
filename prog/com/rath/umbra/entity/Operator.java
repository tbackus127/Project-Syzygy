package com.rath.umbra.entity;

public enum Operator {
  
  ADD, SUB, MULT, DIV, MOD, ASL, ASR, LTE, GTE, LSL, LSR, NOT,
  SEQ, NEQ, XOR, GT, LT, LEQ, CNT;
  
  public static Operator getOp(final String s) {
    switch(s) {
      case "<<<": return ASL;
      case ">>>": return ASR;
      case "<=": return LTE;
      case ">=": return GTE;
      case "<<": return LSL;
      case ">>": return LSR;
      case "==": return LEQ;
      case "!=": return NEQ;
      case "?": return CNT;
      case "!": return NOT;
      case "+": return ADD;
      case "-": return SUB;
      case "*": return MULT;
      case "=": return SEQ;
      case "/": return DIV;
      case "%": return MOD;
      case "^": return XOR;
      case ">": return GT;
      case "<": return LT;
      default: return null;
    }
  }
}
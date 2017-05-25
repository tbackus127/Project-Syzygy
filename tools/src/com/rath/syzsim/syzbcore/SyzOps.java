
package com.rath.syzsim.syzbcore;

/**
 * This class performes various ALU operations as the hardware itself would perform them.
 * 
 * @author Tim Backus tbackus127@gmail.com
 */
public class SyzOps {

  /**
   * Adds two bytes together. Does not check or prevent rollover.
   * 
   * @param a value A.
   * @param b value B.
   * @return A + B as a short.
   */
  public static final short add(final short a, final short b) {

    return (short) (a + b);
  }

  /**
   * Performs a bitwise negation on a short.
   * 
   * @param a the short to negate.
   * @return ~a as a short.
   */
  public static final short neg(final short a) {

    final int ta = (int) a | 0xffffff00;
    return (short) ~ta;
  }

  /**
   * Subtracts a short from another.
   * 
   * @param a the short to subtract from, A.
   * @param b the short that contains the quantity to be subtracted, B.
   * @return A - B as a short.
   */
  public static final short sub(final short a, final short b) {

    return add(a, add(neg(b), (short) 1));
  }

  /**
   * Performes a bitwise AND operation.
   * 
   * @param a short A.
   * @param b short B.
   * @return A & B as a short.
   */
  public static final short and(final short a, final short b) {

    return (short) (a & b);
  }

  /**
   * Gets a binary String representation of a short.
   * 
   * @param b the short to convert.
   * @return the binary String of b.
   */
  public static final String getBinaryString(final short b) {

    String result = "";
    for (short i = 7; i >= 0; i--) {
      result += (getBit(b, i)) ? "1" : "0";
    }
    return result;
  }

  /**
   * Gets the ith bit of a short b as a boolean.
   * 
   * @param b the short to isolate a bit from.
   * @param i the index of the short to isolate with 0 being the least significant bit and 7 being the most significant
   *          bit.
   * @return the ith bit of b as a boolean; 0 = false, 1 = true.
   */
  public static final boolean getBit(final short b, final int i) {

    if (i < 0 || i > 15) {
      throw new ArrayIndexOutOfBoundsException("Tried to isolate " + i + "th bit. Out of range.");
    }
    return ((b & ~(0xffffffff >> (i + 1) << (i + 1))) >> i) == 0 ? false : true;
  }

  /**
   * Gets a range of bits in a given byte as a byte.
   * 
   * @param b the byte to parse.
   * @param lsb the least-significant position.
   * @param msb the most-significant position.
   * @return the "sub-byte" of b from lsb to msb.
   */
  public static final short getBitRange(final short b, final int lsb, final int msb) {

    short result = 0;

    for (int i = lsb; i <= msb; i++) {
      result += (getBit(b, i)) ? 1 << i : 0;
    }

    return (short) (result >> lsb);
  }

  /**
   * Converts a number to its hexadecimal representation.
   * 
   * @param n the number to convert.
   * @return a zero-padded hexadecimal number as a String.
   */
  public static final String toHex(final int n) {

    String conv = Integer.toHexString(n).toUpperCase();
    for (int i = conv.length(); i < 4; i++) {
      conv = "0" + conv;
    }
    return conv;
  }
}

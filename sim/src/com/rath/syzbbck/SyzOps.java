
package com.rath.syzbbck;

/**
 * This class performes various ALU operations as the hardware itself would perform them.
 * 
 * @author Tim Backus tbackus127@gmail.com
 *
 */
public class SyzOps {
  
  /**
   * Adds two bytes together. Does not check or prevent rollover.
   * 
   * @param a byte A.
   * @param b byte B.
   * @return A + B as a byte.
   */
  public static final byte add(final byte a, final byte b) {
    return (byte) (a + b);
  }
  
  /**
   * Performs a bitwise negation on a byte.
   * 
   * @param a the byte to negate.
   * @return ~a as a byte.
   */
  public static final byte neg(final byte a) {
    final int ta = (int) a | 0xffffff00;
    return (byte) ~ta;
  }
  
  /**
   * Subtracts a byte from another.
   * 
   * @param a the byte to subtract from, A.
   * @param b the byte that contains the quantity to be subtracted, B.
   * @return A - B as a byte.
   */
  public static final byte sub(final byte a, final byte b) {
    return add(a, add(neg(b), (byte) 1));
  }
  
  /**
   * Performes a bitwise AND operation.
   * 
   * @param a byte A.
   * @param b byte B.
   * @return A & B as a byte.
   */
  public static final byte and(final byte a, final byte b) {
    return (byte) (a & b);
  }
  
  /**
   * Gets a binary String representation of a byte.
   * 
   * @param b the byte to convert.
   * @return the binary String of b.
   */
  public static final String getBinaryString(final byte b) {
    String result = "";
    for (byte i = 7; i >= 0; i--) {
      result += (getBit(b, i)) ? "1" : "0";
    }
    return result;
  }
  
  /**
   * Gets the ith bit of a byte b as a boolean.
   * 
   * @param b the byte to isolate a bit from.
   * @param i the index of the byte to isolate with 0 being the least significant bit and 7 being the most significant
   *        bit.
   * @return the ith bit of b as a boolean; 0 = false, 1 = true.
   */
  public static final boolean getBit(final byte b, final byte i) {
    if (i < 0 || i > 7) {
      throw new ArrayIndexOutOfBoundsException("Tried to isolate " + i + "th bit. Out of range.");
    }
    return ((b & ~(0xffffffff >> (i + 1) << (i + 1))) >> i) == 0 ? false : true;
  }
}

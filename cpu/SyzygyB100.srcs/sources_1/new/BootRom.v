`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/25/2017 01:58:13 PM
// Design Name: 
// Module Name: BootRom
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module BootRom(
    input readEn,
    input [7:0] addr,
    output [15:0] instrOut,
    output [15:0] debugOut
  );
  
  reg [15:0] instr = 16'h0000;
  
  always @ (addr) begin
    case(addr)
      
      // See os/boot/testSDMem.syz for the code that generated these machine instructions
      0: instr[15:0] = 16'h8000;
      1: instr[15:0] = 16'h1280;
      2: instr[15:0] = 16'h8001;
      3: instr[15:0] = 16'h1290;
      4: instr[15:0] = 16'h80ff;
      5: instr[15:0] = 16'h12a0;
      6: instr[15:0] = 16'h8008;
      7: instr[15:0] = 16'h1230;
      8: instr[15:0] = 16'h4310;
      9: instr[15:0] = 16'h1420;
      10: instr[15:0] = 16'h2a00;
      11: instr[15:0] = 16'h8001;
      12: instr[15:0] = 16'h1240;
      13: instr[15:0] = 16'h4304;
      14: instr[15:0] = 16'h8010;
      15: instr[15:0] = 16'h1240;
      16: instr[15:0] = 16'h4344;
      17: instr[15:0] = 16'h8000;
      18: instr[15:0] = 16'h1240;
      19: instr[15:0] = 16'h4324;
      20: instr[15:0] = 16'h4308;
      21: instr[15:0] = 16'h8002;
      22: instr[15:0] = 16'h1240;
      23: instr[15:0] = 16'h4304;
      24: instr[15:0] = 16'h8001;
      25: instr[15:0] = 16'h1240;
      26: instr[15:0] = 16'h4324;
      27: instr[15:0] = 16'h801f;
      28: instr[15:0] = 16'h1230;
      29: instr[15:0] = 16'h8007;
      30: instr[15:0] = 16'h1260;
      31: instr[15:0] = 16'h4310;
      32: instr[15:0] = 16'h1470;
      33: instr[15:0] = 16'h3248;
      34: instr[15:0] = 16'h2a00;
      35: instr[15:0] = 16'h4308;
      36: instr[15:0] = 16'h8041;
      37: instr[15:0] = 16'h1230;
      38: instr[15:0] = 16'h1a20;
      39: instr[15:0] = 16'h2400;
      40: instr[15:0] = 16'h1860;
      41: instr[15:0] = 16'h1970;
      42: instr[15:0] = 16'h3200;
      43: instr[15:0] = 16'h1290;
      44: instr[15:0] = 16'h1960;
      45: instr[15:0] = 16'h1870;
      46: instr[15:0] = 16'h3248;
      47: instr[15:0] = 16'h1280;
      48: instr[15:0] = 16'h1a60;
      49: instr[15:0] = 16'h3260;
      50: instr[15:0] = 16'h12a0;
      51: instr[15:0] = 16'h1940;
      52: instr[15:0] = 16'h4324;
      53: instr[15:0] = 16'h8039;
      54: instr[15:0] = 16'h1230;
      55: instr[15:0] = 16'h8007;
      56: instr[15:0] = 16'h1260;
      57: instr[15:0] = 16'h4310;
      58: instr[15:0] = 16'h1470;
      59: instr[15:0] = 16'h3248;
      60: instr[15:0] = 16'h2a00;
      61: instr[15:0] = 16'h4308;
      62: instr[15:0] = 16'h8024;
      63: instr[15:0] = 16'h1230;
      64: instr[15:0] = 16'h2e00;
      65: instr[15:0] = 16'h8043;
      66: instr[15:0] = 16'h1230;
      67: instr[15:0] = 16'h4310;
      68: instr[15:0] = 16'h1420;
      69: instr[15:0] = 16'h2a00;
      70: instr[15:0] = 16'h8011;
      71: instr[15:0] = 16'h1240;
      72: instr[15:0] = 16'h4344;
      73: instr[15:0] = 16'h8000;
      74: instr[15:0] = 16'h1240;
      75: instr[15:0] = 16'h4304;
      76: instr[15:0] = 16'h8040;
      77: instr[15:0] = 16'h1240;
      78: instr[15:0] = 16'h4244;
      79: instr[15:0] = 16'h8001;
      80: instr[15:0] = 16'h1240;
      81: instr[15:0] = 16'h4204;
      82: instr[15:0] = 16'h80fe;
      83: instr[15:0] = 16'h12a0;
      84: instr[15:0] = 16'h4308;
      85: instr[15:0] = 16'h8059;
      86: instr[15:0] = 16'h1230;
      87: instr[15:0] = 16'h8006;
      88: instr[15:0] = 16'h1260;
      89: instr[15:0] = 16'h4310;
      90: instr[15:0] = 16'h1470;
      91: instr[15:0] = 16'h3248;
      92: instr[15:0] = 16'h2a00;
      93: instr[15:0] = 16'h4330;
      94: instr[15:0] = 16'h4224;
      95: instr[15:0] = 16'h4208;
      96: instr[15:0] = 16'h8002;
      97: instr[15:0] = 16'h1240;
      98: instr[15:0] = 16'h4304;
      99: instr[15:0] = 16'h8079;
      100: instr[15:0] = 16'h1230;
      101: instr[15:0] = 16'h1a20;
      102: instr[15:0] = 16'h2400;
      103: instr[15:0] = 16'h4308;
      104: instr[15:0] = 16'h806c;
      105: instr[15:0] = 16'h1230;
      106: instr[15:0] = 16'h8006;
      107: instr[15:0] = 16'h1260;
      108: instr[15:0] = 16'h4310;
      109: instr[15:0] = 16'h1470;
      110: instr[15:0] = 16'h3248;
      111: instr[15:0] = 16'h2a00;
      112: instr[15:0] = 16'h4330;
      113: instr[15:0] = 16'h4224;
      114: instr[15:0] = 16'h4208;
      115: instr[15:0] = 16'h1a60;
      116: instr[15:0] = 16'h3260;
      117: instr[15:0] = 16'h12a0;
      118: instr[15:0] = 16'h8063;
      119: instr[15:0] = 16'h1230;
      120: instr[15:0] = 16'h2e00;
      121: instr[15:0] = 16'h4308;
      122: instr[15:0] = 16'h807c;
      123: instr[15:0] = 16'h1230;
      124: instr[15:0] = 16'h4310;
      125: instr[15:0] = 16'h1420;
      126: instr[15:0] = 16'h2a00;
      127: instr[15:0] = 16'h4330;
      128: instr[15:0] = 16'h4224;
      129: instr[15:0] = 16'h4208;
      130: instr[15:0] = 16'h8040;
      131: instr[15:0] = 16'h1230;
      132: instr[15:0] = 16'h0100;
      
      default: instr[15:0] = 16'h0000;
    endcase
  end
  
  assign instrOut[15:0] = (readEn) ? instr[15:0] : 16'h0000;
  assign debugOut[15:0] = instr[15:0];
  
endmodule

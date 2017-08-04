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
      4: instr[15:0] = 16'h80fe;
      5: instr[15:0] = 16'h12a0;
      6: instr[15:0] = 16'h8008;
      7: instr[15:0] = 16'h1230;
      8: instr[15:0] = 16'h4310;
      9: instr[15:0] = 16'h1460;
      10: instr[15:0] = 16'h3260;
      11: instr[15:0] = 16'h2a00;
      12: instr[15:0] = 16'h8001;
      13: instr[15:0] = 16'h1240;
      14: instr[15:0] = 16'h4304;
      15: instr[15:0] = 16'h8010;
      16: instr[15:0] = 16'h1240;
      17: instr[15:0] = 16'h4344;
      18: instr[15:0] = 16'h8000;
      19: instr[15:0] = 16'h1240;
      20: instr[15:0] = 16'h4324;
      21: instr[15:0] = 16'h4308;
      22: instr[15:0] = 16'h8002;
      23: instr[15:0] = 16'h1240;
      24: instr[15:0] = 16'h4304;
      25: instr[15:0] = 16'h8001;
      26: instr[15:0] = 16'h1240;
      27: instr[15:0] = 16'h4324;
      28: instr[15:0] = 16'h8020;
      29: instr[15:0] = 16'h1230;
      30: instr[15:0] = 16'h8007;
      31: instr[15:0] = 16'h1260;
      32: instr[15:0] = 16'h4310;
      33: instr[15:0] = 16'h1470;
      34: instr[15:0] = 16'h3248;
      35: instr[15:0] = 16'h2a00;
      36: instr[15:0] = 16'h4308;
      37: instr[15:0] = 16'h8042;
      38: instr[15:0] = 16'h1230;
      39: instr[15:0] = 16'h1a20;
      40: instr[15:0] = 16'h2400;
      41: instr[15:0] = 16'h1860;
      42: instr[15:0] = 16'h1970;
      43: instr[15:0] = 16'h3200;
      44: instr[15:0] = 16'h1290;
      45: instr[15:0] = 16'h1960;
      46: instr[15:0] = 16'h1870;
      47: instr[15:0] = 16'h3248;
      48: instr[15:0] = 16'h1280;
      49: instr[15:0] = 16'h1a60;
      50: instr[15:0] = 16'h3260;
      51: instr[15:0] = 16'h12a0;
      52: instr[15:0] = 16'h1940;
      53: instr[15:0] = 16'h4324;
      54: instr[15:0] = 16'h803a;
      55: instr[15:0] = 16'h1230;
      56: instr[15:0] = 16'h8007;
      57: instr[15:0] = 16'h1260;
      58: instr[15:0] = 16'h4310;
      59: instr[15:0] = 16'h1470;
      60: instr[15:0] = 16'h3248;
      61: instr[15:0] = 16'h2a00;
      62: instr[15:0] = 16'h4308;
      63: instr[15:0] = 16'h8025;
      64: instr[15:0] = 16'h1230;
      65: instr[15:0] = 16'h2e00;
      66: instr[15:0] = 16'h8044;
      67: instr[15:0] = 16'h1230;
      68: instr[15:0] = 16'h4310;
      69: instr[15:0] = 16'h1460;
      70: instr[15:0] = 16'h3260;
      71: instr[15:0] = 16'h2a00;
      72: instr[15:0] = 16'h8011;
      73: instr[15:0] = 16'h1240;
      74: instr[15:0] = 16'h4344;
      75: instr[15:0] = 16'h8000;
      76: instr[15:0] = 16'h1240;
      77: instr[15:0] = 16'h4304;
      78: instr[15:0] = 16'h8040;
      79: instr[15:0] = 16'h12b0;
      80: instr[15:0] = 16'h1b40;
      81: instr[15:0] = 16'h4244;
      82: instr[15:0] = 16'h8001;
      83: instr[15:0] = 16'h1240;
      84: instr[15:0] = 16'h4204;
      85: instr[15:0] = 16'h80fe;
      86: instr[15:0] = 16'h12a0;
      87: instr[15:0] = 16'h4308;
      88: instr[15:0] = 16'h805c;
      89: instr[15:0] = 16'h1230;
      90: instr[15:0] = 16'h8006;
      91: instr[15:0] = 16'h1260;
      92: instr[15:0] = 16'h4310;
      93: instr[15:0] = 16'h1470;
      94: instr[15:0] = 16'h3248;
      95: instr[15:0] = 16'h2a00;
      96: instr[15:0] = 16'h4330;
      97: instr[15:0] = 16'h4224;
      98: instr[15:0] = 16'h4208;
      99: instr[15:0] = 16'h1b60;
      100: instr[15:0] = 16'h3228;
      101: instr[15:0] = 16'h12b0;
      102: instr[15:0] = 16'h8002;
      103: instr[15:0] = 16'h1240;
      104: instr[15:0] = 16'h4304;
      105: instr[15:0] = 16'h8084;
      106: instr[15:0] = 16'h1230;
      107: instr[15:0] = 16'h1a20;
      108: instr[15:0] = 16'h2400;
      109: instr[15:0] = 16'h4308;
      110: instr[15:0] = 16'h1b40;
      111: instr[15:0] = 16'h4244;
      112: instr[15:0] = 16'h1b60;
      113: instr[15:0] = 16'h3228;
      114: instr[15:0] = 16'h12b0;
      115: instr[15:0] = 16'h8077;
      116: instr[15:0] = 16'h1230;
      117: instr[15:0] = 16'h8006;
      118: instr[15:0] = 16'h1260;
      119: instr[15:0] = 16'h4310;
      120: instr[15:0] = 16'h1470;
      121: instr[15:0] = 16'h3248;
      122: instr[15:0] = 16'h2a00;
      123: instr[15:0] = 16'h4330;
      124: instr[15:0] = 16'h4224;
      125: instr[15:0] = 16'h4208;
      126: instr[15:0] = 16'h1a60;
      127: instr[15:0] = 16'h3260;
      128: instr[15:0] = 16'h12a0;
      129: instr[15:0] = 16'h8069;
      130: instr[15:0] = 16'h1230;
      131: instr[15:0] = 16'h2e00;
      132: instr[15:0] = 16'h4308;
      133: instr[15:0] = 16'h1b40;
      134: instr[15:0] = 16'h4244;
      135: instr[15:0] = 16'h8089;
      136: instr[15:0] = 16'h1230;
      137: instr[15:0] = 16'h4310;
      138: instr[15:0] = 16'h1460;
      139: instr[15:0] = 16'h3248;
      140: instr[15:0] = 16'h2a00;
      141: instr[15:0] = 16'h4330;
      142: instr[15:0] = 16'h4224;
      143: instr[15:0] = 16'h4208;
      144: instr[15:0] = 16'h8040;
      145: instr[15:0] = 16'h1230;
      146: instr[15:0] = 16'h0100;
      default: instr[15:0] = 16'h0000;
    endcase
  end
  
  assign instrOut[15:0] = (readEn) ? instr[15:0] : 16'h0000;
  assign debugOut[15:0] = instr[15:0];
  
endmodule

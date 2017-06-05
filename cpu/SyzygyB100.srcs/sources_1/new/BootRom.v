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
    input en,
    input [5:0] addr,
    output reg [15:0] instrOut
  );
  
  always @ (en or addr) begin
    if(en) begin
      case(addr)
        0: instrOut[15:0] = 16'h8000;
        1: instrOut[15:0] = 16'h1260;
        2: instrOut[15:0] = 16'h3260;
        3: instrOut[15:0] = 16'h1240;
        4: instrOut[15:0] = 16'h801b;
        5: instrOut[15:0] = 16'h1230;
        6: instrOut[15:0] = 16'h1420;
        7: instrOut[15:0] = 16'h2400;
        8: instrOut[15:0] = 16'h8000;
        9: instrOut[15:0] = 16'h1260;
        10: instrOut[15:0] = 16'h3260;
        11: instrOut[15:0] = 16'h1260;
        12: instrOut[15:0] = 16'h8015;
        13: instrOut[15:0] = 16'h1230;
        14: instrOut[15:0] = 16'h1620;
        15: instrOut[15:0] = 16'h2400;
        16: instrOut[15:0] = 16'h3260;
        17: instrOut[15:0] = 16'h1260;
        18: instrOut[15:0] = 16'h800c;
        19: instrOut[15:0] = 16'h1230;
        20: instrOut[15:0] = 16'h2e00;
        21: instrOut[15:0] = 16'h1460;
        22: instrOut[15:0] = 16'h3260;
        23: instrOut[15:0] = 16'h1240;
        24: instrOut[15:0] = 16'h8004;
        25: instrOut[15:0] = 16'h1230;
        26: instrOut[15:0] = 16'h2e00;
        27: instrOut[15:0] = 16'h1860;
        28: instrOut[15:0] = 16'h3228;
        29: instrOut[15:0] = 16'h1280;
        30: instrOut[15:0] = 16'h8000;
        31: instrOut[15:0] = 16'h1230;
        32: instrOut[15:0] = 16'h2e00;
        default: instrOut[15:0] = 16'h0000;
      endcase
    end else begin
      instrOut[15:0] = 16'h0000;
    end
  end
  
endmodule

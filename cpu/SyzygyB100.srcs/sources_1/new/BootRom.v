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
    input [2:0] addr,
    output reg [15:0] instrOut
  );
  
  always @ (en or addr) begin
    if(en) begin
      case(addr)
        0: instrOut[15:0] = 16'h8007; // push 7
        1: instrOut[15:0] = 16'h1260; // copy 2, 6
        2: instrOut[15:0] = 16'h8006; // push 6
        3: instrOut[15:0] = 16'h1270; // copy 2, 7
        4: instrOut[15:0] = 16'h3200; // add
        5: instrOut[15:0] = 16'h1280; // copy 2, 8
        6: instrOut[15:0] = 16'h0000;
        7: instrOut[15:0] = 16'h0000;
      endcase
    end else begin
      instrOut[15:0] = 16'h0000;
    end
  end
  
endmodule

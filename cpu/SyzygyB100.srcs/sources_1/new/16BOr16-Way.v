`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/08/2017 08:32:10 PM
// Design Name: 
// Module Name: 16BOr16-Way
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

module Or16B16Way(
    input [15:0] dIn2,
    input [15:0] dIn3,
    input [15:0] dIn4,
    input [15:0] dIn5,
    input [15:0] dIn6,
    input [15:0] dIn7,
    input [15:0] dIn8,
    input [15:0] dIn9,
    input [15:0] dIn10,
    input [15:0] dIn11,
    input [15:0] dIn12,
    input [15:0] dIn13,
    input [15:0] dIn14,
    input [15:0] dIn15,
    output [15:0] dOut
  );
  
  // Or all 0th bits, 1st bits, etc... bits together so register inputs don't have
  //   multiple drivers
  genvar i;
  generate
  for (i = 0; i < 16; i = i + 1) begin : or16loop
  assign dOut[i] = dIn2[i] | dIn3[i] | dIn4[i] | dIn5[i] | dIn6[i] | dIn7[i] | dIn8[i] |
                   dIn9[i] | dIn10[i] | dIn11[i] | dIn12[i] | dIn13[i] | dIn14[i] | dIn15[i];
                   
  end                   
  endgenerate
  
endmodule

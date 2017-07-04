`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/03/2017 10:14:28 PM
// Design Name: 
// Module Name: Or32B5Way
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


module Or32B5Way(
    input [31:0] aIn,
    input [31:0] bIn,
    input [31:0] cIn,
    input [31:0] dIn,
    input [31:0] eIn,
    output [31:0] dOut
  );
  
  // Or all 0th bits, 1st bits, etc... bits together so register inputs don't have
  //   multiple drivers
  genvar i;
  generate
  for (i = 0; i < 32; i = i + 1) begin : or32loop
    assign dOut[i] = aIn[i] | bIn[i] | cIn[i] | dIn[i] | eIn[i];
  end
  endgenerate
  
endmodule

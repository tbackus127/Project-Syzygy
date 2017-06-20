`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/20/2017 01:01:43 AM
// Design Name: 
// Module Name: Or32B4Way
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


module Or32B4Way(
    input [31:0] aIn,
    input [31:0] bIn,
    input [31:0] cIn,
    input [31:0] dIn,
    output [31:0] dOut
  );
  
  // Or all 0th bits, 1st bits, etc... bits together so register inputs don't have
  //   multiple drivers
  genvar i;
  generate
  for (i = 0; i < 32; i = i + 1) begin : or32loop
    assign dOut[i] = aIn[i] | bIn[i] | cIn[i] | dIn[i];          
  end                   
  endgenerate
  
endmodule

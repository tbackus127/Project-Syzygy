`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/20/2017 09:32:12 PM
// Design Name: 
// Module Name: Dmx2to4
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


module Dmx2to4(
    input [1:0] sel,
    input en,
    output [3:0] out
  );
  
  assign out[3:0] = (en) ? (1 << sel[1:0]) : 4'h0;
  
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2017 07:31:04 PM
// Design Name: 
// Module Name: Dmx4to16
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


module Dmx4to16(
    input [3:0] sel,
    input en,
    output [15:0] out
  );
  
  assign out[15:0] = (en) ? (1 << sel[3:0]) : 16'h0000;
  
endmodule

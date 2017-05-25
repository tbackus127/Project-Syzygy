`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2017 06:25:07 PM
// Design Name: 
// Module Name: Register
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

// Falling-Edge-Triggered register with async reset and set
module SyzFETRegister(
    input [15:0] dIn,
    input clk,
    input read,
    input write,
    input asyncReset,
    output [15:0] dOut,
    output [15:0] dOut2
  );

  reg [15:0] data;

  always @ (posedge asyncReset or negedge clk) begin
    if(asyncReset) data[15:0] <= 16'b0000000000000000;
    else if(write) data[15:0] <= dIn[15:0];
  end
  
  assign dOut[15:0] = data[15:0] & {15{read}};
  assign dOut2[15:0] = data[15:0] & {15{read}};
  
endmodule

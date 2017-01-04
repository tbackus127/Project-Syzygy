`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/03/2017 05:55:43 PM
// Design Name: 
// Module Name: InstructionReg
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


module InstructionReg(
    input clk,
    input [7:0] address,
    input [15:0] data_in,
    output [15:0] data_out
  );
    
  reg [15:0] mem [0:255];
  
  always @ (posedge clk) begin
    mem[address] = data_in;
  end
  
  assign data_out[15:0] = mem[address];
  
endmodule

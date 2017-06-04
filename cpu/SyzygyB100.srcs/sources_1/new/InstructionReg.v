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
    input [3:0] addr,
    input [15:0] dIn,
    output [15:0] dOut
  );
    
  reg [15:0] mem [0:15];
  
  always @ (posedge clk) begin
    mem[addr] = dIn;
  end
  
  assign dOut[15:0] = mem[addr];
  
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2017 08:44:29 PM
// Design Name: 
// Module Name: ShiftRegister
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


module ShiftRegister(
    input clk,
    input res,
    input serialIn,
    output reg [15:0] valOut
  );
  
  always @ (posedge res or negedge clk) begin
    if(res) begin
      valOut[15:0] <= 16'h0000;
    end else begin
      valOut[15:0] <= (valOut[15:0] << 1) + serialIn;    
    end
  end
  
endmodule

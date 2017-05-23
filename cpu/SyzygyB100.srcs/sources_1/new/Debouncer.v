`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/03/2017 11:59:05 PM
// Design Name: 
// Module Name: Debouncer
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


module Debouncer(
    input clock,
    input in,
    output out
  );
  
  // 10ms at 300MHz
  parameter LIMIT = 3000000;
  
  reg [22:0] count = 0;
  reg state = 1'b0;
  
  always @ (posedge clock) begin
    if(in != state && count < LIMIT)
      count <= count + 1;
    else if (count == LIMIT) begin
      state <= in;
      count <= 0;
    end
    else
      count <= 0;
  end
    
  assign out = state;
  
endmodule

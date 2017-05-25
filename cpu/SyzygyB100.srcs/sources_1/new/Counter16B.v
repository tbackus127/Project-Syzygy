`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/25/2017 12:47:38 PM
// Design Name: 
// Module Name: Counter16B
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


module Counter16B(
    input clk,
    input en,
    input res,
    input [15:0] valIn,
    input set,
    output reg [15:0] valOut
  );
  
  always @ (posedge clk) begin
    
    // Count up
    if(en) valOut = valOut + 1;
    
  end
  
  always @ (set or res) begin
    
    // Zero if reset (async)
    if(res) valOut = 16'b0000000000000000;
    
    // Set value (jump, async)
    else if(set) valOut[15:0] = valIn[15:0];
  
  end
  
endmodule

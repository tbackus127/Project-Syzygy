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
    input clockSig,
    input en,
    input [15:0] valIn,
    input set,
    output [15:0] valOut,
    output [15:0] debugOut
  );
  
  reg [15:0] count;
  
  always @ (negedge clockSig) begin
    if (set) count = valIn[15:0];
    else if (en) count = count + 1;
  end
  
  assign debugOut[15:0] = count[15:0];
  assign valOut[15:0] = count[15:0];
  
endmodule

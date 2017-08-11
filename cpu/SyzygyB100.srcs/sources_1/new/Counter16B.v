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
    input res,
    output [15:0] valOut,
    output [15:0] debugOut
  );
  
  reg [15:0] count = 16'h0000;
  
  // Delay set and data lines to prevent reading from next number before register
  //   is set
  wire wSetBuf;
  buf #(1) (wSetBuf, set);
  
  wire [15:0] wBuf;
  Buffer16B buf0 (
    .dIn(valIn[15:0]),
    .dOut(wBuf[15:0])
  );
  
  always @ (negedge clockSig) begin
    if(res) count[15:0] <= 16'h0000;
    else if(wSetBuf) count[15:0] <= wBuf[15:0];
    else if (en) count[15:0] <= count[15:0] + 1'b1;
  end
  
  assign debugOut[15:0] = count[15:0];
  assign valOut[15:0] = count[15:0];
  
endmodule

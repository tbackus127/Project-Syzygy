`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2017 12:49:49 AM
// Design Name: 
// Module Name: SyzFETAccumulator
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
module SyzFETAccumulator(
    input [15:0] dIn,
    input clockSig,
    input read,
    input write,
    input asyncReset,
    output [15:0] dOut,
    output [15:0] dOut2,
    output [15:0] debugOut
  );

  reg [15:0] data;
  wire [15:0] wOutput;
  
  wire [15:0] wBuf;
  Buffer16B buf0 (
    .dIn(dIn[15:0]),
    .dOut(wBuf[15:0])
  );
  
  // Reset on rising reset signal, set data on falling clock signal
  always @ (posedge asyncReset or negedge clockSig) begin
    if(asyncReset) begin
      data[15:0] <= 16'h0000;
    end else begin
      if(write) begin
        data[15:0] <= wBuf[15:0];
      end
    end
  end
  
  // Always output for the comparator input
  assign dOut2[15:0] = data[15:0];
  
  // Only output if we get the read signal
  assign wOutput[15:0] = (read) ? data[15:0] : 16'hZZZZ;
  
  // Clone the output to the standard output and the debug output
  assign dOut[15:0] = wOutput[15:0];
  assign debugOut[15:0] = wOutput[15:0];
  
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/08/2017 09:06:58 PM
// Design Name: 
// Module Name: SyzFETRegister2Out
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
module SyzFETRegister2Out(
    input [15:0] dIn,
    input clockSig,
    input read,
    input write,
    input asyncReset,
    output [15:0] dOut,
    output [15:0] debugOut
  );

  reg [15:0] data;
  wire [15:0] wOutput;
  
  wire [15:0] wBuf;
  Buffer16B buf0 (
    .dIn(dIn[15:0]),
    .dOut(wBuf[15:0])
  );
  
  // Have a way to see the register's value
  assign debugOut[15:0] = data[15:0];
  
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
  
  // Only output if we get the read signal
  assign wOutput[15:0] = (read) ? data[15:0] : 16'h0000;
  
  // Clone the output to two standard outputs and one debug output
  assign dOut[15:0] = wOutput[15:0];
  
  
endmodule


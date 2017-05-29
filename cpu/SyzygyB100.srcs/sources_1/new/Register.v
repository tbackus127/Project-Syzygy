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

  // Reset on rising reset signal, set data on falling clock signal
  always @ (posedge asyncReset or negedge clockSig) begin
    if(asyncReset) begin
      data[15:0] <= 16'h0000;
    end else begin
      if(write) begin
        data[15:0] <= dIn[15:0];
      end
    end
  end
  
  // Only output if we get the read signal
  assign wOutput[15:0] = (read) ? data[15:0] : 16'hZZZZ;
  
  // Clone the output to two standard outputs and one debug output
  assign dOut[15:0] = wOutput[15:0];
  assign dOut2[15:0] = wOutput[15:0];
  assign debugOut[15:0] = wOutput[15:0];
  
endmodule

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
module SyzFETRegister3Out (
    input [15:0] dIn,
    input clockSig,
    input read,
    input write,
    input reset,
    output [15:0] dOut,
    output [15:0] dOut2,
    output [15:0] debugOut
  );

  reg [15:0] data = 16'h0000;
  wire [15:0] wOutput;
  
  // Output for other component inputs (always enabled)
  assign dOut2[15:0] = data[15:0];
  
  // Debug output (always enabled)
  assign debugOut[15:0] = data[15:0];
  
  // Delay buffer
  wire [15:0] wBuf;
  Buffer16B buf0 (
    .dIn(dIn[15:0]),
    .dOut(wBuf[15:0])
  );
  
  // Reset on rising reset signal, set data on falling clock signal
  always @ (negedge clockSig) begin
    if(reset) begin
      data[15:0] <= 16'h0000;
    end else begin
      if(write) begin
        data[15:0] <= wBuf[15:0];
      end
    end
  end
  
  // Only output if we get the read signal
  assign wOutput[15:0] = (read) ? data[15:0] : 16'h0000;
  
  // Output connection
  assign dOut[15:0] = wOutput[15:0];
  
  
endmodule

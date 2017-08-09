`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/12/2017 08:09:12 PM
// Design Name: 
// Module Name: SyzFETFlagReg
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


module SyzFETFlagReg(
    input clockSig,
    input value,
    input [3:0] sel,
    input write,
    input asyncReset,
    output [15:0] dOut
  );
  
  reg data [15:0];
  
  // Delay buffer
  wire wBuf;
  buf #(1) (wBuf, value);
  
  // Reset on rising reset signal, set data on falling clock signal
  always @ (negedge clockSig) begin
    if(write) begin
      data[sel] = wBuf;
    end
  end
  
  // Concatenate all data signals to one 16-bit value for output signals
  assign dOut[15:0] = {
    data[0], data[1], data[2], data[3],
    data[4], data[5], data[6], data[7],
    data[8], data[9], data[10], data[11],
    data[12], data[13], data[14], data[15]
  };
  
endmodule

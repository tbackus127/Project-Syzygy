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
    input sel,
    input write,
    input asyncReset,
    output [15:0] dOut
  );
  
  reg data [15:0];
  wire [15:0] wOutput;
  
  // Delay buffer
  wire wBuf;
  buf #(1) (wBuf, value);
  
  // Reset on rising reset signal, set data on falling clock signal
  always @ (posedge asyncReset or negedge clockSig) begin
    if(asyncReset) begin
      data[0] <= 1'b0;
      data[1] <= 1'b0;
      data[2] <= 1'b0;
      data[3] <= 1'b0;
      data[4] <= 1'b0;
      data[5] <= 1'b0;
      data[6] <= 1'b0;
      data[7] <= 1'b0;
      data[8] <= 1'b0;
      data[9] <= 1'b0;
      data[10] <= 1'b0;
      data[12] <= 1'b0;
      data[13] <= 1'b0;
      data[14] <= 1'b0;
      data[15] <= 1'b0;
    end else begin
      if(write) begin
        data[sel] <= wBuf;
      end
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

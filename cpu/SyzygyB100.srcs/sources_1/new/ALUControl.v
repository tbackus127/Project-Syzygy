`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/22/2017 07:49:10 PM
// Design Name: 
// Module Name: ALUControl
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


module ALUControl(
    input [15:0] sw,
    input btnL,
    input btnR,
    input btnC,
    input clk,
    output [15:0] led,
    output [6:0] seg,
    output [3:0] an
  );
  
  reg [15:0] regA;
  reg [15:0] regB;
  reg [15:0] regOp;
  
  wire buttonLeft;
  wire buttonRight;
  wire buttonCenter;
  
  // Button flags (only activate once; not reset until released)
  reg buttonLPressed = 1'b0;
  reg buttonCPressed = 1'b0;
  reg buttonRPressed = 1'b0;
  
  always @ (posedge clk) begin
      
    // Reset button flags
    if(buttonLeft == 1'b0)
      buttonLPressed <= 1'b0;
    if(buttonCenter == 1'b0)
      buttonCPressed <= 1'b0;
    if(buttonRight == 1'b0)
      buttonRPressed <= 1'b0;
    
    // Left button -- Decrement memory pointer  
    if(buttonLPressed == 1'b0 & buttonLeft == 1'b1) begin
      regA [15:0] <= sw[15:0];
      buttonLPressed <= 1'b1;
    end
    
    // Center button -- Set memory at <pointer> to switches' value
    else if(buttonCPressed == 1'b0 & buttonCenter == 1'b1) begin
      regOp [15:0] <= sw[15:0];
      buttonCPressed <= 1'b1;
    end
    
    // Right button -- Increment memory pointer
    else if(buttonRPressed == 1'b0 & buttonRight == 1'b1) begin
      regB [15:0] <= sw[15:0];
      buttonRPressed <= 1'b1;
    end
  end
  
  // ALU connections
  wire[15:0] aluOut;
  ALU alu(
    .aIn(regA[15:0]),
    .bIn(regB[15:0]),
    .op(regOp[10:8]),
    .negA(regOp[7]),
    .negB(regOp[6]),
    .zeroB(regOp[5]),
    .negQ(regOp[4]),
    .arg(regOp[3]),
    .arth(regOp[2]),
    .rot(regOp[1]),
    .aluOut(aluOut[15:0])
  );
  
  // Button debouncers
  Debouncer dbL(
    .clock(clk),
    .in(btnL),
    .out(buttonLeft)  
  );
  Debouncer dbC(
    .clock(clk),
    .in(btnC),
    .out(buttonCenter)  
  );
  Debouncer dbR(
    .clock(clk),
    .in(btnR),
    .out(buttonRight)  
  );
  
  // 7-Segment display decoder
  SevSeg ss(
    .clk(clk),
    .valIn(aluOut[15:0]),
    .segs(seg[6:0]),
    .anodes(an[3:0]),
    .dp(dp)
  );
  
  assign led[15:0] = sw[15:0];
  
endmodule

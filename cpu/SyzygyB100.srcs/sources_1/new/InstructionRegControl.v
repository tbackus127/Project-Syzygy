`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/03/2017 06:21:40 PM
// Design Name: 
// Module Name: InstructionRegControl
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


module InstructionRegControl(
    input clk,
    input [15:0] sw,
    input btnL,
    input btnC,
    input btnR,
    
    output [6:0] seg,
    output [3:0] an,
    output [15:0] led,
    output dp
  );
  
  // Debounced button traces
  wire button_left;
  wire button_center;
  wire button_right;
  
  // Button flags (only activate once; not reset until released)
  reg buttonLPressed = 1'b0;
  reg buttonCPressed = 1'b0;
  reg buttonRPressed = 1'b0;
  
  // Memory pointer
  reg [15:0] currAddr = 8'b00000000;
  
  always @ (posedge clk) begin
    
    // Reset button flags
    if(button_left == 1'b0)
      buttonLPressed <= 1'b0;
    if(button_center == 1'b0)
      buttonCPressed <= 1'b0;
    if(button_right == 1'b0)
      buttonRPressed <= 1'b0;
    
    // Left button -- Decrement memory pointer  
    if(buttonLPressed == 1'b0 & button_left == 1'b1) begin
      currAddr <= currAddr - 1;
      buttonLPressed <= 1'b1;
    end
    
    // Center button -- Set memory at <pointer> to switches' value
    else if(buttonCPressed == 1'b0 & button_center == 1'b1) begin
      buttonCPressed <= 1'b1;
    end
    
    // Right button -- Increment memory pointer
    else if(buttonRPressed == 1'b0 & button_right == 1'b1) begin
      currAddr <= currAddr + 1;
      buttonRPressed <= 1'b1;
    end
  end
  
  InstructionReg instrReg(
    .clk(buttonCPressed),
    .address(currAddr[7:0]),
    .data_in(sw[15:0]),
    .data_out(led[15:0])
  );

  SevSeg sevSeg(
    .clk(clk),
    .valIn(currAddr[15:0]),
    .segs(seg[6:0]),
    .anodes(an[3:0]),
    .dp(dp)
  );
  
  Debouncer dbL(
    .clock(clk),
    .in(btnL),
    .out(button_left)  
  );
  
  Debouncer dbC(
    .clock(clk),
    .in(btnC),
    .out(button_center)  
  );
  
  Debouncer dbR(
    .clock(clk),
    .in(btnR),
    .out(button_right)  
  );
  
endmodule

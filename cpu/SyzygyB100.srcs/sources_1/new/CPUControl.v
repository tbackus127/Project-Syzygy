`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2017 05:28:05 PM
// Design Name: 
// Module Name: CPUControl
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


module CPUControl(
    input clk,
    input [15:0] sw,
    input btnL,
    input btnC,
    input btnR,
    output [15:0] led,
    output [6:0] seg,
    output [3:0] an,
    output dp
  );
  
  // Main CPU connections
  reg [15:0] regInstrIn;
  wire [15:0] cpuOut;
  SyzygyB100 cpu(
    .clk(clk),
    .instrIn(regInstrIn[15:0]),
    .dOut(cpuOut[15:0])
  );
  
  // 7-segment display connections
  reg [15:0] regSSDisp;
  SevSeg ss(
    .clk(clk),
    .valIn(regSSDisp[15:0]),
    .segs(seg[6:0]),
    .anodes(an[3:0]),
    .dp(dp)
  );
  
  // Left button connections
  wire buttonLeft;
  Debouncer dbL(
    .clk(clk),
    .in(btnL),
    .out(buttonLeft)
  );
  
  // Center button connections
  wire buttonCenter;
  Debouncer dbC(
    .clk(clk),
    .in(btnC),
    .out(buttonCenter)
  );
  
  // Right button connections
  wire buttonRight;
  Debouncer dbR(
    .clk(clk),
    .in(btnR),
    .out(buttonRight)
  );
  
  // Button flags (only activate once; not reset until released)
  reg buttonLPressed = 1'b0;
  reg buttonCPressed = 1'b0;
  reg buttonRPressed = 1'b0;
  
  // Button behavior
  always @ (posedge clk) begin
      
    // Reset button flags
    if(buttonLeft == 1'b0)
      buttonLPressed <= 1'b0;
    if(buttonCenter == 1'b0)
      buttonCPressed <= 1'b0;
    if(buttonRight == 1'b0)
      buttonRPressed <= 1'b0;
    
    // Left button -- BEHAVIOR DESCRIPTION HERE 
    if(buttonLPressed == 1'b0 & buttonLeft == 1'b1) begin
      
      // DO STUFF HERE
      
      buttonLPressed <= 1'b1;
    end
    
    // Center button -- BEHAVIOR DESCRIPTION HERE
    else if(buttonCPressed == 1'b0 & buttonCenter == 1'b1) begin
      
      // DO STUFF HERE
          
      buttonCPressed <= 1'b1;
    end
    
    // Right button -- BEHAVIOR DESCRIPTION HERE
    else if(buttonRPressed == 1'b0 & buttonRight == 1'b1) begin
      
      // DO STUFF HERE
          
      buttonRPressed <= 1'b1;
    end
  end
  
endmodule

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
  
  // Debounced button connections
  wire buttonLeft;
  wire buttonCenter;
  wire buttonRight;
  
  // CPU connection
  wire [15:0] wCpuOut;
  wire [15:0] wCpuOut2;
  SyzygyB100 cpu(
    .clockSig(clk),
    .en(sw[15]),
    .res(buttonCenter),
    .extInstrIn(),
    .extRegSel(sw[4:1]),
    .extDOut(wCpuOut[15:0]),
    .extDOut2(wCpuOut2[15:0]),
    .extPerDOut(),
    .extPerSel(),
    .extPerReg(),
    .extPerModeAcc(),
    .extPerModeExec(),
    .extPerMode32()
  );
  assign led[15:0] = wCpuOut[15:0];
  
  // 7-segment display connections
  SevSeg ss(
    .clk(clk),
    .valIn(wCpuOut2[15:0]),
    .segs(seg[6:0]),
    .anodes(an[3:0]),
    .dp(dp)
  );
  
  // Left button connections
  Debouncer dbL(
    .clk(clk),
    .in(btnL),
    .out(buttonLeft)
  );
  
  // Center button connections
  Debouncer dbC(
    .clk(clk),
    .in(btnC),
    .out(buttonCenter)
  );
  
  // Right button connections
  Debouncer dbR(
    .clk(clk),
    .in(btnR),
    .out(buttonRight)
  );
  
  // Button flags (only activate once; not reset until released)
  reg buttonLPressed = 1'b0;
  reg buttonRPressed = 1'b0;
  
  // Button behavior
  always @ (posedge clk) begin
      
    // Reset button flags
    if(buttonLeft == 1'b0)
      buttonLPressed <= 1'b0;
    if(buttonRight == 1'b0)
      buttonRPressed <= 1'b0;
    
    // Left button -- Sets the current instruction to switch value 
    if(buttonLPressed == 1'b0 & buttonLeft == 1'b1) begin
      
      // DO STUFF HERE
      
      buttonLPressed <= 1'b1;
    end
    
    // Right button -- BEHAVIOR DESCRIPTION HERE
    else if(buttonRPressed == 1'b0 & buttonRight == 1'b1) begin
      
      // DO STUFF HERE
          
      buttonRPressed <= 1'b1;
    end
  end
  
endmodule

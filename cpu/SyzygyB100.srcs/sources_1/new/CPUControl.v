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
    input btnU,
    input btnD,
    output [15:0] led,
    output [6:0] seg,
    output [3:0] an,
    output dp
  );
  
  // This makes me sad. Switch 14 is shorted with switch 13's value...
  // Good thing my opcodes don't care.
  wire [15:0] deshortedSwitch;
  assign deshortedSwitch[15:0] = {sw[15], 1'b0, sw[13:0]};
  
  // Debounced button connections
  wire buttonLeft;    // Clock step
  wire buttonCenter;  // Write instruction
  wire buttonUp;      // Set snoop register
  wire buttonDown;    // Reset everything
  
  // Whether each button is pressed
  reg buttonLPressed = 1'b0;
  reg buttonCPressed = 1'b0;
  reg buttonUPressed = 1'b0;
  reg buttonDPressed = 1'b0;
  
  // Current clock state
  reg clkState;
  
  // Data snoop select register
  reg [3:0] regSel;
  
  // Current instruction
  reg [15:0] regInstr;
  
  // CPU connection
  wire [15:0] wCPUPCOut;
  wire [15:0] wCpuRegOut;
  SyzygyB100 cpu(
    .clockSig(clkState),
    .en(1'b1),
    .res(buttonDPressed),
    .extInstrIn(regInstr[15:0]),
    .extRegSel(regSel[3:0]),
    .extDOut(wCPUPCOut[15:0]),
    .extDOut2(wCpuRegOut[15:0]),
    .extPerDOut(),
    .extPerSel(),
    .extPerReg(),
    .extPerModeAcc(),
    .extPerModeExec(),
    .extPerMode32()
  );
  assign led[15:0] = sw[15:0];
  
  // 7-segment display connections
  SevSeg ss(
    .clk(clk),
    .valIn(wCpuRegOut[15:0]),
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
  
  // Up button connections
  Debouncer dbU(
    .clk(clk),
    .in(btnU),
    .out(buttonUp)
  );
  
  // Down button connections
  Debouncer dbD(
    .clk(clk),
    .in(btnD),
    .out(buttonDown)
  );
  
  always @ (posedge clk) begin
    
    if(buttonLeft == 1'b0) buttonLPressed <= 1'b0;
    if(buttonCenter == 1'b0) buttonCPressed <= 1'b0;
    if(buttonUp == 1'b0) buttonUPressed <= 1'b0;
    if(buttonDown == 1'b0) buttonDPressed <= 1'b0;
    
    // Manual clock (Toggled on rising-edge)
    if(buttonLPressed == 1'b0 & buttonLeft == 1'b1) begin
      if(clkState == 1'b1) begin
        clkState <= 1'b0;
      end else begin
        clkState <= 1'b1;
      end
      buttonLPressed <= 1'b1;
    end
    
    // Write instruction to instruction register
    if(buttonCPressed == 1'b0 & buttonCenter == 1'b1) begin
      regInstr[15:0] <= deshortedSwitch[15:0];
      buttonCPressed <= 1'b1;
    end
    else begin
      buttonCPressed <= 1'b0;
    end
    
    // Set snoop register
    if(buttonUPressed == 1'b0 & buttonUp == 1'b1) begin
      regSel[3:0] <= sw[3:0];
      buttonUPressed <= 1'b1;
    end
    else begin
      buttonUPressed <= 1'b0;
    end
    
    // Reset everything
    if(buttonDPressed == 1'b0 & buttonDown == 1'b1) begin
      buttonDPressed <= 1'b1;
    end
    else begin
      buttonDPressed <= 1'b0;
    end
    
  end
  
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/13/2017 08:25:50 PM
// Design Name: 
// Module Name: InputNormalizer
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


module InputNormalizer(
    input clk,
    input [15:0] switchIn,
    input btnLIn,
    input btnUIn,
    input btnCIn,
    input btnDIn,
    input btnRIn,
    input [15:0] segsIn,
    output [15:0] switchOut,
    output btnLOut,
    output btnUOut,
    output btnCOut,
    output btnDOut,
    output btnROut,
    output [6:0] segsOut,
    output [3:0] anOut,
    output dpOut
  );
  
  // This makes me sad. Switch 14 is shorted with switch 13's value...
  // Good thing my opcodes don't care.
  wire [15:0] deshortedSwitch;
  assign switchOut[15:0] = {switchIn[15], 1'b0, switchIn[13:0]};
  
  // Debounced button connections
  wire buttonLeft;    // Clock step
  wire buttonRight;   // Toggle RAM-Fetch (or external debugging) Mode
  wire buttonCenter;  // Write instruction
  wire buttonUp;      // Set snoop register
  wire buttonDown;    // Reset everything
  
  // Holds each button's state
  reg buttonLPressed = 1'b0;
  reg buttonRPressed = 1'b0;
  reg buttonCPressed = 1'b0;
  reg buttonUPressed = 1'b0;
  reg buttonDPressed = 1'b0;
  
  assign btnLOut = buttonLPressed;
  assign btnROut = buttonRPressed;
  assign btnCOut = buttonCPressed;
  assign btnUOut = buttonUPressed;
  assign btnDOut = buttonDPressed;
  
  // 7-segment display connections
  SevSeg ss(
    .clk(clk),
    .valIn(segsIn[15:0]),
    .segs(segsOut[6:0]),
    .anodes(anOut[3:0]),
    .dp(dpOut)
  );
  
  // Left button connections
  Debouncer dbL(
    .clk(clk),
    .in(btnLIn),
    .out(buttonLeft)
  );
  
  // Right button connections
  Debouncer dbR(
    .clk(clk),
    .in(btnRIn),
    .out(buttonRight)
  );
  
  // Center button connections
  Debouncer dbC(
    .clk(clk),
    .in(btnCIn),
    .out(buttonCenter)
  );
  
  // Up button connections
  Debouncer dbU(
    .clk(clk),
    .in(btnUIn),
    .out(buttonUp)
  );
  
  // Down button connections
  Debouncer dbD(
    .clk(clk),
    .in(btnDIn),
    .out(buttonDown)
  );
  
  always @ (posedge clk) begin
      
    if(buttonLeft == 1'b0) buttonLPressed <= 1'b0;
    if(buttonRight == 1'b0) buttonRPressed <= 1'b0;
    if(buttonCenter == 1'b0) buttonCPressed <= 1'b0;
    if(buttonUp == 1'b0) buttonUPressed <= 1'b0;
    if(buttonDown == 1'b0) buttonDPressed <= 1'b0;
    
    // Manual clock (Toggled on rising-edge)
    if(buttonLPressed == 1'b0 & buttonLeft == 1'b1) begin
      buttonLPressed <= 1'b1;
    end
    
    // External instruction mode (Toggled on rising-edge)
    if(buttonRPressed == 1'b0 & buttonRight == 1'b1) begin
      buttonRPressed <= 1'b1;
    end
    
    // Write instruction to instruction register
    if(buttonCPressed == 1'b0 & buttonCenter == 1'b1) begin
      buttonCPressed <= 1'b1;
    end
    else begin
      buttonCPressed <= 1'b0;
    end
    
    // Set snoop register
    if(buttonUPressed == 1'b0 & buttonUp == 1'b1) begin
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

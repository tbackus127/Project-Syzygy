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
    input dpIn,
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
//  wire buttonLeft;    // Clock step
//  wire buttonRight;   // Toggle RAM-Fetch (or external debugging) Mode
//  wire buttonCenter;  // Write instruction
//  wire buttonUp;      // Set snoop register
//  wire buttonDown;    // Reset everything
  
  // Holds each button's state
//  reg buttonLPressed = 1'b0;
//  reg buttonRPressed = 1'b0;
//  reg buttonCPressed = 1'b0;
//  reg buttonUPressed = 1'b0;
//  reg buttonDPressed = 1'b0;
  
  // Flag for posedge button triggers
//  reg buttonLReleased = 1'b0;
//  reg buttonRReleased = 1'b0;
//  reg buttonCReleased = 1'b0;
//  reg buttonUReleased = 1'b0;
//  reg buttonDReleased = 1'b0;
  
//  assign btnLOut = buttonLPressed;
//  assign btnROut = buttonRPressed;
//  assign btnCOut = buttonCPressed;
//  assign btnUOut = buttonUPressed;
//  assign btnDOut = buttonDPressed;
  
  // 7-segment display connections
  SevSeg ss(
    .clk(clk),
    .valIn(segsIn[15:0]),
    .dpIn(dpIn),
    .segs(segsOut[6:0]),
    .anodes(anOut[3:0]),
    .dpOut(dpOut)
  );
  
  // Left button connections
  Debouncer dbL(
    .clk(clk),
    .in(btnLIn),
    .out(btnLOut)
  );
  
  // Right button connections
  Debouncer dbR(
    .clk(clk),
    .in(btnRIn),
    .out(btnROut)
  );
  
  // Center button connections
  Debouncer dbC(
    .clk(clk),
    .in(btnCIn),
    .out(btnCOut)
  );
  
  // Up button connections
  Debouncer dbU(
    .clk(clk),
    .in(btnUIn),
    .out(btnUOut)
  );
  
  // Down button connections
  Debouncer dbD(
    .clk(clk),
    .in(btnDIn),
    .out(btnDOut)
  );
  
  // Generate rising-edge signals for buttons
//  always @ (posedge clk) begin
      
//    if(buttonLeft & ~buttonLReleased & ~buttonLPressed) begin
//      buttonLReleased <= 1'b1;
//      buttonLPressed <= 1'b1;
//    end else if(~buttonLeft & buttonLReleased) begin
//      buttonLReleased <= 1'b0;
//    end else begin
//      buttonLPressed <= 1'b0;
//    end
    
//    if(buttonUp & ~buttonUReleased & ~buttonUPressed) begin
//      buttonUReleased <= 1'b1;
//      buttonUPressed <= 1'b1;
//    end else if(~buttonUp & buttonUReleased) begin
//      buttonUReleased <= 1'b0;
//    end else begin
//      buttonUPressed <= 1'b0;
//    end
    
//    if(buttonCenter & ~buttonCReleased & ~buttonCPressed) begin
//      buttonCReleased <= 1'b1;
//      buttonCPressed <= 1'b1;
//    end else if(~buttonCenter & buttonCReleased) begin
//      buttonCReleased <= 1'b0;
//    end else begin
//      buttonCPressed <= 1'b0;
//    end
        
//    if(buttonDown & ~buttonDReleased & ~buttonDPressed) begin
//      buttonDReleased <= 1'b1;
//      buttonDPressed <= 1'b1;
//    end else if(~buttonDown & buttonDReleased) begin
//      buttonDReleased <= 1'b0;
//    end else begin
//      buttonDPressed <= 1'b0;
//    end
    
//    if(buttonRight & ~buttonRReleased & ~buttonRPressed) begin
//      buttonRReleased <= 1'b1;
//      buttonRPressed <= 1'b1;
//    end else if(~buttonRight & buttonRReleased) begin
//      buttonRReleased <= 1'b0;
//    end else begin
//      buttonRPressed <= 1'b0;
//    end
    
//  end
  
endmodule

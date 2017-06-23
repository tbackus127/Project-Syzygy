`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/20/2017 02:27:45 AM
// Design Name: 
// Module Name: SDInterfaceControl
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


module SDInterfaceControl(
    input clk,
    input btnL,
    input btnU,
    input btnC,
    input btnD,
    input btnR,
    input [15:0] sw,
    inout [7:0] JB,
    output [15:0] led,
    output [6:0] seg,
    output [3:0] an,
    output dp
  );
  
  // CPU Clock Speed Divider
  wire wCPUClock;
  ClockDivider cdiv(
    .cIn(clk),
    .cOut(wCPUClock)
  );
  
  // Input Normalizer (debounce buttons, de-short switches, 7seg encoder) 
  wire [15:0] wSwitches;
  
  wire buttonLeft;      // M0: Set Peripheral Register Number
                        // M1: Toggle 7-Seg Display Source (mode/dataVal)
                        
  wire buttonUp;        // M0: Write Peripheral Register with dataVal
                        // M1: Execute
                        
  wire buttonCenter;    // Toggle Mode
  
  wire buttonDown;      // M0: Read Peripheral Register to dataVal
                        // M1: Reset
                        
  wire buttonRight;     // Set Data Register
  wire [15:0] segsIn;
  reg inputMode = 1'b0;
  reg [15:0] dataValue = 16'h0000;
  InputNormalizer inorm(
    .clk(clk),
    .switchIn(sw[15:0]),
    .btnLIn(btnL),
    .btnUIn(btnU),
    .btnCIn(btnC),
    .btnDIn(btnD),
    .btnRIn(btnR),
    .segsIn(dataValue[15:0]),
    .dpIn(inputMode),
    .switchOut(wSwitches[15:0]),
    .btnLOut(buttonLeft),
    .btnUOut(buttonUp),
    .btnCOut(buttonCenter),
    .btnDOut(buttonDown),
    .btnROut(buttonRight),
    .segsOut(seg[6:0]),
    .anOut(an[3:0]),
    .dpOut(dp)
  );
  
  // Execution Mode signal registers
  reg resetReg = 1'b0;
  reg execReg = 1'b0;
  reg accessModeReg = 1'b0;
  reg [3:0] regNum = 4'b0000;
  
  // SD card interface connections
  wire [31:0] wInterfaceOut;
  SDInterface sdint(
    .clk(wCPUClock),
    .periphSelect(1'b1),
    .regSelect(regNum[3:0]),
    .accessMode(accessModeReg),
    .reset(resetReg),
    .dIn({16'h0000, dataValue[15:0]}),
    .exec(execReg),
    .miso(JB[2]),
    .serialClockOut(JB[3]),
    .dOut(wInterfaceOut[31:0]),
    .chipSel(JB[0]),
    .mosi(JB[1]),
    .debugOut(led[7:0]),
    .debugOut2(led[15:8])
  );
  
  // Control behavior
  always @ (posedge clk) begin
    
    // Reset signals (only rising-edge triggered)
    if(accessModeReg == 1'b1) accessModeReg <= 1'b0;
    if(resetReg == 1'b1) resetReg <= 1'b0;
    if(execReg == 1'b1) execReg <= 1'b0;
    
    // Set Peripheral Register Number / Toggle 7-Seg Source
    if(buttonLeft == 1'b1) begin
      regNum[3:0] <= wSwitches[3:0];
    end
    
    // Set Data Value Register
    if(buttonRight == 1'b1) begin
      dataValue[15:0] <= wSwitches[15:0];
    end
    
    // Mode Cycle
    if(buttonCenter == 1'b1) begin
      inputMode <= ~inputMode;
    end
    
    // Write dataVal -> Reg[regNum] / Execute         // TODO: Fix this.
    if(buttonUp == 1'b1) begin
      case(inputMode)
        1'b0: begin
          accessModeReg <= 1'b1;
        end
        1'b1: begin
          execReg <= 1'b1;
        end
      endcase
    end
    
    // Write Reg[regNum] -> dataVal / Reset
    if(buttonDown == 1'b1) begin
      case(inputMode)
        1'b0: begin
          accessModeReg <= 1'b0;
          dataValue[15:0] <= wInterfaceOut[15:0];
        end
        1'b1: begin
          resetReg <= 1'b1;
        end
      endcase
    end
  end
  
endmodule

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
    inout [3:0] JB,
    output [15:0] led,
    output [6:0] seg,
    output [3:0] an,
    output dp
  );
  
  // Assign the first four LEDs to serial clock, chip select, MOSI, and MISO, respectively
//  assign led[15] = JB[3];
//  assign led[14] = JB[0];
//  assign led[13] = JB[1];
//  assign led[12] = JB[2];
  
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
  reg [3:0] regNum = 4'b0000;
  wire [7:0] wControllerState;
  InputNormalizer inorm(
    .clk(clk),
    .switchIn(sw[15:0]),
    .btnLIn(btnL),
    .btnUIn(btnU),
    .btnCIn(btnC),
    .btnDIn(btnD),
    .btnRIn(btnR),
    .segsIn({wControllerState[7:0], regNum[3:0], dataValue[3:0]}),
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
  reg readEnReg = 1'b0;
  reg writeEnReg = 1'b0;
  
  // SD card interface connections
  wire [31:0] wInterfaceOut;
  SDInterface sdint(
    .cpuClock(wCPUClock),
    .periphSelect(1'b1),
    .regSelect(regNum[3:0]),
    .readEn(readEnReg),
    .writeEn(writeEnReg),
    .reset(resetReg),
    .dIn({16'h0000, dataValue[15:0]}),
    .exec(execReg),
    .miso(JB[2]),
    .serialClockOut(JB[3]),
    .dOut(wInterfaceOut[31:0]),
    .chipSel(JB[0]),
    .mosi(JB[1]),
    .debugOut(led[15:0]),                   // Response Byte
    .debugOut2(wControllerState[7:0])       // Controller State
  );
  // Control behavior
  always @ (posedge wCPUClock) begin
    
    // Reset signals (only rising-edge triggered)
    if(resetReg == 1'b1) resetReg <= 1'b0;
    
    // Set Peripheral Register Number
    if(buttonLeft == 1'b1) begin
      regNum[3:0] <= wSwitches[3:0];
    end
    
    // Set Data Value Register
    if(buttonRight == 1'b1) begin
      dataValue[15:0] <= wSwitches[15:0];
    end
    
    // Mode Toggle
    if(buttonCenter == 1'b1) begin
      inputMode <= ~inputMode;
    end
    
    // Write dataVal -> Reg[regNum] / Execute
    if(buttonUp == 1'b1) begin
      case(inputMode)
        1'b0: begin
          writeEnReg <= 1'b1;
        end
        1'b1: begin
          execReg <= 1'b1;
        end
      endcase
    end else begin
      writeEnReg <= 1'b0;
      execReg <= 1'b0;
    end
    
    // Write Reg[regNum] -> dataVal / Reset
    if(buttonDown == 1'b1) begin
      case(inputMode)
        1'b0: begin
          readEnReg <= 1'b1;
          dataValue[15:0] <= wInterfaceOut[15:0];
        end
        1'b1: begin
          resetReg <= 1'b1;
        end
      endcase
    end else begin
      readEnReg <= 1'b0;
    end
    
  end
  
endmodule

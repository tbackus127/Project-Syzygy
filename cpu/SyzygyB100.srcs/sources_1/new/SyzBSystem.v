`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/12/2017 03:09:39 PM
// Design Name: 
// Module Name: SyzBSystem
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


module SyzBSystem(
    input clk,
    input en,
    input res,
    input [7:0] snoopSelect,
    input miso,
    output [15:0] snoopOut,
    output serialClock,
    output chipSelect,
    output mosi
  );
  
  // Clock Phase: 0 = Fetch Instruction, 1 = Decode & Execute
  //   Starts HI so first tick will be LO.
  reg clockPhaseReg = 1'b1;
  
  // Clock Divider
  wire clockSig;
  ClockDivider cdiv (
    .cIn(clk),
    .cOut(clockSig)
  );
  
  // Boot Rom
  wire wVNMode;
  wire [15:0] wProgCountVal;
  wire [15:0] wBootROMOut;
  BootRom brom(
    .readEn(en),
    .addr(wProgCountVal[5:0]),
    .instrOut(wBootROMOut[15:0]),
    .debugOut()
  );
  
  // System Memory
  wire [15:0] wMemInstrOut;
  wire [15:0] wAddrFromMemIntr;
  wire [15:0] wDataFromMemIntr;
  wire [15:0] wDataToMemIntr;
  wire wMemRdFromIntr;
  wire wMemWrFromIntr;
  SyzMem mem(
    .memClk(clockSig),
    .addrInPC(wProgCountVal[15:0]),
    .addrInAcc(wAddrFromMemIntr[15:0]),
    .dIn(wDataFromMemIntr[15:0]),
    .readEn(wMemRdFromIntr),
    .writeEn(wMemWrFromIntr),
    .dOutPC(wMemInstrOut[15:0]),
    .dOutAcc(wDataToMemIntr[15:0])
  );
  
  // Choose instruction source from Boot ROM or system memory
  wire [15:0] wInstrIn;
  Mux16B2to1 muxInstr(
    .aIn(wBootROMOut[15:0]),
    .bIn(wMemInstrOut[15:0]),
    .sel(wVNMode),
    .dOut(wInstrIn[15:0])
  );
  
  // CPU
  wire [31:0] wDataToPeriphs;
  wire [31:0] wDataFromPeriphs;
  wire [3:0] wPeriphSelect;
  wire [3:0] wPeriphRegSelect;
  wire wPeriphRegReadEn;
  wire wPeriphRegWriteEn;
  wire wPeriphExec;
  SyzygyB100 cpu(
    .clockSig(clockSig),
    .en(en),
    .res(res),
    .extInstrIn(wInstrIn[15:0]),
    .extRegSel(snoopSelect[3:0]),
    .extPCValue(wProgCountVal[15:0]),
    .extPerDIn(wDataFromPeriphs[31:0]),
    .sysClockPhase(clockPhaseReg),
    .vnMode(wVNMode),
    .extPeekValue(snoopOut[15:0]),
    .extPerDOut(wDataToPeriphs[31:0]),
    .extPerSel(wPeriphSelect[3:0]),
    .extPerReg(wPeriphRegSelect[3:0]),
    .extPerReadEn(wPeriphRegReadEn),
    .extPerWriteEn(wPeriphRegWriteEn),
    .extPerExec(wPeriphExec)
  );
  
  
  //----------------------------------------------------------------------------
  // Peripheral Interfaces
  //
  // Peripheral ID's:
  //   PID=0: LEDs
  //   PID=1: 7-segment display
  //   PID=2: Memory
  //   PID=3: SD Card
  //   PID=4: VGA Output
  //   PID=5: Keyboard Input
  //----------------------------------------------------------------------------
  
  wire [15:0] wPeriphSelectSignals;
  Dmx4to16 pidSelDmx(
    .sel(wPeriphSelect[3:0]),
    .en(wPeriphRegWriteEn | wPeriphRegReadEn | wPeriphExec),
    .out(wPeriphSelectSignals[15:0])
  );
  
  // LEDs (PID=0)
  // TODO: Make LED interface
  
  // 7-segment display (PID=1)
  // TODO: Make 7Seg interface
  
  // Memory (PID=2)
  // Debug sources:
  //   SnoopPeriph=1:
  //     Reg=0: R0 (Instruction)
  //     Reg=1: R1 (Status, always 0x0)
  //     Reg=2: R2 (Data-In)
  //     Reg=3: R0 (Data-Out)
  //     Reg=4: R0 (Address)
  MemoryInterface memint(
    .cpuClock(clockSig),
    .periphSelect(wPeriphSelectSignals[2]),
    .dIn(wDataToPeriphs[15:0]),
    .regSelect(wPeriphRegSelect[3:0]),
    .readEn(wPeriphRegReadEn),
    .writeEn(wPeriphRegWriteEn),
    .reset(res),
    .exec(wPeriphExec),
    .dataFromMem(wDataToMemIntr[15:0]),
    .dataToMem(wDataFromMemIntr[15:0]),
    .addrToMem(wAddrFromMemIntr[15:0]),
    .memReadEn(wMemRdFromIntr),
    .memWriteEn(wMemWrFromIntr)
  );
  
  // SD card interface (PID=3)
  // Debug sources:
  //   SnoopPeriph=2: Interface Registers
  //     Reg=0: R0 (Instruction)
  //     Reg=1: R1 (Status)
  //     Reg=2: R2 (Data-In)
  //     Reg=3: R3 (Data-Out)
  //     Reg=4: R4 (Address, 15-0)
  //     Reg=5: R4 (Address, 31-16)
  //   SnoopPeriph=3: Controller Registers
  //     Reg=0: Current State
  //     Reg=1: I/O Pins (CS, MOSI, MISO, SCLK)
  //     Reg=2: Return State
  //     Reg=3: Count
  //     Reg=4: Block Count
  //     Reg=5: Response
  //     Reg=6: Data
  //     Reg=7: Address
  SDInterface sdint(
    .cpuClock(clockSig),                    // TODO: Make debug in src and reg select
    .periphSelect(wPeriphSelectSignals[3]),
    .regSelect(wPeriphRegSelect[3:0]),
    .readEn(wPeriphRegReadEn),
    .writeEn(wPeriphRegWriteEn),
    .reset(res),
    .dIn(wDataToPeriphs[31:0]),
    .exec(wPeriphExec),
    .miso(miso),
    .serialClockOut(serialClock),
    .dOut(wDataFromPeriphs[31:0]),
    .chipSel(chipSelect),
    .mosi(mosi),
    .debugOut(),                            // TODO: Unify to one output and connect to debug out
    .debugOut2()
  );
  
  // TODO: Or/Mux together peripheral's dOut signals
  
  
  // Snoop demultiplexing (for debugging)
  //   Format: 4xPart ID, 4x Reg Number
  //
  // Snoop IDs:
  //   0: CPU
  //   1: Memory Interface
  //   2: SD Interface
  //   3: SD Controller
  // TODO: This
  
  always @ (posedge clockSig) begin
    if(en) begin
      clockPhaseReg <= ~clockPhaseReg;
    end
  end
  
endmodule
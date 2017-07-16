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
    input [15:0] dIn,
    input [7:0] snoopSelect,
    input miso,
    output [15:0] snoopOut,
    output serialClock,
    output chipSelect,
    output mosi
  );
  
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
    .readEn(~wVNMode),
    .addr(wProgCountVal[15:0]),
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
  wire vnMode;
  wire [15:0] wInstrIn;
  Mux16B2to1 muxInstr(
    .aIn(wBootROMOut[15:0]),
    .bIn(wMemInstrOut[15:0]),
    .sel(vnMode),
    .dOut(wInstrIn[15:0])
  );
  
  // TODO: Snoop Select: {4x[PeriphID (CPU=0, Periphs=ID+16], 4x[RegNum]}
  
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
    .extRegSel(),                           // TODO: Connect this to debug in
    .extPCValue(wProgCountVal[15:0]),
    .extPerDIn(wDataFromPeriphs[31:0]),
    .vnMode(vnMode),
    .extPeekValue(),                        // TODO: Connect this to debug out
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
  
  // TODO: Or/Mux together peripheral's dOut signals
  
  // LEDs (PID=0)
  // TODO: Make LED interface
  
  // 7-segment display (PID=1)
  // TODO: Make 7Seg interface
  
  // Memory (PID=2)
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
  SDInterface sdint(
    .cpuClock(clockSig),
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
    .debugOut(),
    .debugOut2()
  );
  
endmodule

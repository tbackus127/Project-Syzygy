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
    output vnMode,
    output serialClock,
    output chipSelect,
    output mosi
  );
  
  // 64000/2: Human-readable
  // 16/2: Normal Safe Clock
  // Count this number of board clock ticks before inverting the memory clock
  parameter CDIV_AMT_MEM = 8;
  
  // Count this number of memory clock ticks before inverting the CPU clock
  parameter CDIV_AMT_CPU = 2;
  
  // Clock Phase: 0 = Fetch Instruction, 1 = Decode & Execute
  //   Starts HI so first tick will be LO.
  reg clockPhaseReg = 1'b1;
  
  // Clock Divider (Mem)
  wire clockSigMem;
  ClockDivider cdivmem (
    .cIn(clk),
    .reqCount(CDIV_AMT_MEM),
    .cOut(clockSigMem)
  );
  
  // Clock Divider (CPU clock, 4x slower than memory clock)
  wire clockSigCPU;
  ClockDivider cdivcpu (
    .cIn(clockSigMem),
    .reqCount(CDIV_AMT_CPU),
    .cOut(clockSigCPU)
  );
  
  // Boot Rom
  wire wVNMode;
  wire [15:0] wProgCountVal;
  wire [15:0] wBootROMOut;
  BootRom brom(
    .readEn(en),
    .addr(wProgCountVal[7:0]),
    .instrOut(wBootROMOut[15:0]),
    .debugOut()
  );
  assign vnMode = wVNMode;
  
  // Memory address input multiplexer
  wire [15:0] wMemAddrIn;
  wire [15:0] wAddrFromMemIntr;
  Mux16B2to1 memAddrInMux(
    .aIn(wProgCountVal[15:0]),
    .bIn(wAddrFromMemIntr[15:0]),
    .sel(clockPhaseReg),
    .dOut(wMemAddrIn[15:0])
  );
  
  // System Memory
  wire [15:0] wDataFromMemIntr;
  wire [15:0] wDataFromMem;
  wire wMemRdFromIntr;
  wire wMemWrFromIntr;
  wire wMemBusy;
  SyzMem mem(
    .memClk(clockSigMem),
    .addr(wMemAddrIn[15:0]),
    .en(1'b1),
    .dIn(wDataFromMemIntr[15:0]),
    .readEn(wMemRdFromIntr | ~clockPhaseReg),
    .writeEn(wMemWrFromIntr),
    .dOut(wDataFromMem[15:0]),
    .busy(wMemBusy)
  );
  
  
  // Choose instruction source from Boot ROM or system memory
  wire [15:0] wInstrIn;
  Mux16B2to1 muxInstr(
    .aIn(wBootROMOut[15:0]),
    .bIn(wDataFromMem[15:0]),
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
  wire [15:0] wCPUDebugOut;
  SyzygyB100 cpu(
    .clockSig(clockSigCPU),
    .en(en),
    .res(res),
    .extInstrIn(wInstrIn[15:0]),
    .extRegSel(snoopSelect[3:0]),
    .extPCValue(wProgCountVal[15:0]),
    .extPerDIn(wDataFromPeriphs[31:0]),
    .sysClockPhase(clockPhaseReg),
    .vnMode(wVNMode),
    .extPeekValue(wCPUDebugOut[15:0]),
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
  
  wire [15:0] wPeriphDebugOut;
  
  wire [15:0] wPeriphSelectSignals;
  Dmx4to16 periphIDSelect(
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
  //     Reg=1: R1 (Status)
  //     Reg=2: R2 (Data-In)
  //     Reg=3: R0 (Data-Out)
  //     Reg=4: R0 (Address)
  wire [31:0] wMemIntrDebugOut;
  wire [15:0] wMemDataOut;
  MemoryInterface memint(
    .cpuClock(clockSigCPU),
    .periphSelect(wPeriphSelectSignals[2]),
    .dIn(wDataToPeriphs[15:0]),
    .regSelect(wPeriphRegSelect[3:0]),
    .readEn(wPeriphRegReadEn),
    .writeEn(wPeriphRegWriteEn),
    .reset(res),
    .exec(wPeriphExec),
    .dataFromMem(wDataFromMem[15:0]),
    .debugRegSelect(snoopSelect[3:0]),
    .memStatus(wMemBusy),
    .dOut(wMemDataOut[15:0]),
    .dataToMem(wDataFromMemIntr[15:0]),
    .addrToMem(wAddrFromMemIntr[15:0]),
    .memReadEn(wMemRdFromIntr),
    .memWriteEn(wMemWrFromIntr),
    .debugOut(wMemIntrDebugOut[31:0])
  );
  
  // SD card interface (PID=3)
  // Debug sources:
  //   SnoopPeriph=2: Interface Registers
  //     Reg=0: R0 (Instruction)
  //     Reg=1: R1 (Status)
  //     Reg=2: R2 (Data-In)
  //     Reg=3: R3 (Data-Out)
  //     Reg=4: R4 (Address, 15-0)
  //   SnoopPeriph=3: {card signals[3:0], 0000, controller state[7:0]}
  wire [31:0] wDataFromSDInterface;
  wire [15:0] wSDIntrDebugOut;
  wire [15:0] wSDCtrlDebugOut;
  SDInterface sdint(
    .cpuClock(clockSigCPU),
    .periphSelect(wPeriphSelectSignals[3]),
    .regSelect(wPeriphRegSelect[3:0]),
    .readEn(wPeriphRegReadEn),
    .writeEn(wPeriphRegWriteEn),
    .reset(res),
    .dIn(wDataToPeriphs[31:0]),
    .exec(wPeriphExec),
    .miso(miso),
    .debugRegSelect(snoopSelect[4:0]),
    .serialClockOut(serialClock),
    .dOut(wDataFromSDInterface[31:0]),
    .chipSel(chipSelect),
    .mosi(mosi),
    .debugOut(wSDIntrDebugOut[15:0]),
    .debugControllerOut(wSDCtrlDebugOut[15:0])    
  );
  
  // Peripheral Data Bus
  Or32B4Way periphDataOr(
    .aIn(32'h00000000),
    .bIn(32'h00000000),
    .cIn({16'h0000, wMemDataOut[15:0]}),
    .dIn(wDataFromSDInterface[31:0]),
    .dOut(wDataFromPeriphs[31:0])
  );
  
  // Snoop demultiplexing (for debugging)
  //   Format: 4xPart ID, 4x Reg Number
  //
  // Snoop IDs:
  //   0: CPU
  //   1: Memory Interface
  //   2: SD Interface
  //   3: SD Controller
  Mux16B8to1 periphIntrfaceSelect(
    .dIn0(wCPUDebugOut[15:0]),
    .dIn1(wMemIntrDebugOut[15:0]),
    .dIn2(wSDIntrDebugOut[15:0]),
    .dIn3(wSDCtrlDebugOut[15:0]),
    .dIn4(16'h00),
    .dIn5(16'h00),
    .dIn6(16'h00),
    .dIn7(16'h00),
    .sel(snoopSelect[6:4]),
    .dOut(snoopOut[15:0])
  );
  
  always @ (posedge clockSigCPU) begin
    if(en) begin
      clockPhaseReg <= ~clockPhaseReg;
    end
  end
  
endmodule

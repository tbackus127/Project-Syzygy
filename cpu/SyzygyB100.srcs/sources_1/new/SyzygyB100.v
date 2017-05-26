`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/03/2017 07:43:33 PM
// Design Name: 
// Module Name: SyzygyB100
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

module SyzygyB100(
    input clk,
    input en,
    input res,
    input [15:0] extInstrIn,
    output [15:0] extDOut,
    output [31:0] extPerDOut,
    output [3:0] extPerSel,
    output [3:0] extPerReg,
    output extPerModeAcc,
    output extPerModeExec,
    output extPerMode32
  );
  
  // Data bus
  wire [15:0] wDataBus;
  
  // Register reset lines
  wire [15:0] wRegReset;
  assign wRegReset [15:0] = {15{res}};
  
  //----------------------------------------------------------------------------
  // Instruction Decoder
  //----------------------------------------------------------------------------
  
  // Decoder signals
  wire [15:0] wPushVal;
  wire [3:0] wRegReadSel;
  wire [3:0] wRegWriteSel;
  wire [3:0] wPeriphSel;
  wire [2:0] wJumpCondition;
  wire [1:0] muxSel;
  wire wAccSrcSelect;
  wire wAccALUSrc;
  wire wReadEn;
  wire wWriteEn;
  
  // Instruction Decoder connections
  InstructionDecoder instrDec(
    .instrIn(wInstrRegOut[15:0]),
    .pushVal(wPushVal[15:0]),
    .regReadSelect(wRegReadSel[3:0]),
    .readEn(wReadEn),
    .regWriteSelect(wRegWriteSel[3:0]),
    .writeEn(wWriteEn),
    .jumpCondition(wJumpCondition[2:0]),
    .aluOp(wALUInstr[10:8]),
    .aluArgs(wALUInstr[7:0]),
    .periphSelect(extPerSel[3:0]),
    .periphReg(extPerReg[3:0]),
    .periphMode(extPerModeAcc),
    .periphExec(extPerModeExec),
    .periph32(extPerMode32),
    .accumMuxSelect(muxSel[1:0])
  );
  assign wAccSrcSelect = muxSel[1];
  assign wAccALUSrc = muxSel[0];
  
  // Register read (source) decoder
  wire [15:0] wRegReadExp;
  Dmx4to16 dmxRegReadSel(
    .sel(wRegReadSel[3:0]),
    .en(wReadEn),
    .out(wRegReadExp[15:0])
  );
  
  // Register write (destination) decoder
  wire [15:0] wRegWriteExp;
  Dmx4to16 dmxRegWriteSel(
    .sel(wRegWriteSel[3:0]),
    .en(wWriteEn),
    .out(wRegWriteExp[15:0])
  );

  //----------------------------------------------------------------------------
  // Boot ROM
  //----------------------------------------------------------------------------
  wire [15:0] wBootROMOut;
  BootRom brom (
    .clk(clk),
    .res(res),
    .addr(wCounterOut[2:0]),
    .instrOut(wBootROMOut[15:0])
  );

  //----------------------------------------------------------------------------
  // Registers
  //----------------------------------------------------------------------------
  
  // R0: Instruction Register
  wire [15:0] wInstrRegOut;
  wire [15:0] wInstrRegIn;
  SyzFETRegister regInstr(
    .dIn(wInstrRegIn[15:0]),
    .clk(clk),
    .read(wRegReadExp[0]),
    .write(wRegWriteExp[0]),
    .asyncReset(wRegReset[0]),
    .dOut(wInstrRegOut[15:0]),    
    .dOut2(extDOut[15:0])
  );
  Mux16B2to1 muxInstrReg(
    .aIn(wBootROMOut[15:0]),
    .bIn(extInstrIn[15:0]),
    .sel(),
    .dOut(wInstrRegIn[15:0])
  );
  
  // R1: Program Counter
  wire [15:0] wR3JumpAddr;
  wire [15:0] wCounterOut;
  wire wJmpEn;
  Counter16B pc (
    .clk(clk),
    .en(en),
    .res(res),
    .valIn(wR3JumpAddr[15:0]),
    .set(wJmpEn),
    .valOut(wCounterOut[15:0])
  );
  SyzFETRegister regProgCount(
    .dIn(wCounterOut[15:0]),
    .clk(clk),
    .read(wRegReadExp[1]),
    .write(wRegWriteExp[1]),
    .asyncReset(wRegReset[1]),
    .dOut(),
    .dOut2()
  );
  
  // R2: Accumulator
  wire [15:0] wALUOut;
  wire [15:0] wAccMuxStep;
  wire [15:0] wAccumIn;
  wire [15:0] wCompIn;
  Mux16B2to1 muxAccSel(
    .aIn(wDataBus[15:0]),
    .bIn(wAccMuxStep[15:0]),
    .sel(wAccSrcSelect),
    .dOut(wAccumIn[15:0])
  );
  Mux16B2to1 muxAccOp(
    .aIn(wPushVal[15:0]),
    .bIn(wALUOut[15:0]),
    .sel(wAccALUSrc),
    .dOut(wAccMuxStep[15:0])
  );
  SyzFETRegister regAccum(
    .dIn(wAccumIn[15:0]),
    .clk(clk),
    .read(wRegReadExp[2]),
    .write(wRegWriteExp[2]),
    .asyncReset(wRegReset[2]),
    .dOut(wDataBus[15:0]),
    .dOut2(wCompIn[15:0])
  );
  Comparator cmp(
    .dIn(wCompIn[15:0]),
    .lt(wJumpCondition[2]),
    .eq(wJumpCondition[1]),
    .gt(wJumpCondition[0]),
    .jmpEn(wJmpEn)
  );
  
  // R3: Jump Address
  SyzFETRegister regJmpAddr(
    .dIn(wDataBus[15:0]),
    .clk(clk),
    .read(wRegReadExp[3]),
    .write(wRegWriteExp[3]),
    .asyncReset(wRegReset[3]),
    .dOut(wDataBus[15:0]),
    .dOut2(wR3JumpAddr[15:0])
  );
  
  // R4: I/O LSB
  wire [31:0] wIOOut;
  SyzFETRegister regIOLSB(
    .dIn(wDataBus[15:0]),
    .clk(clk),
    .read(wRegReadExp[4]),
    .write(wRegWriteExp[4]),
    .asyncReset(wRegReset[4]),
    .dOut(wDataBus[15:0]),
    .dOut2(wIOOut[15:0])
  );
  
  // R5: I/O MSB
  SyzFETRegister regIOMSB(
    .dIn(wDataBus[15:0]),
    .clk(clk),
    .read(wRegReadExp[5]),
    .write(wRegWriteExp[5]),
    .asyncReset(wRegReset[5]),
    .dOut(wDataBus[15:0]),
    .dOut2(wIOOut[31:16])
  );
  assign extPerDOut[31:0] = wIOOut[31:0];
  
  // R6: ALU A
  wire [15:0] wALUAin;
  SyzFETRegister regALUA(
    .dIn(wDataBus[15:0]),
    .clk(clk),
    .read(wRegReadExp[6]),
    .write(wRegWriteExp[6]),
    .asyncReset(wRegReset[6]),
    .dOut(wDataBus[15:0]),
    .dOut2(wALUAin[15:0])
  );
  
  // R7: ALU B
  wire [15:0] wALUBin;
  SyzFETRegister regALUB(
    .dIn(wDataBus[15:0]),
    .clk(clk),
    .read(wRegReadExp[7]),
    .write(wRegWriteExp[7]),
    .asyncReset(wRegReset[7]),
    .dOut(wDataBus[15:0]),
    .dOut2(wALUBin[15:0])
  );
  
  //----------------------------------------------------------------------------
  // ALU
  //----------------------------------------------------------------------------
  
  // ALU connections
  wire [11:0] wALUInstr;
  ALU alu(
    .aIn(wALUAin[15:0]),
    .bIn(wALUBin[15:0]),
    .op(wALUInstr[10:8]),
    .negA(wALUInstr[7]),
    .negB(wALUInstr[6]),
    .zeroB(wALUInstr[5]),
    .negQ(wALUInstr[4]),
    .arg(wALUInstr[3]),
    .arth(wALUInstr[2]),
    .rot(wALUInstr[1]),
    .aluOut(wALUOut[15:0])
  );
  
endmodule

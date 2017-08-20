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
    input clockSig,
    input en,
    input res,
    input [15:0] extInstrIn,
    input [3:0] extRegSel,
    input [31:0] extPerDIn,
    input sysClockPhase,
    output vnMode,
    output [15:0] extPCValue,
    output [15:0] extPeekValue,
    output [31:0] extPerDOut,
    output [3:0] extPerSel,
    output [3:0] extPerReg,
    output extPerReadEn,
    output extPerWriteEn,
    output extPerExec
  );
  
  // Data bus connections, prevents nets having multiple drivers
  wire [3:0] wRegReadSel;
  wire [15:0] wDataBus;
  wire [15:0] wBusInput2;
  wire [15:0] wBusInput3;
  wire [15:0] wBusInput4;
  wire [15:0] wBusInput5;
  wire [15:0] wBusInput6;
  wire [15:0] wBusInput7;
  wire [15:0] wBusInput8;
  wire [15:0] wBusInput9;
  wire [15:0] wBusInput10;
  wire [15:0] wBusInput11;
  wire [15:0] wBusInput12;
  wire [15:0] wBusInput13;
  wire [15:0] wBusInput14;
  wire [15:0] wBusInput15;
  Mux16B16to1 dataBusMux (
    .dIn0(16'hf000),              // Copying "R0" to any other register will copy 0xf000
    .dIn1(16'hffff),              // Likewise for R1 (0xffff)
    .dIn2(wBusInput2[15:0]),
    .dIn3(wBusInput3[15:0]),
    .dIn4(wBusInput4[15:0]),
    .dIn5(wBusInput5[15:0]),
    .dIn6(wBusInput6[15:0]),
    .dIn7(wBusInput7[15:0]),
    .dIn8(wBusInput8[15:0]),
    .dIn9(wBusInput9[15:0]),
    .dIn10(wBusInput10[15:0]),
    .dIn11(wBusInput11[15:0]),
    .dIn12(wBusInput12[15:0]),
    .dIn13(wBusInput13[15:0]),
    .dIn14(wBusInput14[15:0]),
    .dIn15(wBusInput15[15:0]),
    .sel(wRegReadSel[3:0]),
    .dOut(wDataBus[15:0])
  );
  
  // Register reset lines
  wire [15:0] wRegReset;
  assign wRegReset [15:0] = {16{res}};
  
  //----------------------------------------------------------------------------
  // Instruction Decoder
  //----------------------------------------------------------------------------
  
  // Decoder signals
  
  wire [3:0] wSysFlagNum;
  wire wSysFlagVal;
  wire wSysFlagWriteEn;
  wire [14:0] wPushVal;
  wire [3:0] wRegWriteSel;
  wire [2:0] wJumpCondition;
  wire [1:0] muxSel;
  wire wAccSrcSelect;
  wire wAccALUSrc;
  wire wReadEn;
  wire wWriteEn;
  wire [15:0] wInstrRegOut;
  wire wIOInstruction;
  
  // Instruction Decoder connections
  InstructionDecoder instrDec(
    .instrIn(wInstrRegOut[15:0]),
    .sysFlagNum(wSysFlagNum[3:0]),
    .sysFlagVal(wSysFlagVal),
    .sysFlagWrite(wSysFlagWriteEn),
    .pushVal(wPushVal[14:0]),
    .regReadSelect(wRegReadSel[3:0]),
    .readEn(wReadEn),
    .regWriteSelect(wRegWriteSel[3:0]),
    .writeEn(wWriteEn),
    .jumpCondition(wJumpCondition[2:0]),
    .aluOp(wALUInstr[10:8]),
    .aluArgs(wALUInstr[7:0]),
    .periphSelect(extPerSel[3:0]),
    .periphReg(extPerReg[3:0]),
    .periphRead(extPerReadEn),
    .periphWrite(extPerWriteEn),
    .periphExec(extPerExec),
    .accumMuxSelect(muxSel[1:0]),
    .ioWrite(wIOInstruction)
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
  // Special Registers
  //----------------------------------------------------------------------------
  
  // System flag register
  // Flags:
  //   0: VonNeumann execution mode
  //   (1-15 to be decided as needed)
  wire [15:0] wSysFlags;
  SyzFETFlagReg sysfReg(
    .clockSig(clockSig),
    .value(wSysFlagVal),
    .sel(wSysFlagNum[3:0]),
    .write(wSysFlagWriteEn),
    .reset(res),
    .dOut(wSysFlags[15:0])
  );
  assign vnMode = wSysFlags[0];
  
  // Debug register select
  wire [15:0] wDebugOut0;
  wire [15:0] wDebugOut1;
  wire [15:0] wDebugOut2;
  wire [15:0] wDebugOut3;
  wire [15:0] wDebugOut4;
  wire [15:0] wDebugOut5;
  wire [15:0] wDebugOut6;
  wire [15:0] wDebugOut7;
  wire [15:0] wDebugOut8;
  wire [15:0] wDebugOut9;
  wire [15:0] wDebugOut10;
  wire [15:0] wDebugOut11;
  wire [15:0] wDebugOut12;
  wire [15:0] wDebugOut13;
  wire [15:0] wDebugOut14;
  wire [15:0] wDebugOut15;
  Mux16B16to1 muxDebugSelect(
    .dIn0(wDebugOut0[15:0]),
    .dIn1(wDebugOut1[15:0]),
    .dIn2(wDebugOut2[15:0]),
    .dIn3(wDebugOut3[15:0]),
    .dIn4(wDebugOut4[15:0]),
    .dIn5(wDebugOut5[15:0]),
    .dIn6(wDebugOut6[15:0]),
    .dIn7(wDebugOut7[15:0]),
    .dIn8(wDebugOut8[15:0]),
    .dIn9(wDebugOut9[15:0]),
    .dIn10(wDebugOut10[15:0]),
    .dIn11(wDebugOut11[15:0]),
    .dIn12(wDebugOut12[15:0]),
    .dIn13(wDebugOut13[15:0]),
    .dIn14(wDebugOut14[15:0]),
    .dIn15(wDebugOut15[15:0]),
    .sel(extRegSel[3:0]),
    .dOut(extPeekValue[15:0])
  );
  
  // R0: Instruction Register
  SyzFETRegister2Out regInstr(
    .dIn(extInstrIn[15:0]),
    .clockSig(clockSig),
    .read(sysClockPhase),
    .write(~sysClockPhase),
    .reset(res),
    .dOut(wInstrRegOut[15:0]),
    .debugOut(wDebugOut0[15:0])
  );                                        
  
  // R1: Program Counter
  wire [15:0] wR3JumpAddr;
  wire [15:0] wCounterOut;
  wire wJmpEn;
  Counter16B pc (
    .clockSig(clockSig),
    .en(sysClockPhase),
    .valIn(wR3JumpAddr[15:0]),
    .set(wJmpEn),
    .res(res),
    .valOut(wCounterOut[15:0]),
    .debugOut(wDebugOut1[15:0])
  );
  assign extPCValue[15:0] = wCounterOut[15:0];
  
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
    .aIn({1'b0, wPushVal[14:0]}),
    .bIn(wALUOut[15:0]),
    .sel(wAccALUSrc),
    .dOut(wAccMuxStep[15:0])
  );
  SyzFETRegister3Out regAccum(
    .dIn(wAccumIn[15:0]),
    .clockSig(clockSig),
    .read(wRegReadExp[2]),
    .write(wRegWriteExp[2]),
    .reset(wRegReset[2]),
    .dOut(wBusInput2[15:0]),
    .dOut2(wCompIn[15:0]),
    .debugOut(wDebugOut2[15:0])
  );
  Comparator cmp(
    .dIn(wCompIn[15:0]),
    .lt(wJumpCondition[2]),
    .eq(wJumpCondition[1]),
    .gt(wJumpCondition[0]),
    .jmpEn(wJmpEn)
  );
  
  // R3: Jump Address
  SyzFETRegister3Out regJmpAddr(
    .dIn(wDataBus[15:0]),
    .clockSig(clockSig),
    .read(wRegReadExp[3]),
    .write(wRegWriteExp[3]),
    .reset(wRegReset[3]),
    .dOut(wBusInput3[15:0]),
    .dOut2(wR3JumpAddr[15:0]),
    .debugOut(wDebugOut3[15:0])
  );
  
  // I/O Source Muxes
  wire [15:0] wR4Src;
  wire [15:0] wR5Src;
  Mux16B2to1 ioLSBMux(
    .aIn(wDataBus[15:0]),
    .bIn(extPerDIn[15:0]),
    .sel(wIOInstruction),
    .dOut(wR4Src[15:0])
  );
  Mux16B2to1 ioMSBMux(
    .aIn(wDataBus[15:0]),
    .bIn(extPerDIn[31:16]),
    .sel(wIOInstruction),
    .dOut(wR5Src[15:0])
  );
  
  // R4: I/O LSB
  wire [31:0] wIOOut;
  SyzFETRegister3Out regIOLSB(
    .dIn(wR4Src[15:0]),
    .clockSig(clockSig),
    .read(wRegReadExp[4]),
    .write(wRegWriteExp[4] | wIOInstruction),
    .reset(wRegReset[4]),
    .dOut(wBusInput4[15:0]),
    .dOut2(wIOOut[15:0]),
    .debugOut(wDebugOut4[15:0])
  );
  
  // R5: I/O MSB
  SyzFETRegister3Out regIOMSB(
    .dIn(wR5Src[15:0]),
    .clockSig(clockSig),
    .read(wRegReadExp[5]),
    .write(wRegWriteExp[5] | wIOInstruction),
    .reset(wRegReset[5]),
    .dOut(wBusInput5[15:0]),
    .dOut2(wIOOut[31:16]),
    .debugOut(wDebugOut5[15:0])
  );
  assign extPerDOut[31:0] = wIOOut[31:0];
  
  // R6: ALU A
  wire [15:0] wALUAin;
  SyzFETRegister3Out regALUA(
    .dIn(wDataBus[15:0]),
    .clockSig(clockSig),
    .read(wRegReadExp[6]),
    .write(wRegWriteExp[6]),
    .reset(wRegReset[6]),
    .dOut(wBusInput6[15:0]),
    .dOut2(wALUAin[15:0]),
    .debugOut(wDebugOut6[15:0])
  );
  
  // R7: ALU B
  wire [15:0] wALUBin;
  SyzFETRegister3Out regALUB(
    .dIn(wDataBus[15:0]),
    .clockSig(clockSig),
    .read(wRegReadExp[7]),
    .write(wRegWriteExp[7]),
    .reset(wRegReset[7]),
    .dOut(wBusInput7[15:0]),
    .dOut2(wALUBin[15:0]),
    .debugOut(wDebugOut7[15:0])
  );
  
  //----------------------------------------------------------------------------
  // General-Purpose Registers
  //----------------------------------------------------------------------------
  
  // R8
  SyzFETRegister2Out regR8(
    .dIn(wDataBus[15:0]),
    .clockSig(clockSig),
    .read(wRegReadExp[8]),
    .write(wRegWriteExp[8]),
    .reset(wRegReset[8]),
    .dOut(wBusInput8[15:0]),
    .debugOut(wDebugOut8[15:0])
  );
  
  // R9
  SyzFETRegister2Out regR9(
    .dIn(wDataBus[15:0]),
    .clockSig(clockSig),
    .read(wRegReadExp[9]),
    .write(wRegWriteExp[9]),
    .reset(wRegReset[9]),
    .dOut(wBusInput9[15:0]),
    .debugOut(wDebugOut9[15:0])
  );
  
  // R10
  SyzFETRegister2Out regR10(
    .dIn(wDataBus[15:0]),
    .clockSig(clockSig),
    .read(wRegReadExp[10]),
    .write(wRegWriteExp[10]),
    .reset(wRegReset[10]),
    .dOut(wBusInput10[15:0]),
    .debugOut(wDebugOut10[15:0])
  );
  
  // R11
  SyzFETRegister2Out regR11(
    .dIn(wDataBus[15:0]),
    .clockSig(clockSig),
    .read(wRegReadExp[11]),
    .write(wRegWriteExp[11]),
    .reset(wRegReset[11]),
    .dOut(wBusInput11[15:0]),
    .debugOut(wDebugOut11[15:0])
  );
  
  // R12
  SyzFETRegister2Out regR12(
    .dIn(wDataBus[15:0]),
    .clockSig(clockSig),
    .read(wRegReadExp[12]),
    .write(wRegWriteExp[12]),
    .reset(wRegReset[12]),
    .dOut(wBusInput12[15:0]),
    .debugOut(wDebugOut12[15:0])
  );
  
  // R13
  SyzFETRegister2Out regR13(
    .dIn(wDataBus[15:0]),
    .clockSig(clockSig),
    .read(wRegReadExp[13]),
    .write(wRegWriteExp[13]),
    .reset(wRegReset[13]),
    .dOut(wBusInput13[15:0]),
    .debugOut(wDebugOut13[15:0])
  );
  
  // R14
  SyzFETRegister2Out regR14(
    .dIn(wDataBus[15:0]),
    .clockSig(clockSig),
    .read(wRegReadExp[14]),
    .write(wRegWriteExp[14]),
    .reset(wRegReset[14]),
    .dOut(wBusInput14[15:0]),
    .debugOut(wDebugOut14[15:0])
  );
  
  // R15
  SyzFETRegister2Out regR15(
    .dIn(wDataBus[15:0]),
    .clockSig(clockSig),
    .read(wRegReadExp[15]),
    .write(wRegWriteExp[15]),
    .reset(wRegReset[15]),
    .dOut(wBusInput15[15:0]),
    .debugOut(wDebugOut15[15:0])
  );
  
  
  //----------------------------------------------------------------------------
  // ALU
  //----------------------------------------------------------------------------
  
  // ALU connections
  wire [10:0] wALUInstr;
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
    .misc(wALUInstr[0]),
    .aluOut(wALUOut[15:0])
  );
  
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/24/2017 05:29:26 PM
// Design Name: 
// Module Name: InstructionDecoder
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

module InstructionDecoder(
    input [15:0] instrIn,
    output reg [3:0] sysFlagNum = 4'h0,
    output reg sysFlagVal = 1'b0,
    output reg sysFlagWrite = 1'b0,
    output reg [14:0] pushVal = 15'b000000000000000,
    output reg [3:0] regReadSelect = 4'b0000,
    output reg readEn = 1'b0,
    output reg [3:0] regWriteSelect = 4'b0000,
    output reg writeEn = 1'b0,
    output reg [2:0] jumpCondition = 3'b000,
    output reg [2:0] aluOp = 3'b000,
    output reg [7:0] aluArgs = 8'h00,
    output reg [3:0] periphSelect = 4'b0000,
    output reg [3:0] periphReg = 4'b0000,
    output reg periphRead = 1'b0,
    output reg periphWrite = 1'b0,
    output reg periphExec = 1'b0,
    output reg [1:0] accumMuxSelect = 2'b00
  );
  
  // Instruction decoder behavior description
  // All outputs explicitly declared to prevent latching
  always @ (instrIn) begin
    
    // If it's a push instruction
    if(instrIn[15]) begin
      
      sysFlagNum[3:0] <= 4'h0;
      sysFlagVal <= 1'b0;
      sysFlagWrite <= 1'b0;
      pushVal[14:0] <= instrIn[14:0];
      regReadSelect[3:0] <= 4'b0000;
      readEn <= 1'b0;
      regWriteSelect[3:0] <= 4'b0010;
      writeEn <= 1'b1;
      jumpCondition[2:0] <= 3'b000;
      aluOp[2:0] <= 3'b000;
      aluArgs[7:0] <= 8'h00;
      periphSelect[3:0] <= 4'b0000;
      periphReg[3:0] <= 4'b0000;
      periphRead <= 1'b0;
      periphWrite <= 1'b0;
      periphExec <= 1'b0;
      accumMuxSelect[1:0] <= 2'b10;
      
    // If it's a standard instruction
    end else begin
    
      // Decode normal operations
      case (instrIn[14:12])
          
        // System
        3'b000: begin
        
          // Choose operation
          case(instrIn[11:8])
            
            // Execute system command
            4'b0001: begin
            
              // Choose command
              case(instrIn[7:0])
                
                // VN Mode ON: Sets flag 0 to true and performs a jump
                8'h00: begin
                  sysFlagNum[3:0] <= 4'h0;
                  sysFlagVal <= 1'b1;
                  sysFlagWrite <= 1'b1;
                  pushVal[14:0] <= 15'b000000000000000;
                  regReadSelect[3:0] <= 4'b0000;
                  readEn <= 1'b0;
                  regWriteSelect[3:0] <= 4'b0000;
                  writeEn <= 1'b0;
                  jumpCondition[2:0] <= 3'b111;
                  aluOp[2:0] <= 3'b000;
                  aluArgs[7:0] <= 7'b0000000;
                  periphSelect[3:0] <= 4'b0000;
                  periphReg[3:0] <= 4'b0000;
                  periphRead <= 1'b0;
                  periphWrite <= 1'b0;
                  periphExec <= 1'b0;
                  accumMuxSelect[1:0] <= 2'b00;
                end
                
                // VN Mode OFF: Sets flag 0 to false
                8'h01: begin
                  sysFlagNum[3:0] <= 4'h0;
                  sysFlagVal <= 1'b0;
                  sysFlagWrite <= 1'b1;
                  pushVal[14:0] <= 15'b000000000000000;
                  regReadSelect[3:0] <= 4'b0000;
                  readEn <= 1'b0;
                  regWriteSelect[3:0] <= 4'b0000;
                  writeEn <= 1'b0;
                  jumpCondition[2:0] <= 3'b000;
                  aluOp[2:0] <= 3'b000;
                  aluArgs[7:0] <= 8'h00;
                  periphSelect[3:0] <= 4'b0000;
                  periphReg[3:0] <= 4'b0000;
                  periphRead <= 1'b0;
                  periphWrite <= 1'b0;
                  periphExec <= 1'b0;
                  accumMuxSelect[1:0] <= 2'b00;
                end
                
                // Unused syscommands
                default: begin
                  sysFlagNum[3:0] <= 4'h0;
                  sysFlagVal <= 1'b0;
                  sysFlagWrite <= 1'b0;
                  pushVal[14:0] <= 15'b000000000000000;
                  regReadSelect[3:0] <= 4'b0000;
                  readEn <= 1'b0;
                  regWriteSelect[3:0] <= 4'b0000;
                  writeEn <= 1'b0;
                  jumpCondition[2:0] <= 3'b000;
                  aluOp[2:0] <= 3'b000;
                  aluArgs[7:0] <= 8'h00;
                  periphSelect[3:0] <= 4'b0000;
                  periphReg[3:0] <= 4'b0000;
                  periphRead <= 1'b0;
                  periphWrite <= 1'b0;
                  periphExec <= 1'b0;
                  accumMuxSelect[1:0] <= 2'b00;
                end
              endcase
            end
            
            // 0, 2-15: Unused operations
            default: begin
              sysFlagNum[3:0] <= 4'h0;
              sysFlagVal <= 1'b0;
              sysFlagWrite <= 1'b0;
              pushVal[14:0] <= 15'b000000000000000;
              regReadSelect[3:0] <= 4'b0000;
              readEn <= 1'b0;
              regWriteSelect[3:0] <= 4'b0000;
              writeEn <= 1'b0;
              jumpCondition[2:0] <= 3'b000;
              aluOp[2:0] <= 3'b000;
              aluArgs[7:0] <= 8'h00;
              periphSelect[3:0] <= 4'b0000;
              periphReg[3:0] <= 4'b0000;
              periphRead <= 1'b0;
              periphWrite <= 1'b0;
              periphExec <= 1'b0;
              accumMuxSelect[1:0] <= 2'b00;
            end
          endcase
        end
        
        // Copy
        3'b001: begin
          sysFlagNum[3:0] <= 4'h0;
          sysFlagVal <= 1'b0;
          sysFlagWrite <= 1'b0;
          pushVal[14:0] <= 15'b000000000000000;
          regReadSelect[3:0] <= instrIn[11:8];
          regWriteSelect[3:0] <= instrIn[7:4];
          readEn <= 1'b1;
          writeEn <= 1'b1;
          jumpCondition[2:0] <= 3'b000;
          aluOp[2:0] <= 3'b000;
          aluArgs[7:0] <= 8'h00;
          periphSelect[3:0] <= 4'b0000;
          periphReg[3:0] <= 4'b0000;
          periphRead <= 1'b0;
          periphWrite <= 1'b0;
          periphExec <= 1'b0;
          accumMuxSelect[1:0] <= 2'b00;
        end
        
        // Jump
        3'b010: begin
          sysFlagNum[3:0] <= 4'h0;
          sysFlagVal <= 1'b0;
          sysFlagWrite <= 1'b0;
          pushVal[14:0] <= 15'b000000000000000;
          regReadSelect[3:0] <= 4'b0011;
          readEn <= 1'b1;
          regWriteSelect[3:0] <= 4'b0001;
          writeEn <= 1'b1;
          jumpCondition[2:0] <= instrIn[11:9];
          aluOp[2:0] <= 3'b000;
          aluArgs[7:0] <= 8'h00;
          periphSelect[3:0] <= 4'b0000;
          periphReg[3:0] <= 4'b0000;
          periphRead <= 1'b0;
          periphWrite <= 1'b0;
          periphExec <= 1'b0;
          accumMuxSelect[1:0] <= 2'b00;
        end
        
        // ALU
        3'b011: begin
          sysFlagNum[3:0] <= 4'h0;
          sysFlagVal <= 1'b0;
          sysFlagWrite <= 1'b0;
          pushVal[14:0] <= 15'b000000000000000;
          regReadSelect[3:0] <= 4'b0000;
          readEn <= 1'b0;
          regWriteSelect[3:0] <= 4'b0010;
          writeEn <= 1'b1;
          jumpCondition[2:0] <= 3'b000;
          aluOp[2:0] <= instrIn[10:8];
          aluArgs[7:0] <= instrIn[7:0];
          periphSelect[3:0] <= 4'b0000;
          periphReg[3:0] <= 4'b0000;
          periphRead <= 1'b0;
          periphWrite <= 1'b0;
          periphExec <= 1'b0;
          accumMuxSelect[1:0] <= 2'b11;
        end
        
        // I/O
        3'b100: begin
          sysFlagNum[3:0] <= 4'h0;
          sysFlagVal <= 1'b0;
          sysFlagWrite <= 1'b0;
          pushVal[14:0] <= 15'b000000000000000;
          regReadSelect[3:0] <= 4'b0100;
          readEn <= 1'b1;
          regWriteSelect[3:0] <= 4'b0000;
          writeEn <= 1'b0;
          jumpCondition[2:0] <= 3'b000;
          aluOp[2:0] <= 3'b000;
          aluArgs[7:0] <= 8'h00;
          periphSelect[3:0] <= instrIn[11:8];
          periphReg[3:0] <= instrIn[7:4];
          periphRead <= ~instrIn[2];
          periphWrite <= instrIn[2];
          periphExec <= instrIn[3];
          accumMuxSelect[1:0] <= 2'b00;
        end
        
        // Opcodes 5-7: UNUSED
        default: begin 
          sysFlagNum[3:0] <= 4'h0;
          sysFlagVal <= 1'b0;
          sysFlagWrite <= 1'b0;
          pushVal[14:0] <= 15'b000000000000000;
          regReadSelect[3:0] <= 4'b0000;
          readEn <= 1'b0;
          regWriteSelect[3:0] <= 4'b0000;
          writeEn <= 1'b0;
          jumpCondition[2:0] <= 3'b000;
          aluOp[2:0] <= 3'b000;
          aluArgs[7:0] <= 8'h00;
          periphSelect[3:0] <= 4'b0000;
          periphReg[3:0] <= 4'b0000;
          periphRead <= 1'b0;
          periphWrite <= 1'b0;
          periphExec <= 1'b0;
          accumMuxSelect[1:0] <= 2'b00;
        end
        
      endcase
    end
  end
  
endmodule

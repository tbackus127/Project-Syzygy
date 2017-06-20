`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/19/2017 03:47:42 AM
// Design Name: 
// Module Name: SDController
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


module SDController(
    input clk,
    input [31:0] addr,
    input exec,
    input readEn,
    input writeEn,
    input blockMemMSB,
    input [15:0] dataFromBlockMem,
    input miso,
    inout [15:0] regData,
    output serialClockOut,
    output reg shiftBlockMemEn = 1'b0,
    output reg [15:0] dataToBlockMem = 16'h0000,
    output reg status = 1'b1,
    output blockMemLSB,
    output reg chipSelect = 1'b1,
    output mosi,
    output [7:0] debugOut,
    output [7:0] debugOut2
  );
  
  // Serial clock divider
  wire wSerialClock;
  reg clockSelect = 1'b0;
  wire wSlowClock;
  SDClockDivider sdclkdiv(
    .clkIn(clk),
    .clkOut(wSlowClock)
  );
  Mux2to1 clockMux(
    .aIn(wSlowClock),
    .bIn(clk),
    .sel(clockSelect),
    .out(wSerialClock)
  );
  
  assign serialClockOut = wSerialClock;
  
  // State Machine variables
  reg [3:0] state = 4'h0;
  reg [16:0] count = 16'h0000;
  reg [2:0] step = 3'h0;
  reg [47:0] command = 48'h000000000000;
  reg [15:0] response = 16'h0000;
  reg [15:0] error = 16'h0000;
  reg [15:0] data = 16'h0000;
  
  assign wCommandMSB = command[47];
  assign blockMemLSB = miso;
  assign debugOut[7:0] = {4'h0, state[3:0]};
  assign debugOut2[7:0] = {5'b00000, step[2:0]};
  
  // Select what we're outputting to the MOSI pin
  reg mosiUseReg = 1'b0;
  reg mosiSrcSel = 1'b0;
  reg mosiConstVal = 1'b1;
  wire wMosiMux;
  Mux2to1 mosiCmdMemMux(
    .aIn(wCommandMSB),
    .bIn(blockMemMSB),
    .sel(mosiSrcSel),
    .out(wMosiMux)
  );
  Mux2to1 mosiConstMux(
    .aIn(mosiConstVal),
    .bIn(wMosiMux),
    .sel(mosiUseReg),
    .out(mosi)
  );
  
  // Do state machine stuff
  always @ (posedge wSerialClock) begin
  
    case(state[3:0])
      
      // State 0 - Setup
      4'h0: begin
        count[15:0] <= 100;
        state[3:0] <= 1;
      end
      
      // State 1 - Flush bits
      4'h1: begin
        if(count[15:0] > 0)
          count[15:0] <= count[15:0] - 1;
        else
          state[3:0] <= 2;
      end
      
      // State 2 - Ready CMD0
      4'h2: begin
        command[47:0] <= 48'h400000000095;
        count[15:0] <= 48;
        step[2:0] <= 1;
        state[3:0] <= 3;
        mosiUseReg <= 1'b1;
        chipSelect <= 1'b0;
        //debugOut[15:0] <= 16'h0001;
      end
      
      
      
      
      // State 3 - Send Command
      4'h3: begin
        if(count[15:0] > 0) begin
          count[15:0] <= count[15:0] - 1;
          command[47:0] <= command[47:0] << 1;
        end else begin
          mosiUseReg <= 1'b0;
          state[3:0] <= 4;
          //debugOut[15:0] <= 16'h0002;
        end
      end
      
      // State 4 - Check for beginning of SD response (0)
      4'h4: begin
        if(miso == 1'b0) begin
          count[15:0] <= 7;
          state[3:0] <= 5;
          //debugOut[15:0] <= 16'h0003;
        end
      end
      
      // State 5 - Get SD response
      4'h5: begin
        if(count[6:0] == 0) begin
          error[15:0] <= response[15:0];
          chipSelect <= 1'b1;
          state[3:0] <= 6;
          //debugOut[15:0] <= 16'h0004;
        end else begin
          count[15:0] <= count[15:0] - 1;
          response[15:0] <= response[15:0] << 1;
          response[0] <= miso;
        end
      end
      
      
      
      // State 6 - Check Response
      4'h6: begin
        
        // Step 1 - Send CMD0
        if(step[2:0] == 1) begin
          
          // If there was an error at step 1, go back to sending CMD0
          if(error[15:0] != 0)
            state[3:0] <= 2;
          else
            state[3:0] <= 7;
          chipSelect <= 1'b0;
        
        // Step 2 - Send CMD8
        end else if(step[2:0] == 2) begin
          if(error[15:0] != 0)
            state[3:0] <= 7;
          else
            state[3:0] <= 8;
          chipSelect <= 1'b0;
          
        // Step 3 - Send CMD55
        end else if(step[2:0] == 3) begin
          if(error[15:0] != 0)
            state[3:0] <= 8;
          else
            state[3:0] <= 9;
          chipSelect <= 1'b0;
          
        // Step 4 - Send CMD41
        end else if(step[2:0] == 4) begin
          if(error[15:0] != 0) begin
            state[3:0] <= 8;
            chipSelect <= 1'b0;
          end else begin
            state[3:0] <= 10;
            chipSelect <= 1'b1;
            status <= 1'b0;
            step[2:0] <= 5;
            //debugOut[15:0] <= 16'h0007;
            clockSelect <= 1'b1;
          end
        
        // Step 6 - Send CMD17 (Read Single Block)
        end else if(step[2:0] == 6) begin
          if(error[15:0] != 0) begin
            state[3:0] <= 10;
            chipSelect <= 1'b1;
            status <= 1;
          end else begin
            state[3:0] <= 11;
            mosiSrcSel <= 1'b0;
            mosiUseReg <= 1'b0;
          end
        end
      end
      
      // State 7 - Send CMD8
      4'h7: begin
        command[47:0] <= 48'h48000001aa87;
        step[2:0] <= 2;
        state[3:0] <= 3;
        count[15:0] <= 48;
        mosiUseReg <= 1'b1;
        //debugOut[15:0] <= 16'h0005;
      end
      
      // State 8 - Send CMD55
      4'h8: begin
        command[47:0] <= 48'h7700000000ff;
        step[2:0] <= 3;
        state[3:0] <= 3;
        count[15:0] <= 48;
        mosiUseReg <= 1'b1;
        //debugOut[15:0] <= 16'h0006;
      end
      
      // State 9 - Send CMD41
      4'h9: begin
        command[47:0] <= 48'h6940000000ff;
        step[2:0] <= 4;
        state[3:0] <= 3;
        count[15:0] <= 48;
        mosiUseReg <= 1'b1;
        //debugOut[15:0] <= 16'h0006;
      end
      
      // State 10 - Wait for host command
      4'ha: begin
        if(exec == 1'b1) begin
        
          // Setup read from SD command
          if(readEn == 1'b1) begin
            chipSelect <= 1'b0;
            status <= 1'b1;
            count[15:0] <= 48;
            command[47:40] <= 8'h51;
            command[39:8] <= addr[31:0];
            command[7:0] <= 8'hff;
            state[3:0] <= 11;
            step[2:0] <= 6;
            
          // Setup write to SD command
          end else if (writeEn == 1'b1) begin
            chipSelect <= 1'b0;
            status <= 1'b1;
            count[15:0] <= 48;
            command[47:40] <= 8'h58;
            command[39:8] <= addr[31:0];
            command[7:0] <= 8'hff;
            mosiUseReg <= 1'b1;
            mosiSrcSel <= 1'b0;
            state[3:0] <= 11;
            step[2:0] <= 7;
          end
        end
      end
      
      // State 11 - Detect data token (0xFE)
      4'hb: begin
        if(miso == 1'b0) begin
          response[0] <= miso;
          
          // Check if the response is a valid data token
          if(response[7:0] == 8'hfe) begin
            shiftBlockMemEn <= 1'b1;
            count[15:0] <= 512;
            state[3:0] <= 12;
          end else begin
            state[3:0] <= 10;
            status <= 1;
            chipSelect <= 1'b1;
            mosiUseReg <= 1'b0;
            mosiSrcSel <= 1'b0;
          end
        end else begin
          response[15:0] <= response[15:0] << 1;
        end
      end
      
      // State 12 - Receive data
      4'hc: begin
        if(count[15:0] > 0) begin
          shiftBlockMemEn <= 1'b1;
        end else begin
          shiftBlockMemEn <= 1'b0;
          status <= 1'b0;
          state[3:0] <= 10;
          chipSelect <= 1'b1;
          mosiUseReg <= 1'b0;
          mosiSrcSel <= 1'b0;
        end
      end
      
      // State 15 - Send data
      4'hf: begin
        if(count[15:0] > 0) begin
          shiftBlockMemEn <= 1'b1;
        end else begin
          shiftBlockMemEn <= 1'b0;
          status <= 1'b0;
          state[3:0] <= 10;
          chipSelect <= 1'b1;
          mosiUseReg <= 1'b1;
          mosiSrcSel <= 1'b1;
        end
      end
      
      // Unknown state - Output nothing and set error to 0xFFFF
      default: begin
        state <= 4'h0;
        count <= 16'h0000;
        step <= 3'h0;
        command <= 48'h000000000000;
        response <= 16'h0000;
        error <= 16'hffff;
        data <= 16'h0000;
        chipSelect <= 1'b1;
        status <= 1'b1;
        //debugOut <= 16'hffff;
      end
      
    endcase
    
    // Get the SD response and shift it in
    response[0] <= miso;
    response[15:0] <= response[15:0] << 1;
  end
  
endmodule

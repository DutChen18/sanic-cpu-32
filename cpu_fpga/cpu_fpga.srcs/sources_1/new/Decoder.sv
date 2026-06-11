`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2026 03:32:54 PM
// Design Name: 
// Module Name: Decoder
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


module Decoder(
        input clk,
        input [31:0] instruction,
        input regs_awaiting_writeback [31:0], // Used to detect hazards
        output reg [4:0] sel_a,
        output reg [4:0] sel_b,
        output reg [6:0] opcode,
        output reg [15:0] imm16,
        output reg [19:0] imm20,
        output reg stall_fetch
    );
    
    always @(posedge clk) begin
        sel_a <= instruction[11:7];
        sel_b <= instruction[16:12];
        if (regs_awaiting_writeback[sel_a] == 0 && regs_awaiting_writeback[sel_b] == 0) begin
            stall_fetch <= 1'd0;
            opcode <= instruction[6:0];
            imm16 <= instruction[31:16];
            imm20 <= instruction[31:12];
        end
        else begin
            stall_fetch <= 1'd1;
            opcode <= 7'd0;
            imm16 <= 16'd0;
            imm20 <= 20'd0;
        end

    end
    
endmodule

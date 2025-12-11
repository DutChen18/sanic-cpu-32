`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2025 11:06:14 AM
// Design Name: 
// Module Name: processor_core
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


module processor_core(
        input CLK100MHZ,
        output [31:0] PERIPH_DATA_OUT,
        output [21:0] PERIPH_ADDR_OUT
    );
    
    reg [31:0] ROM [21:0];
    
    initial begin
        ROM[0] = 32'h0ffff063;
        ROM[1] = 32'h00000064;
    end
    
    wire [31:0] FLAGS_CU, ACC_CU, AUX_CU, IR_CU, MDR_OUT_BUS;
    wire [23:0] PC_OUT_BUS, MAR_OUT;
    wire bs_state, next_instruction, pc_write_enable;
    wire [1:0] cycle_cnt;
    wire [31:0] REG_READ_A, REG_READ_B;
    wire [3:0] ALU_OPCODE;
    wire MEM_WRITE_ENABLE, MDR_MEM_READ_ENABLE, MAR_CLEAR_ENABLE, MDR_CLEAR_ENABLE, REG_CLEAR_ENABLE;
    wire REG_WRITE_ENABLE_OUT, ALU_ENABLE, MAR_WRITE_ENABLE, MDR_WRITE_ENABLE, MDR_READ_ENABLE;
    wire [31:0] ALU_OPER_1, ALU_OPER_2, MDR_WRITE_DATA, REG_WRITE_DATA;
    wire [31:0] ALU_FLAGS, ALU_ACC, ALU_AUX, MEM_IR, MDR_IN_BUS;
    wire [23:0] PC_IN_BUS, MAR_IN_BUS;
    wire [23:0] PC_WRITE_DATA, MAR_WRITE_DATA;
    wire [4:0] REG_WRITE_SELECTOR, REG_READ_A_SELECTOR, REG_READ_B_SELECTOR;
    
    protected_reg32 FLAGS (
        .data_in (ALU_FLAGS),
        .CLK_IN (CLK100MHz),
        .write_enable (ALU_ENABLE),
        .reset (0),
        .data_out (FLAGS_CU)
    );
    protected_reg32 ACC (
        .data_in (ALU_ACC),
        .CLK_IN (CLK100MHz),
        .write_enable (ALU_ENABLE),
        .reset (0),
        .data_out (ACC_CU)
    );
    protected_reg32 AUX (
        .data_in (ALU_AUX),
        .CLK_IN (CLK100MHz),
        .write_enable (ALU_ENABLE),
        .reset (0),
        .data_out (AUX_CU)
    );
    protected_reg32 IR (
        .data_in (MEM_IR),
        .CLK_IN (CLK100MHz),
        .write_enable (NEXT_INSTRUCTION),
        .reset (0),
        .data_out (IR_CU)
    );
    protected_reg32 MDR (
        .data_in (MDR_IN_BUS),
        .CLK_IN (CLK100MHz),
        .write_enable (MDR_WRITE_ENABLE),
        .reset (MDR_CLEAR_ENABLE),
        .data_out (MDR_OUT_BUS)
    );
    protected_reg24 MAR (
        .data_in (MAR_IN_BUS),
        .CLK_IN (CLK100MHz),
        .write_enable (MAR_WRITE_ENABLE),
        .reset (MAR_CLEAR_ENABLE),
        .data_out (MAR_OUT)
    );
    protected_reg24 PC (
        .data_in (PC_IN_BUS),
        .CLK_IN (CLK100MHz),
        .write_enable (PC_WRITE_ENABLE),
        .reset (0),
        .data_out (PC_OUT_BUS)
    );
    Cycle_counter dev_cc (
        .write_enable (bs_state),
        .CLK_IN (CLK100MHz),
        .reset (next_instruction),
        .data_out (cycle_cnt)
    );
    control_unit dev_cu (
        .CLK_IN (CLK100MHz),
        .IR_IN (IR_CU),
        .CYCLE_IN (cycle_cnt),
        .PC_IN (PC_OUT_BUS),
        .REG_A_IN (REG_READ_A),
        .REG_B_IN (REG_READ_B),
        .MDR_IN (MDR_OUT_BUS),
        .ACC_IN (ACC_CU),
        .AUX_IN (AUX_CU),
        .FLAGS_IN (FLAGS_CU),
        .ALU_OP_OUT (ALU_OPCODE),
        .MEM_WRITE_ENABLE (MEM_WRITE_ENABLE),
        .MDR_MEM_READ_ENABLE (MDR_MEM_READ_ENABLE),
        .MAR_CLEAR_ENABLE (MAR_CLEAR_ENABLE),
        .MDR_CLEAR_ENABLE (MDR_CLEAR_ENABLE),
        .REG_CLEAR_ENABLE (REG_CLEAR_ENABLE),
        .REG_WRITE_ENABLE_OUT (REG_WRITE_ENABLE_OUT),
        .ALU_ENABLE (ALU_ENABLE),
        .MAR_WRITE_ENABLE (MAR_WRITE_ENABLE),
        .MDR_WRITE_ENABLE (MDR_WRITE_ENABLE),
        .MDR_READ_ENABLE (MDR_READ_ENABLE),
        .ALU_OPER_1_OUT (ALU_OPER_1),
        .ALU_OPER_2_OUT (ALU_OPER_2),
        .MDR_OUT (MDR_WRITE_DATA),
        .REG_WRITE_DATA_OUT (REG_WRITE_DATA),
        .PC_DATA_OUT (PC_IN_BUS),
        .MAR_OUT (MAR_IN_BUS),
        .REG_WRITE_SELECTOR_OUT (REG_WRITE_SELECTOR),
        .REG_READ_A_SELECTOR_OUT (REG_READ_A_SELECTOR),
        .REG_READ_B_SELECTOR_OUT (REG_READ_B_SELECTOR),
        .BOOTSTRAP_STATE (bs_state),
        .NEXT_INSTRUCTION_TRIGGER (next_intruction),
        .PC_WRITE_ENABLE (pc_write_enable)
    );
    RAM dev_ram (
        .CLK_IN (CLK100MHz),
        .ADDR_IN (MAR_OUT),
        .DATA_IN (MDR_OUT_BUS),
        .WRITE_ENABLE_IN (MEM_WRITE_ENABLE),
        .DATA_OUT (MDR_IN_BUS)
    );
    ALU dev_alu0 (
        .REG_A (ALU_OPER_1),
        .REG_B (ALU_OPER_2),
        .OP_SEL (ALU_OPCODE),
        .FLAGS (ALU_FLAGS),
        .ACC (ALU_ACC),
        .AUX (ALU_AUX)
    );
    register_file dev_rf0 (
        .REG_READ_SELECTOR_A (REG_READ_A_SELECTOR),
        .REG_READ_SELECTOR_B (REG_READ_B_SELECTOR),
        .REG_READ_DATA_A (REG_READ_A),
        .REG_READ_DATA_B (REG_READ_B),
        .REG_WRITE_SELECTOR (REG_WRITE_SELECTOR),
        .REG_WRITE_DATA_IN (REG_WRITE_DATA),
        .REG_WRITE_ENABLE (REG_WRITE_ENABLE_OUT),
        .CLK_IN (CLK100MHz)
    );
endmodule

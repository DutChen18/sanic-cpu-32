`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/26/2025 11:34:25 AM
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [31:0] REG_A,
    input [31:0] REG_B,
    input [3:0] OP_SEL,
    output [31:0] FLAGS,
    output [31:0] ACC,
    output [31:0] AUX
    );
    wire [31:0] add_out, sub_out, mul_out, upper_mul_out, div_out, rem_out, shl_out, shr_out, and_out, or_out, xor_out;
    wire add_carry, sub_carry;
    
    wire msb_out_and_a, invert_msb_a_and_b, msb_a_and_b, xor_msb_a_and_b, a_b_same_sign, is_add, same_and_not_add, xor_and_add;
    wire next_stage;
    wire final_stage;
    adder_32 d0 (
        .OP_1 (REG_A),
        .OP_2 (REG_B),
        .invert_2  (0),
        .Carry_in  (0),
        .Carry_out (add_carry),
        .Out (ACC)
     );
    adder_32 d1 (
        .OP_1 (REG_A),
        .OP_2 (REG_B),
        .invert_2  (1),
        .Carry_in  (0),
        .Carry_out (sub_carry),
        .Out (ACC)
     );
    multiplier_32 d2 (
        .OP_1 (REG_A),
        .OP_2 (REG_B),
        .UPPER_OUT (upper_mul_out),
        .LOWER_OUT (mul_out)
    );
    divider_32 d3 (
        .OP_1 (REG_A),
        .OP_2 (REG_B),
        .quo_out (div_out),
        .rem_out (rem_out)
    );
    ShiftLeft d4 (
        .OP_1 (REG_A),
        .shift_amount (REG_B),
        .out (shl_out)
    );
    ShiftRight d5 (
        .OP_1 (REG_A),
        .shift_amount (REG_B),
        .out (shr_out)
    );
    assign msb_out_and_a = ACC[31] ^ REG_A[31];
    assign msb_a_and_b = REG_A[31] & REG_B[31];
    assign invert_msb_a_and_b = !REG_A[31] & !REG_B[31];
    assign xor_msb_a_and_b = REG_A[31] ^ REG_B[31];
    assign a_b_same_sign = invert_msb_a_and_b | msb_a_and_b;
    assign same_and_not_add = (OP_SEL != 4'd0) & a_b_same_sign;
    assign xor_and_add = (OP_SEL == 4'd0) & xor_msb_a_and_b;
    assign next_stage = same_and_not_add | xor_and_add;
    assign ACC =    (OP_SEL == 4'd0) ? add_out : 
                    (OP_SEL == 4'd1) ? sub_out :
                    (OP_SEL == 4'd2) ? mul_out :
                    (OP_SEL == 4'd3) ? div_out :
                    (OP_SEL == 4'd4) ? REG_A & REG_B :
                    (OP_SEL == 4'd5) ? REG_A | REG_B :
                    (OP_SEL == 4'd6) ? REG_A ^ REG_B :
                    (OP_SEL == 4'd7) ? shl_out :
                    (OP_SEL == 4'd8) ? shr_out : 0;
    assign AUX = (OP_SEL == 4'd2)? upper_mul_out : (OP_SEL == 4'd3) ? rem_out : 0;
    assign FLAGS[0] = (OP_SEL == 4'd0) ? add_carry : sub_carry;
    assign FLAGS[1] = next_stage & msb_out_and_a;
    assign FLAGS[2] = ACC[31];
    assign FLAGS[3] = (ACC == 4'd0) ? 1 : 0;
    
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/26/2025 02:06:47 PM
// Design Name: 
// Module Name: adder_1
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


module adder_1(
    input OP_1,
    input OP_2,
    input Carry_in,
    output Carry_out,
    output Out
    );
    wire stage1;
    wire carry_stageA;
    wire carry_stageB;
    xor(stage_1, OP_1, OP_2);
    xor(Out, stage_1, Carry_in);
    and(carry_stageA, Carry_in, stage_1);
    and(carry_stageB, OP_1, OP_2);
    or(Carry_out, carry_stageA, carry_stageB);
endmodule

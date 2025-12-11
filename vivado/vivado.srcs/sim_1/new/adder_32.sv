`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/26/2025 02:01:10 PM
// Design Name: 
// Module Name: 32_bit_adder
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


module adder_32
    #(parameter N = 32)
    (
    input [31:0] OP_1,
    input [31:0] OP_2,
    input invert_2,
    input Carry_in,
    output Carry_out,
    output [31:0] Out
    );
    
    wire [0:31] input_2;
    assign input_2 = (invert_2 == 1) ? ~OP_2 : OP_2;

    wire [0:31] carry_bus;
    adder_1 adder0 (
        .OP_1 (OP_1[0]),
        .OP_2 (input_2[0]),
        .Carry_in (Carry_in),
        .Carry_out (carry_bus[0]),
        .Out (Out[0])
    );
    genvar i;
    
    generate
        for (i = 1; i < N; i = i + 1) begin
            adder_1 adderN (
                .OP_1 (OP_1[i]),
                .OP_2 (input_2[i]),
                .Carry_in (carry_bus[i-1]),
                .Carry_out (carry_bus[i]),
                .Out (Out[i])
             );
        end
    endgenerate
    assign Carry_out = carry_bus[31];
 
endmodule

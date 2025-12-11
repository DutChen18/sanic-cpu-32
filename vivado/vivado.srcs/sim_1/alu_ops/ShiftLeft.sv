`timescale 1ns / 1ps

module ShiftLeft(
        input [31:0] OP_1,
        input [31:0] shift_amount,
        output [31:0] out
    );
    assign out = OP_1 << shift_amount[4:0];
endmodule
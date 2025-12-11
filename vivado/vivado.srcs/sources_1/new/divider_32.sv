`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/26/2025 03:39:19 PM
// Design Name: 
// Module Name: divider_32
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


module divider_32(
        input [31:0] OP_1,
        input [31:0] OP_2,
        output [31:0] quo_out,
        output [31:0] rem_out
    );

    assign quo_out = OP_1 / OP_2;
    assign rem_out = OP_1 % OP_2;
endmodule

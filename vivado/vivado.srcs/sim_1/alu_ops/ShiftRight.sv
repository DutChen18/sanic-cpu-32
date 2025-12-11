`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/26/2025 03:45:52 PM
// Design Name: 
// Module Name: ShiftRight
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


module ShiftRight(
        input [31:0] OP_1,
        input [31:0] shift_amount,
        output [31:0] out
    );
    assign out = OP_1 >> shift_amount[4:0];
endmodule

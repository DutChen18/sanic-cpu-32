`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/26/2025 03:31:40 PM
// Design Name: 
// Module Name: multiplier_32
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


module multiplier_32(
        input [31:0] OP_1,
        input [31:0] OP_2,
        output [31:0] UPPER_OUT,
        output [31:0] LOWER_OUT
    );
    
    wire [63:0] stage_1;
    assign stage_1 = OP_1 * OP_2;
    assign UPPER_OUT = stage_1[63:32];
    assign LOWER_OUT = stage_1[31:0];
endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/26/2025 11:54:18 PM
// Design Name: 
// Module Name: register_file
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


module register_file(
        input [4:0] REG_READ_SELECTOR_A,
        input [4:0] REG_READ_SELECTOR_B,
        output [31:0] REG_READ_DATA_A,
        output [31:0] REG_READ_DATA_B,
        input [4:0] REG_WRITE_SELECTOR,
        input [31:0] REG_WRITE_DATA_IN,
        input REG_WRITE_ENABLE,
        input CLK_IN
    );
    reg [31:0] regN [5:0];
    
    assign REG_READ_DATA_A = regN[REG_READ_SELECTOR_A];
    assign REG_READ_DATA_B = regN[REG_READ_SELECTOR_B];

    always @(posedge CLK_IN) begin
        if(REG_WRITE_ENABLE) begin
            regN[REG_WRITE_SELECTOR] <= REG_WRITE_DATA_IN;
        end
    end
    
endmodule

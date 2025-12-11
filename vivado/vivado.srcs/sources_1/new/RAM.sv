`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2025 11:07:08 AM
// Design Name: 
// Module Name: RAM
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


module RAM(
        input CLK_IN,
        input [23:0] ADDR_IN,
        input [31:0] DATA_IN,
        input WRITE_ENABLE_IN,
        output [31:0] DATA_OUT
    );
    reg [31:0] data [23:0];
    
    assign DATA_OUT = data[ADDR_IN];
    
    always@(posedge CLK_IN) begin
        if(WRITE_ENABLE_IN) begin
            data[ADDR_IN] = DATA_IN;
        end
    end
endmodule

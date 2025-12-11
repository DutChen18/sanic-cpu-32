`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2025 11:49:08 AM
// Design Name: 
// Module Name: protected_reg24
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


module protected_reg24(
        input [23:0] data_in,
        input CLK_IN,
        input write_enable,
        input reset,
        output [23:0] data_out
    );
    reg [23:0] data;
    assign data_out = data;
    
    always@ (posedge CLK_IN) begin
        if(write_enable) begin
            data <= data_in;
        end else if (reset) begin
            data <= 31'd0;
        end
    end
endmodule

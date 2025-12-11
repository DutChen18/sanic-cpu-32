`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2025 11:25:38 AM
// Design Name: 
// Module Name: Cycle_counter
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


module Cycle_counter(
        input write_enable,
        input CLK_IN,
        input reset,
        output [1:0] data_out
    );
    reg [1:0] data;
    assign data_out = data;
    always@ (posedge CLK_IN) begin
        if(write_enable) begin
            data <= data + 1;
        end else if(reset) begin
            data <= 2'd0;
        end
    end
endmodule

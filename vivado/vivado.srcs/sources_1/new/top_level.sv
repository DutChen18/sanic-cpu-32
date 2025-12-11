`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2025 12:15:29 PM
// Design Name: 
// Module Name: top_level
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


module top_level(
        input CLK_IN
    );
    
        reg [31:0] DATA [21:0];
    wire [31:0] data_in;
    wire [23:0] addr_in;
    processor_core dev_core0 (
        .CLK100MHZ (CLK_IN),
        .PERIPH_DATA_OUT (data_in),
        .PERIPH_ADDR_OUT (addr_in)
    );
    
    always@ (CLK_IN) begin
        DATA[addr_in] = data_in;
    end
    
endmodule

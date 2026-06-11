`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2026 09:41:13 AM
// Design Name: 
// Module Name: RegisterFile
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


module RegisterFile
    #(parameter N=32)
    (
        input clk,
        input [N-1:0] data_in,
        output reg [N-1:0] a_out,
        output reg [N-1:0] b_out,
        input [4:0] write_selector,
        input [4:0] a_selector,
        input [4:0] b_selector
    );
    reg write_sel_mux [31:0];
    reg [31:0] write_data_mux [31:0];
    reg [31:0] out_mux [31:0];
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin
            RegisterN u0 (
                .input_bus (write_data_mux[i]),
                .output_bus (out_mux[i]),
                .write_enable (write_sel_mux[i]),
                .clock (clk)
            );
        end
    endgenerate
    
    always @(posedge clk) begin
        write_sel_mux[write_selector] <= 0;
        a_out <= out_mux[a_selector];
        b_out <= out_mux[b_selector];
    end
    
    always @(negedge clk) begin
        write_sel_mux[write_selector] <= 1;
        write_data_mux[write_selector] <= data_in;
    end
    
    initial begin
        integer j;
        for (j = 0; j < N; j = j + 1) begin
            write_sel_mux[j] = 0;
            write_data_mux[j] = 32'd0;
            out_mux[j] = 32'd0;
        end
        a_out = 32'd0;
        b_out = 32'd0;
    end
endmodule

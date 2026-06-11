`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2026 12:08:37 PM
// Design Name: 
// Module Name: tb_regfile
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


module tb_regfile;
    
    reg clk;
    reg [31:0] data_in;
    reg [4:0] write_sel, a_sel, b_sel;
    reg [31:0] returned_value;
    wire [31:0] a_out, b_out;
    
    RegisterFile rf (
        .clk (clk),
        .data_in (data_in),
        .a_out (a_out),
        .b_out (b_out),
        .write_selector (write_sel),
        .a_selector (a_sel),
        .b_selector (b_sel)
    );
    
    
    task write_and_readback (input [4:0] register_target, input [31:0] value, output [31:0] retval);
        data_in = value;
        write_sel = register_target;
        a_sel = register_target;
        #20;
        retval = a_out;
    endtask
    
    task read (input [4:0] register_target, output [31:0] retval);
    
        a_sel = register_target;
        #10;
        retval = a_out;
    endtask
    initial begin
        clk = 1'd0;
        data_in = 32'd0;
        write_sel = 5'd0;
        a_sel = 5'd0;
        b_sel = 5'd0;
        write_and_readback(5'd0, 32'hdeadbeef, returned_value);
        $display("Register: %d, Expected value: %h, Returned value: %h", 5'd0, 32'hdeadbeef, returned_value);
        write_and_readback(5'd0, 32'h1234abcd, returned_value);
        $display("Register: %d, Expected value: %h, Returned value: %h", 5'd0, 32'h1234abcd, returned_value);
        write_and_readback(5'd1, 32'habcd1234, returned_value);
        $display("Register: %d, Expected value: %h, Returned value: %h", 5'd1, 32'habcd1234, returned_value);
        read(5'd0, returned_value);
        $display("Register: %d, Expected value: %h, Returned value: %h", 5'd0, 32'h1234abcd, returned_value);
    end
    
    always begin
        #5 clk = ~clk;
    end
endmodule

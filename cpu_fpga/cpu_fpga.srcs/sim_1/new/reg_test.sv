`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/26/2026 09:22:21 AM
// Design Name: 
// Module Name: reg_test
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


module reg_test;

    reg clk, write_enable, output_enable;
    reg [31:0] data_in;
    wire [31:0] data_out;
    
    RegisterN reg0 (
        .input_bus (data_in),
        .output_bus (data_out),
        .write_enable (write_enable),
        .output_enable (output_enable),
        .clock (clk)
    );
    
    task test1;
        #10;
        write_enable = 1'd1;
        #10;
        write_enable = 1'd0;
        output_enable = 1'd1;
        #10;
        $display ("Register value: %h", data_out);
        output_enable = 1'd0;
        data_in = 32'hDEADBEEF;
        write_enable = 1'd1;
        #10;
        output_enable = 1'd1;
        write_enable = 1'd0;
        #10;
        $display ("Register value: %h", data_out);
    endtask
    initial begin
        clk = 1'd0;
        write_enable = 1'd0;
        output_enable = 1'd0;
        data_in = 32'd1234;
        test1();
    end
    always begin
        #5 clk = ~clk;
    end
endmodule

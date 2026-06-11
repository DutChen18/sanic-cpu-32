`timescale 1ns / 1ps


module RegisterN(
        input [31:0] input_bus,
        output [31:0] output_bus,
        input write_enable,
        input clock
    );
    reg [31:0] data;

    assign output_bus = data;

    always @(posedge clock) begin
        if (write_enable) begin
            data <= input_bus;
        end

    end


endmodule

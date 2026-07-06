`timescale 1ns / 1ps

//write_back stage
module write_back
(
    input clk, rst,
    input mem_to_reg,
    input[31:0] read_data, alu_in,
    output[31:0] result
);

    assign result = mem_to_reg ? read_data : alu_in;
    
endmodule

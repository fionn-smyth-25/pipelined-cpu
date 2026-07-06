`timescale 1ns / 1ps

//memeory stage
//handles data memory
module memory
(
    input clk, rst,
    input mem_write,
    input[4:0] write_reg,
    input[31:0] alu_in, write_data,
    output[4:0] write_reg_out,
    output[31:0] read_data, alu_out
);

    assign alu_out = alu_in;
    assign write_reg_out = write_reg;

    //data memory
    dmem d0 (clk, rst, mem_write, alu_in, write_data, read_data);
    
endmodule

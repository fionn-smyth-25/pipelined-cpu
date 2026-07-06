`timescale 1ns / 1ps

//execute / memory pipeline register
module exe_mem_reg
(
    input clk, rst,
    input reg_write, mem_to_reg, mem_write,
    input[4:0] write_reg,
    input[31:0] alu_in, write_data,
    output reg reg_write_out , mem_to_reg_out, mem_write_out,
    output reg[4:0] write_reg_out,
    output reg[31:0] alu_out, write_data_out
);

    always @ (posedge clk) begin
        if (rst) begin
            reg_write_out <= 1'b0; 
            mem_to_reg_out <= 1'b0;
            mem_write_out <= 1'b0;
            write_reg_out <= 5'b0;
            alu_out <= 32'b0;
            write_data_out <= 32'b0;
        end
        else begin
            reg_write_out <= reg_write; 
            mem_to_reg_out <= mem_to_reg;
            mem_write_out <= mem_write;
            write_reg_out <= write_reg;
            alu_out <= alu_in;
            write_data_out <= write_data;
        end   
    end
endmodule

`timescale 1ns / 1ps

module idecode_exe_reg
(
    input clk, rst, 
    input clr, //hazard unit flush
    input reg_write, mem_to_reg, mem_write, //control unit
    input[2:0] alu_control, //control unit
    input alu_src, reg_dst, //control unit
    input[31:0] reg_data_1, reg_data_2, //reg file
    input[4:0] rs, rt, rd, 
    input[31:0] sign_imm,
    output reg reg_write_out, mem_to_reg_out, mem_write_out,
    output reg[2:0] alu_control_out,
    output reg alu_src_out, reg_dst_out, 
    output reg[4:0] rs_out, rt_out, rd_out,
    output reg[31:0] reg_data_1_out, reg_data_2_out, sign_imm_out
);
    
    always @ (posedge clk) begin
        if (rst || clr) begin
            reg_write_out <= 1'b0;
            mem_to_reg_out <= 1'b0;
            mem_write_out <= 1'b0;
            alu_control_out <= 3'b0;
            alu_src_out <= 1'b0;
            reg_dst_out <= 1'b0;
            rs_out <= 5'b0;
            rt_out <= 5'b0;
            rd_out <= 5'b0;
            reg_data_1_out <= 32'b0;
            reg_data_2_out <= 32'b0;
            sign_imm_out <= 32'b0;
        end
        else begin
            reg_write_out <= reg_write;
            mem_to_reg_out <= mem_to_reg;
            mem_write_out <= mem_write;
            alu_control_out <= alu_control;
            alu_src_out <= alu_src;
            reg_dst_out <= reg_dst;
            rs_out <= rs;
            rt_out <= rt;
            rd_out <= rd;
            reg_data_1_out <= reg_data_1;
            reg_data_2_out <= reg_data_2;
            sign_imm_out <= sign_imm;            
        end
    end
    
endmodule

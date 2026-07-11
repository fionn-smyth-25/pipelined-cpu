`timescale 1ns / 1ps

//instruction fetch / instruction decode pipleine register
module ifetch_idecode_reg
(
    input clk, rst,
    input en, //from hazard unit
    input clr, //from control unit
    input[31:0] pc, //current pc location plus 4
    input[31:0] instr, //output from imem @ current 
    output reg[31:0] instr_out,
    output reg[31:0] pc_out 
);

    //holds value unless en high
    //force hold value
    //clr allows incorrectly fetched instructions to be flushed when a branch is taken
    always @ (posedge clk) begin
        if (rst || clr) begin
            instr_out <= 32'b0;
            pc_out <= 32'b0;
        end
        else if (!en) begin
            instr_out <= instr;
            pc_out <= pc;
        end
    end   
  
endmodule

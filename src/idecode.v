`timescale 1ns / 1ps

//instruction decode stage
//handles reg file and branch logic
module idecode
(
    input clk, rst,
    input[31:0] instr,
    input[31:0] pc,
    input fowardA, fowardB, //from hazard unit
    input reg_write,
    input[31:0] alu_in,
    input[4:0] write_addr,
    input[31:0] write_data,
    output[4:0] rs, rt, rd,
    output[31:0] sign_imm,
    output[31:0] reg_data_1, reg_data_2,
    output[31:0] pc_branch,
    output equal
);

    //forward the most recent ALU result to the branch comparator
    //when a branch depends on a value that has not yet been written back to the register file
    //resolves RAW hazards for branch comparisons.
    wire equal_1, equal_2;
    assign equal_1 = fowardA ? alu_in : reg_data_1;
    assign equal_2 = fowardB ? alu_in : reg_data_2;
    assign equal = (equal_1 == equal_2);

    //decode
    assign rs = instr[25:21];
    assign rt = instr[20:16];
    assign rd = instr[15:11];
    //extend 16 bit immediate value to 32 bit (MSB gets extended)
    assign sign_imm = {{16{instr[15]}}, instr[15:0]};
    
    //shift sign_imm left by 2 and add to pc for branch logic
    assign pc_branch = pc + (sign_imm << 2);

    //reg file
    regfile rf0 (clk, rst, reg_write, rs, rt, write_addr, write_data, reg_data_1, reg_data_2);
endmodule

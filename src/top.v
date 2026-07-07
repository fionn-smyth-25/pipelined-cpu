`timescale 1ns / 1ps

//top module for pipeline cpu
module top
(
    input clk, rst
);
    
    //hazard unit
    wire branchD, reg_writeE, mem_to_regE, reg_writeM, mem_to_regM, reg_writeW;
    wire stallF, stallD, forwardAD, forwardBD, flushE, forwardAE, forwardBE;  
    hazard_unit h0 (clk, rst, branchD, reg_writeE, mem_to_regE, reg_writeM, mem_to_regM, reg_writeW,
                    rsD, rtD, rsE, rtE, write_regE, write_regM, write_regW, 
                    stallF, stallD, forwardAD, forwardBD, flushE, forwardAE, forwardBE);
    
    //control unit
    wire reg_writeD, mem_writeD, reg_dstD, alu_srcD, mem_to_regD, pc_srcD, jumpD;
    wire[2:0] alu_controlD;
    control_unit c0 (instrD, reg_writeD, mem_writeD, reg_dstD, alu_srcD, mem_to_regD, pc_srcD, jumpD, alu_controlD);
    
    //datapath
    //fetch stage
    wire pc_write, branch_control;
    wire[31:0] branch_dest, pc_plus4, instr, instrD, pc_plus4D;
    ifetch d0 (clk, rst, pc_write, branch_control, branch_dest, pc_plus4, instr);    
    
    //decode stage
    wire equal;
    wire[4:0] rsD, rtD, rdD;
    wire[31:0] sign_imm, reg_data_1, reg_data_2, pc_branch;
    ifetch_idecode_reg d1 (clk, rst, stallD, pc_srcD, pc_plus4, instr, instrD, pc_plus4D);
    idecode d2 (clk, rst, instrD, pc_plus4D, forwardAD, forwardBD, reg_writeW, alu_outM, write_regW, resultW, 
                rsD, rtD, rdD, sign_imm, reg_data_1, reg_data_2, pc_branch, equal);
                    
    //execute stage
    wire reg_writeE, mem_writeE, reg_dstE, alu_srcE, mem_to_regE;
    wire[2:0] alu_controlE;
    wire[4:0] rsE, rtE, rdE;    
    wire[31:0] reg_data_1E, reg_data_2E, sign_immE;
    wire[31:0] alu_outE, write_dataE, write_regE;
    idecode_exe_reg d3 (clk, rst, flushE, reg_writeD, mem_to_regD, mem_writeD, alu_controlD, alu_srcD, reg_dstD, 
                        reg_data_1, reg_data_2, rs, rt, rd, sign_imm, 
                        reg_writeE, mem_to_regE, mem_writeE, alu_controlE, alu_srcE, reg_dstE, rsE, rtE, rdE,
                        reg_data_1E, reg_data_2E, sign_immE);
    execute d4 (clk, rst, forwardAE, forwardBE, alu_controlE, alu_srcE, reg_dstE, reg_data_1E, reg_data_2E, rsE, rtE, rdE,
                sign_immE, alu_outM, resultW, alu_outE, write_dataE, write_regE);
    
    //memory stage
    wire reg_writeM, mem_to_regM, mem_writeM;
    wire[4:0] write_regM;
    wire[31:0] alu_outM, write_dataM, read_dataM;
    exe_mem_reg d5 (clk, rst, eg_writeE, mem_to_regE, mem_writeE, write_regE, alu_outE, write_dataE,
                    reg_writeM, mem_to_regM, mem_writeM, write_regM, alu_outM, write_dataM);
    memory d6 (clk, rst, mem_writeM, write_regM, alu_outM, write_dataM, read_dataM);
    
    //writeback stage
    wire mem_to_regW;
    wire[4:0] write_regW;
    wire[31:0] read_dataW, alu_outW, resultW; 
    mem_write_back_reg d7 (clk, rst, reg_writeM, mem_to_regM, write_regM, alu_outM, read_dataM, reg_writeW, mem_to_regW, write_regW, alu_outW, read_dataW);
    write_back d8 (clk, rst, mem_to_regW, read_dataW, alu_outW, resultW);
    
endmodule

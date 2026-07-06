`timescale 1ns / 1ps

//top module for pipeline cpu
module top
(
    input clk, rst
);

    wire pc_write, branch_control;
    wire[31:0] branch_dest, pc_plus4, instr;

    //datapath
    ifetch d0 (clk, rst, pc_write, branch_control, branch_dest, pc_plus4, instr);
    ifetch_idecode_reg d1 ();
    idecode d2 ();
    idecode_exe_reg d3 ();
    execute d4 ();
    exe_mem_reg d5 ();
    memory d6 ();
    mem_write_back_reg d7 ();
    write_back d8 ();
    
    //control unit
    control_unit c0 ();
    
    //hazard unit
    hazard_unit h0 ();
endmodule

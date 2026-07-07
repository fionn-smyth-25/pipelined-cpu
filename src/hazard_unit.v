`timescale 1ns / 1ps

module hazard_unit
(
    input clk, rst, 
    input branchD,
    input reg_writeE, mem_to_regE, reg_writeM, mem_to_regM,  reg_writeW,
    input[4:0] rsD, rtD, rsE, rtE, write_regE, write_regM, write_regW, 
    output stallF, stallD, forwardAD, forwardBD, flushE, forwardAE, forwardBE   
);
    
endmodule

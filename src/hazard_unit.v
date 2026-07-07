`timescale 1ns / 1ps

module hazard_unit
(
    input clk, rst, 
    input branchD,
    input reg_writeE, mem_to_regE, reg_writeM, mem_to_regM,  reg_writeW,
    input[4:0] rsD, rtD, rsE, rtE, write_regE, write_regM, write_regW, 
    output reg stallF, stallD, forwardAD, forwardBD, flushE, forwardAE, forwardBE   
);

    always @ (posedge clk) begin
        if (rst) begin
            stallF <= 1'b0;
            stallD <= 1'b0;
            forwardAD <= 1'b0;
            forwardBD <= 1'b0;
            flushE <= 1'b0;
            forwardAE <= 1'b0;
            forwardBE <= 1'b0;
        end
    end
    
endmodule

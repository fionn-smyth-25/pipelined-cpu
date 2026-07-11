`timescale 1ns / 1ps

module hazard_unit
(
    input clk, rst, 
    input branchD,
    input reg_writeE, mem_to_regE, reg_writeM, mem_to_regM,  reg_writeW,
    input[4:0] rsD, rtD, rsE, rtE, write_regE, write_regM, write_regW, 
    output reg stallF, stallD, forwardAD, forwardBD, flushE, 
    output reg[1:0] forwardAE, forwardBE   
);

    reg lwstall, branchstall;

    always @ (posedge clk) begin
        if (rst) begin
            stallF <= 1'b0;
            stallD <= 1'b0;
            forwardAD <= 1'b0;
            forwardBD <= 1'b0;
            flushE <= 1'b0;
            forwardAE <= 2'b0;
            forwardBE <= 2'b0;
        end
        
        //fowarding logic
        //never foward zero reg
        //will foward if a write will occur to a dest reg that matches the src reg
        
        if ((rsE != 0) & (rsE == write_regM) & reg_writeM) forwardAE = 2'b10;
        else if ((rsE != 0) & (rsE == write_regW) & reg_writeW) forwardAE = 2'b01;
        else forwardAE = 2'b00;
        
        if ((rtE != 0) & (rtE == write_regM) & reg_writeM) forwardAE = 2'b10;
        else if ((rtE != 0) & (rtE == write_regW) & reg_writeW) forwardAE = 2'b01;
        else forwardAE = 2'b00;
        
        forwardAD = (rsD != 0) & (rsD == write_regM) & reg_writeM;
        forwardBD = (rtD != 0) & (rtD == write_regM) & reg_writeM;
        
        //stall logic
        
        lwstall = ((rsD == rtE) | (rtD == rtE)) & mem_to_regE;
        branchstall = (branchD & reg_writeE & (write_regE == rsD | write_regE == rtD))
                    | (branchD & mem_to_regM & (write_regM == rsD | write_regM == rtD));
        
        stallF = lwstall | branchstall;
        stallD = lwstall | branchstall;
        flushE = lwstall | branchstall;
        
    end
    
endmodule

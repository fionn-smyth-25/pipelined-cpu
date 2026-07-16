`timescale 1ns / 1ps

//instruction fetch stage
//handles program counter and instruction memory
module ifetch
(
    input clk, rst, 
    input pc_write, //hazard unit
    input pc_src, //selects whether pc should branch
    input jump, //selects wheter pc should jump
    input[25:0] jump_addr, //jump address
    input[31:0] branch_addr, //pc branch dest
    output[31:0] pc_plus4, //current pc location plus 4
    output[31:0] instr //output from imem @ current pc
);

    reg[31:0] pc; //program counter
    wire[31:0] pc_branch, pc_jump, j_addr_extended;
    //out of bounds protection -> only 256 instructions stored in memory (loops to zero)
    assign pc_plus4 = pc + 32'd4;
    
    //shift 26 bit jump address left by two and add upper four bits from pc
    assign j_addr_extended = {pc_plus4[31:28],(jump_addr << 2)};
    
    //mux 1 (beq)
    assign pc_branch = pc_src ? branch_addr : pc_plus4;
    //mux 2 (jump)
    assign pc_jump = jump ? jump_addr : pc_branch;
    
    //program counter
    always @ (posedge clk) begin
        if (rst) pc <= 32'b0; 
        else if (!pc_write) pc <= pc_jump;
    end
    
    //instruction memory
    imem im0 (pc, instr);
endmodule

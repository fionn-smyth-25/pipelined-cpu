`timescale 1ns / 1ps

//instruction fetch stage
//handles program counter and instruction memory
module ifetch
(
    input clk, rst, 
    input pc_write, //hazard unit
    input branch_control, //selects whether pc should jump
    input[31:0] branch_dest, //pc jump dest
    output[31:0] pc_plus4, //current pc location plus 4
    output[31:0] instr //output from imem @ current pc
);

    reg[31:0] pc; //program counter
    wire[31:0] pc_next;
    assign pc_plus4 = pc + 32'd4;
    assign pc_next = branch_control ? branch_dest : pc_plus4;
    
    //program counter
    always @ (posedge clk) begin
        if (rst) pc <= 32'b0; 
        else if (!pc_write) pc <= pc_next;
    end
    
    //instruction memory
    imem im0 (pc, instr);
endmodule

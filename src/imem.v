`timescale 1ns / 1ps

//instruction memory
//takes input address and outputs instruction at that location
module imem
(
    input[31:0] addr,
    output[31:0] instr
);

    reg[31:0] imem[255:0]; //256 instruction registers
    
    assign instruction = imem[addr];
    
    //load test program
    initial begin
    end
    
endmodule

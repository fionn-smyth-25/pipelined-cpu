`timescale 1ns / 1ps

//instruction memory
//takes input address and outputs instruction at that location
module imem
(
    input[31:0] addr,
    output[31:0] instr
);

    reg[31:0] imem[255:0]; //256 instruction registers
    
    assign instr = imem[addr];
    
    //load test program
    initial begin
        for (integer i = 0; i < 256; i = i + 1) begin
            //            op     rs    rt    imm
            imem[i] = 32'b001000_00000_00001_0000000000000001;
        end
    end
    
endmodule

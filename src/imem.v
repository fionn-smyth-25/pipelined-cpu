`timescale 1ns / 1ps

//instruction memory
//takes input address and outputs instruction at that location
module imem
(
    input[31:0] addr,
    output[31:0] instr //instruction word
);

    reg[31:0] imem[255:0]; //256 instruction registers
    wire[7:0] word_addr;
    integer i;
    
    //word adressing (ignore bottom two bits)
    assign word_addr = addr[9:2];
    
    assign instr = imem[word_addr];
    
    //load test program
    initial begin
        for (i = 0; i < 256; i = i + 1) begin
            imem[i] = 32'b0;
        end
        $readmemh("/hosthome/fpga/vivado_projecrs/pipelined_processor/pipelined_processor.srcs/sources_1/imports/programs/test_prog.mem", imem);
    end
    
endmodule

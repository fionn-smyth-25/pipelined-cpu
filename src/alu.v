`timescale 1ns / 1ps

//arithmetic logic unit
module alu
(
    input [31:0] a, b,
    input[2:0] fxn, //control
    output reg [31:0] c
);

    always @* begin
        case (fxn)
            3'b010: c = a + b; 
            3'b110: c = a - b; 
            3'b000: c = a & b; 
            3'b001: c = a | b; 
            3'b111: c = a; 
            default: c = 0;
        endcase
    end
endmodule

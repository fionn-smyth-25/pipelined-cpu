`timescale 1ns / 1ps

module cpu_tb;

    logic clk, rst;
    
    top t0 (clk, rst);
    
    //clk period (ns)
    parameter T = 2;
    
    always begin
        clk <= 1'b1;
        #(T/2);
        clk <= 1'b0;
        #(T/2);
    end
    
    initial begin
        rst <= 1'b1;
        #(T * 5);
        rst <= 1'b0;
    end
    
endmodule

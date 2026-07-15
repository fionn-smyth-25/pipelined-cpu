`timescale 1ns / 1ps

//data memory
module dmem
(
    input clk, rst, write_en,
    input[31:0] addr, write_data,
    output[31:0] read_data
);

    reg[31:0] d_mem[255:0];
    integer i;
    
    assign read_data = d_mem[addr];
    
    always @ (posedge clk) begin
        if (rst) begin
            for (i = 0; i < 256; i = i + 1) begin
                d_mem[i] <= 32'b0;
            end   
        end
        if (write_en) begin
            d_mem[addr] = write_data;
        end
    end
endmodule

`timescale 1ns / 1ps

//data memory
module dmem
(
    input clk, rst, write_en,
    input[31:0] addr, write_data,
    output[31:0] read_data
);

    reg[31:0] d_mem[255:0];
    wire[7:0] word_addr;
    integer i;
    
    //word adressing (ignore bottom two bits)
    assign word_addr = addr[9:2];
    
    assign read_data = d_mem[word_addr];
    
    always @ (posedge clk) begin
        if (rst) begin
            for (i = 0; i < 256; i = i + 1) begin
                d_mem[i] <= 32'b0;
            end   
        end
        else if (write_en) begin
            d_mem[word_addr] <= write_data;
        end
    end
endmodule

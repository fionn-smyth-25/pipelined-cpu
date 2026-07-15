`timescale 1ns / 1ps

//register file
module regfile
(
    input clk, rst, write_en,
    input[4:0] src_addr_1, src_addr_2, dest_addr,
    input[31:0] write_data,
    output[31:0] reg_data_1, reg_data_2 
);

    //32 registers each 32 bits wide
    reg[31:0] regs[0:31];
    
    integer i;
    
    //load data from up to two selected registers
    //INDEPENDENT OF CLK
    //If the address changes, the new data appears at the output after some propagation delay
    assign reg_data_1 = regs[src_addr_1];
    assign reg_data_2 = regs[src_addr_2];
    
    //write data to selected register
    //synchronous active high reset
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1) begin
                regs[i] <= 32'b0;
            end
        end
        else if (write_en) begin
            //never write to zero reg
            if (dest_addr != 5'b0) begin
                //debug
                $display(
                    "REG WRITE: r%0d <= %d at time %0t",
                    dest_addr,
                    write_data,
                    $time
                );
                
                regs[dest_addr] <= write_data;
            end
        end
    end
endmodule

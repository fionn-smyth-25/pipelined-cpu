`timescale 1ns / 1ps

//execute stage
//handles alu logic
module execute
(
    input clk, rst, 
    input[1:0] forwardA, forwardB, //from hazard unit
    input[2:0] alu_control, //control unit
    input alu_src, reg_dst, //control unit
    input[31:0] reg_data_1, reg_data_2, //reg file
    input[4:0] rs, rt, rd, 
    input[31:0] sign_imm,
    input[31:0] alu_out_in, result, //from memory stage and writeback stage
    output[31:0] alu_out,
    output reg[31:0] write_data,
    output[4:0] write_reg
);

    reg[31:0] a, b;
    
    //2 to 1 mux
    assign write_reg = reg_dst ? rd : rt;

    //3 to 1 mux for forwarding
    //originally had clocked logic here which was messing with execute timing
    //also using a mix of <= and = which was bad
    always @ (*) begin 
            case (forwardA)
                2'b00: a = reg_data_1;
                2'b01: a = result;
                2'b10: a = alu_out_in;
                default: a = reg_data_1;
            endcase
            case (forwardB)
                2'b00: write_data = reg_data_2;
                2'b01: write_data = result;
                2'b10: write_data = alu_out_in;
                default: write_data = reg_data_2;
            endcase
            //final 2 to 1 mux
            b =  alu_src ? sign_imm : write_data;  
    end

    //alu
    alu a0 (a, b, alu_control, alu_out);
endmodule

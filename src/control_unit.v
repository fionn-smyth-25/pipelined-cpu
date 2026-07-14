`timescale 1ns / 1ps

module control_unit
(
    input[31:0] instruction,
    input equal,
    output reg_write, mem_write, reg_dst, alu_src, mem_to_reg, pc_src, jump, branch,
    output reg[2:0] alu_control
);
    
    wire[1:0] alu_op;
    wire[5:0] func, opcode;
    reg[8:0] controls;
    
    assign func = instruction[5:0];
    assign opcode = instruction[31:26];
    
    assign reg_write = controls[8];
    assign reg_dst = controls[7];
    assign alu_src = controls[6];
    assign branch = controls[5];
    assign mem_write = controls[4];
    assign mem_to_reg = controls[3];
    assign jump = controls[2];
    assign alu_op = controls[1:0];
    
    assign pc_src = (branch & equal);
    
    always @* begin      
        //main decoder
        case (opcode)
            6'b000000: begin //signals that instruction is R-Type
                controls = 9'b110000010;
            end
            6'b100011: begin //LW (I-Type)
                controls = 9'b101001000;
            end       
            6'b101011: begin //SW (I-Type)
                controls = 9'b001010000;
            end
            6'b000100: begin //BEQ (I-Type)
                controls = 9'b000100001;
            end
            6'b001000: begin //ADDI (I-Type)
                controls = 9'b101000000;
            end           
            6'b000010: begin //JMP (J-Type)
                controls = 9'b000000100;
            end
            default: begin //illegal op -> no op
                controls = 9'b000000000;
            end 
        endcase
        
        //alu decoder
        case (alu_op)
            2'b00: begin
                alu_control <= 3'b010; //add
            end
            2'b01: begin
                alu_control <= 3'b110; //sub
            end
            default: begin
                case (func) //R-Type
                    6'b100000: begin
                        alu_control <= 3'b010; //add                    
                    end
                    6'b100010: begin
                        alu_control <= 3'b110; //sub
                    end
                    6'b100100: begin
                        alu_control <= 3'b000; //and
                    end    
                    6'b100101: begin
                        alu_control <= 3'b001; //or
                    end
                    6'b101010: begin
                        alu_control <= 3'b111; //slt
                    end
                    default: begin
                        alu_control <= 3'bxxx; //illegal
                    end                   
                endcase
            end
        endcase
    end
endmodule

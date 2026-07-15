# Pipelined MIPS CPU
A 32-bit five-stage pipelined MIPS processor implemented in Verilog. This project was developed to explore modern processor design by implementing a complete five-stage pipelined MIPS processor in Verilog. The design focuses on instruction-level parallelism, hazard handling, forwarding logic, and modular hardware design.
## Features
- Five-stage instruction pipeline (IF, ID, EX, MEM, WB)
- Hazard detection unit
- Data forwarding
- Branch and jump support
- 32 general-purpose registers
- 256-word instruction and data memories
- 10 implemented instructions
## Acknowledgements 
Heavily inspired by: Digital Design and Computer Architecture, 2nd Edition written by David Money Harris and Sarah L. Harris.
# What makes a CPU pipelined?
Pipelining here refers to instruction pipelining. It divides instructions into a series of steps which can be split up and performed in parallel. This aims to keep all portions of the processor occupied to increase throughput. A typical five stage pipeline consists of five stages:

- **IF (Instruction Fetch)** - fetch instruction from the instruction memory using the program counter.
- **ID (Instruction Decode)** - decode instruction.
- **EX (Execute)** - execute instruction using ALU / bit shifter.
- **MEM (Memory access)** - write results to the data memory if needed.
- **WB (Register write back)** - write results back to register file.

This is achieved using pipeline registers. Pipeline registers store important values in between stages, to facilitate multiple instructions simultaneously. Four pipeline registers are inserted between each stage in the data-path.

```
Time (ns)      0  10  20  30  40  50  60
Instruction 1  IF ID  EX  MEM WB
Instruction 2     IF  ID  EX  MEM WB
Instruction 3         IF  ID  EX  MEM WB
```

*Example of pipelined data timing*

At time zero, the first instruction is fetched from memory, and stored in the pipeline register. Then the next instruction is fetched while the previous instruction is decoded, and so on.
## Hazards
Hazards occur when instructions in a pipeline produce an incorrect answer. This can occur in a couple of ways:
- When two instructions attempt to use the same resource (registers, ALU, etc.) at the same time.
- When an instruction attempts to use data in a certain register before that data actually reaches that register.
- During branching. 

An example of a RAW (read after write) hazard is as follows: 

```
add $s0, $s2, $s3
and $t0, $s0, $s1
```
The add instruction writes a result into $s0, but $s0 will be read in the very next instruction. Due to the pipeline process, $s0 will be read before the correct value has been written there, so instruction two will produce an incorrect answer. We can solve this hazard by *forwarding* the result of the ALU from the memory/write-back stage to another instruction in the execute stage. 

We can solve these problems by implementing a hazard unit in our design. The processor resolves data hazards through operand forwarding whenever possible. If a write will occur to a register that matches the source register then forwarding is used. If forwarding cannot resolve the dependency (e.g. a load-use hazard), the hazard unit inserts a pipeline stall. Control hazards are handled by flushing instructions following taken branches and jumps.
# A brief overview of MIPS
## ISA

The MIPS ISA contains three instruction types. **Register-Type** instructions uses three registers as operands - two as sources and one as a destination:

| Field | Bit Width | Function                                                                                                                |
| ----- | --------- | ----------------------------------------------------------------------------------------------------------------------- |
| op    | 6         | opcode (R-Type instructions always have opcode of zero)                                                                 |
| rs    | 5         | source register                                                                                                         |
| rt    | 5         | source register                                                                                                         |
| rd    | 5         | destination register                                                                                                    |
| shamt | 5         | used only in shift operations - indicates the amount of bits by which to shift (is zero for all non shift instructions) |
| funct | 6         | function code (determines the R-Type operation)                                                                         |

**Immediate-Type** instructions use two registers as operands along with one immediate operand:

| Field | Bit Width | Function                    |
| ----- | --------- | --------------------------- |
| op    | 6         | opcode                      |
| rs    | 5         | source register             |
| rt    | 5         | source/destination register |
| imm   | 16        | immediate value             |

**Jump-Type** instructions are only used with jump instructions:

| Field | Bit Width | Function        |     |
| ----- | --------- | --------------- | --- |
| op    | 6         | opcode          |     |
| imm   | 26        | immediate value |     |

| Instruction | Type |
| ----------- | ---- |
| add         | R    |
| sub         | R    |
| and         | R    |
| or          | R    |
| slt         | R    |
| lw          | I    |
| sw          | I    |
| addi        | I    |
| beq         | I    |
| j           | J    |

*MIPS instructions*
## Micro-architecture
The CPU contains 32 general purpose registers, each with a specific purpose:

| Name      | Number | Use                    |
| --------- | ------ | ---------------------- |
| $0        | 0      | the constant value 0   |
| $at       | 1      | assembler temporary    |
| $v0 - $v1 | 2-3    | function return value  |
| $a0 - $a3 | 4-7    | function arguments     |
| $t0 - $t7 | 8-15   | temporary variables    |
| $s0 - $s7 | 16-23  | saved variables        |
| $t8 - $t9 | 24-25  | temporary variables    |
| $k0 - $k1 | 26-27  | OS temporaries         |
| $gp       | 28     | global pointer         |
| $sp       | 29     | stack pointer          |
| $fp       | 30     | frame pointer          |
| $ra       | 31     | function return adress |

*Overview of MIPS registers*

It's important to note that the zero register can never be written too, it will always contain the value zero. The data memory contains 256 addressable locations, as does the instruction memory.
### Control Unit
The control unit computes the control signals based on the opcode and function (used only in R-Type instructions) fields of the instruction. The decoder processes the opcode/function values and decides which control signals to drive.

| Control Signal | Description                                                                                                |
| -------------- | ---------------------------------------------------------------------------------------------------------- |
| reg_write      | Enables writing to the register file                                                                       |
| reg_dst        | Decides which address to write to in the register file (rd for R-Type and rt for I-Type)                   |
| alu_src        | Controls whether ALU operates on value from register file (R-Type) or the sign extended immediate (I-Type) |
| branch         | Controls whether a branch instruction is to occur                                                          |
| mem_write      | Enables writing to data memory                                                                             |
| mem_to_reg     | Controls whether the value written to a register is from the ALU (R-Type) or from data memory (I-Type)     |
| jump           | Controls whether a jump instruction is to occur                                                            |
| alu_op         | Controls the ALU operation performed                                                                       |

*Control Signal Descriptions*

| Opcode | Instruction Name | reg_write | reg_dst | alu_src | branch | mem_write | mem_to_reg | jump | alu_op |
| ------ | ---------------- | --------- | ------- | ------- | ------ | --------- | ---------- | ---- | ------ |
| 000000 | R-Type           | 1         | 1       | 0       | 0      | 0         | 0          | 0    | 10     |
| 100011 | LW               | 1         | 0       | 1       | 0      | 0         | 1          | 0    | 00     |
| 101011 | SW               | 0         | 0       | 1       | 0      | 1         | 0          | 0    | 00     |
| 000100 | BEQ              | 0         | 0       | 0       | 1      | 0         | 0          | 0    | 01     |
| 001000 | ADDI             | 1         | 0       | 1       | 0      | 0         | 0          | 0    | 00     |
| 000010 | JMP              | 0         | 0       | 0       | 0      | 0         | 0          | 1    | 00     |

*Decoder Truth Table*
# Design Description
## Modules
The module hierarchy is as follows:
```
top.v
├── hazard_unit.v
├── control_unit.v
├── ifetch.v
	└── imem.v
├── ifetch_idecode_reg.v
├── idecode.v
	└── regfile.v
├──	idecode_exe_reg.v
├── execute.v
	└── alu.v
├──	exe_mem_reg.v
├── memory.v
	└── dmem.v
├──	mem_write_back_reg.v
├── write_back.v
```

# pipelined-CPU
A pipelined RISC CPU based off the MIPS architecture, implemented in verilog.
## Acknowledgements 
Heavily inspired by: Digital Design and Computer Architecture, 2nd Edition written by David Money Harris and Sarah L. Harris.
# What makes a CPU pipelined?
Pipelining here refers to instruction pipelining. It divides instructions into a series of steps which can be split up and performed in parallel. This aims to keep all portions of the processor occupied to increase throughput. A typical five stage pipeline consists of five stages:

- **IF (Instruction Fetch)** - fetch instruction from the instruction memory using the program counter.
- **ID (Instruction Decode)** - decode instruction.
- **EX (Execute)** - execute instruction using ALU / bit shifter.
- **MEM (Memory access)** - write results to the data memory if needed.
- **WB (Register write back)** - write results back to register file.

This is achieved using pipeline registers.
## Hazards
Hazards occur when instructions in a pipeline produce an incorrect answer. This can occur in a couple of ways:
- When two instructions attempt to use the same resource (registers, ALU, etc.) at the same time.
- When an instruction attempts to use data in a certain register before that data actually reaches that register.
- During branching. 

We can solve these problems by implementing a hazard unit in our design.
# Design Description
## Features
- 
- 
- 
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

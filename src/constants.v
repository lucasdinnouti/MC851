`define ALU_ADD_OP 4'b0000
`define ALU_SUB_OP 4'b1000
`define ALU_SLL_OP 4'b0001
`define ALU_XOR_OP 4'b0100
`define ALU_OR_OP 4'b0110
`define ALU_AND_OP 4'b0111
`define ALU_SRL_OP 4'b0101
`define ALU_SRA_OP 4'b1101
`define ALU_SLT_OP 4'b0010
`define ALU_SLTU_OP 4'b0011

`define LOAD_OP 7'b0000011
`define STORE_OP 7'b0100011
`define IMM_OP 7'b0010011
`define REG_OP 7'b0110011

`define MEM_WORD 3'b010
`define MEM_HALF 3'b001
`define MEM_BYTE 3'b000
`define MEM_HALF_U 3'b101
`define MEM_BYTE_U 3'b100

`define INSTRUCTION_MEMORY_SIZE 4'd8

`define MEM_ROM 0
`define MEM_RAM 1

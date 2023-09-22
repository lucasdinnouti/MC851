`define ALU_ADD_OP 5'b00000
`define ALU_SUB_OP 5'b01000
`define ALU_SLL_OP 5'b00001
`define ALU_XOR_OP 5'b00100
`define ALU_OR_OP 5'b00110
`define ALU_AND_OP 5'b00111
`define ALU_SRL_OP 5'b00101
`define ALU_SRA_OP 5'b01101
`define ALU_SLT_OP 5'b00010
`define ALU_SLTU_OP 5'b00011
`define ALU_MUL_OP 5'b10000
`define ALU_MULH_OP 5'b10001
`define ALU_MULHSU_OP 5'b10010
`define ALU_MULHU_OP 5'b10011
`define ALU_DIV_OP 5'b10100
`define ALU_DIVU_OP 5'b10101
`define ALU_REM_OP 5'b10110
`define ALU_REMU_OP 5'b10111

`define LOAD_OP 7'b0000011
`define STORE_OP 7'b0100011
`define IMM_OP 7'b0010011
`define REG_OP 7'b0110011
`define BRANCH_OP 7'b1100011
`define ATOMIC_OP 7'b0101111

`define MEM_WORD 3'b010
`define MEM_HALF 3'b001
`define MEM_BYTE 3'b000
`define MEM_HALF_U 3'b101
`define MEM_BYTE_U 3'b100

`define INSTRUCTION_MEMORY_SIZE 4'd8

`define MEM_ROM 1'b0
`define MEM_RAM 1'b1

`define BRANCH_EQ 3'b000
`define BRANCH_NE 3'b001
`define BRANCH_NONE 3'b010
`define BRANCH_LT 3'b100
`define BRANCH_GE 3'b101
`define BRANCH_LTU 3'b110
`define BRANCH_GEU 3'b111

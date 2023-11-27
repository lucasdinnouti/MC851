`define assert_immediate_instruction(name, expected_rd, expected_rs1, expected_immediate,
                                     expected_alu_op) \
    `assert(rd, expected_rd, name, "rd"); \
    `assert(rs1, expected_rs1, name, "rs1"); \
    `assert(immediate, expected_immediate, name, "immediate"); \
    `assert(alu_use_rs2, 0, name, "alu_use_rs2"); \
    `assert(alu_op, expected_alu_op, name, "alu_op"); \
    `assert(reg_write, 1, name, "reg_write"); \
    `assert(mem_write, 0, name, "mem_write") \
    `assert(mem_read, 0, name, "mem_read") \
    `assert(branch_type, `BRANCH_NONE, name, "branch_type");

`define assert_register_instruction(name, expected_rd, expected_rs1, expected_rs2, expected_alu_op) \
    `assert(rd, expected_rd, name, "rd"); \
    `assert(rs1, expected_rs1, name, "rs1"); \
    `assert(rs2, expected_rs2, name, "rs2"); \
    `assert(alu_use_rs2, 1, name, "alu_use_rs2"); \
    `assert(alu_op, expected_alu_op, name, "alu_op"); \
    `assert(reg_write, 1, name, "reg_write"); \
    `assert(mem_write, 0, name, "mem_write") \
    `assert(mem_read, 0, name, "mem_read") \
    `assert(branch_type, `BRANCH_NONE, name, "branch_type");

`define assert_load_instruction(name, expected_rd, expected_immediate, expected_rs1,
                                expected_mem_op_length) \
    `assert(rd, expected_rd, name, "rd") \
    `assert(rs1, expected_rs1, name, "rs1") \
    `assert(immediate, expected_immediate, name, "immediate") \
    `assert(alu_use_rs2, 0, name, "alu_use_rs2") \
    `assert(alu_op, `ALU_ADD_OP, name, "alu_op") \
    `assert(reg_write, 1, name, "reg_write") \
    `assert(mem_write, 0, name, "mem_write") \
    `assert(mem_read, 1, name, "mem_read") \
    `assert(mem_op_length, expected_mem_op_length, name, "mem_op_length"); \
    `assert(branch_type, `BRANCH_NONE, name, "branch_type");

`define assert_store_instruction(name, expected_rs2, expected_immediate, expected_rs1,
                                 expected_mem_op_length) \
    `assert(rs1, expected_rs1, name, "rs1"); \
    `assert(rs2, expected_rs2, name, "rs2"); \
    `assert(immediate, expected_immediate, name, "immediate"); \
    `assert(alu_use_rs2, 0, name, "alu_use_rs2"); \
    `assert(alu_op, `ALU_ADD_OP, name, "alu_op"); \
    `assert(reg_write, 0, name, "reg_write"); \
    `assert(mem_write, 1, name, "mem_write"); \
    `assert(mem_read, 0, name, "mem_read"); \
    `assert(mem_op_length, expected_mem_op_length, name, "mem_op_length"); \
    `assert(branch_type, `BRANCH_NONE, name, "branch_type");

`define assert_branch_instruction(name, expected_rs1, expected_rs2, expected_immediate,
                                  expected_branch_type) \
    `assert(rs1, expected_rs1, name, "rs1"); \
    `assert(rs2, expected_rs2, name, "rs2"); \
    `assert(immediate, expected_immediate, name, "immediate"); \
    `assert(branch_type, expected_branch_type, name, "branch_type"); \
    `assert(reg_write, 0, name, "reg_write"); \
    `assert(mem_write, 0, name, "mem_write"); \
    `assert(mem_read, 0, name, "mem_read");

`define assert_jal_instruction(name, expected_rd, expected_immediate) \
    `assert(rd, expected_rd, name, "rd") \
    `assert(immediate, expected_immediate, name, "immediate"); \
    `assert(branch_type, `BRANCH_JAL, name, "branch_type"); \
    `assert(reg_write, 1, name, "reg_write"); \
    `assert(mem_write, 0, name, "mem_write"); \
    `assert(mem_read, 0, name, "mem_read");

`define assert_jalr_instruction(name, expected_rd, expected_immediate, expected_rs1) \
    `assert(rd, expected_rd, name, "rd") \
    `assert(immediate, expected_immediate, name, "immediate"); \
    `assert(rs1, expected_rs1, name, "rs1"); \
    `assert(branch_type, `BRANCH_JALR, name, "branch_type"); \
    `assert(reg_write, 1, name, "reg_write"); \
    `assert(mem_write, 0, name, "mem_write"); \
    `assert(mem_read, 0, name, "mem_read");

`define assert_lui_instruction(name, expected_rd, expected_immediate) \
    `assert(rd, expected_rd, name, "rd"); \
    `assert(immediate, expected_immediate, name, "immediate"); \
    `assert(rs1, 0, name, "rs1"); \
    `assert(alu_op, `ALU_ADD_OP, name, "alu_op"); \
    `assert(reg_write, 1, name, "reg_write"); \
    `assert(mem_write, 0, name, "mem_write"); \
    `assert(mem_read, 0, name, "mem_read"); \
    `assert(branch_type, `BRANCH_NONE, name, "branch_type");


`timescale 1 ns / 10 ps

module decoder_tb;
  reg [31:0] instruction;
  wire [4:0] rs1;
  wire [4:0] rs2;
  wire [4:0] rd;
  wire [31:0] immediate;
  wire alu_use_rs2;
  wire [4:0] alu_op;
  wire reg_write;
  wire mem_write;
  wire mem_read;
  wire [2:0] mem_op_length;
  wire [3:0] branch_type;

  localparam PERIOD = 10;

  decoder under_test (
      .instruction(instruction),
      .rs1(rs1),
      .rs2(rs2),
      .rd(rd),
      .immediate(immediate),
      .alu_use_rs2(alu_use_rs2),
      .alu_op(alu_op),
      .reg_write(reg_write),
      .mem_write(mem_write),
      .mem_read(mem_read),
      .mem_op_length(mem_op_length),
      .branch_type(branch_type)
  );

  initial begin
    $dumpfile("decoder.vcd");
    $dumpvars(0, decoder_tb);
  end

  initial begin
    // add x10, x1, x1
    instruction = 32'h00108533;
    #PERIOD;
    `assert_register_instruction("add", 10, 1, 1, `ALU_ADD_OP);

    // sub x10, x11, x12
    instruction = 32'h40c58533;
    #PERIOD;
    `assert_register_instruction("sub", 10, 11, 12, `ALU_SUB_OP);

    // sll x7, x8, x13
    instruction = 32'h00d413b3;
    #PERIOD;
    `assert_register_instruction("sll", 7, 8, 13, `ALU_SLL_OP);

    // slt x14, x16, x17
    instruction = 32'h01182733;
    #PERIOD;
    `assert_register_instruction("slt", 14, 16, 17, `ALU_SLT_OP);

    // sltu x18, x20, x22
    instruction = 32'h016a3933;
    #PERIOD;
    `assert_register_instruction("sltu", 18, 20, 22, `ALU_SLTU_OP);

    // xor x23, x24, x25
    instruction = 32'h019c4bb3;
    #PERIOD;
    `assert_register_instruction("xor", 23, 24, 25, `ALU_XOR_OP);

    // srl x26, x27, x28
    instruction = 32'h01cddd33;
    #PERIOD;
    `assert_register_instruction("srl", 26, 27, 28, `ALU_SRL_OP);

    // sra x29, x30, x31
    instruction = 32'h41ff5eb3;
    #PERIOD;
    `assert_register_instruction("sra", 29, 30, 31, `ALU_SRA_OP);

    // or x0, x0, x0
    instruction = 32'h00006033;
    #PERIOD;
    `assert_register_instruction("or", 0, 0, 0, `ALU_OR_OP);

    // and x31, x31, x31
    instruction = 32'h01ffffb3;
    #PERIOD;
    `assert_register_instruction("and", 31, 31, 31, `ALU_AND_OP);

    // mul x10, x9, x8
    instruction = 32'h02848533;
    #PERIOD;
    `assert_register_instruction("mul", 10, 9, 8, `ALU_MUL_OP);

    // div x1, x1, x1
    instruction = 32'h0210c0b3;
    #PERIOD;
    `assert_register_instruction("div", 1, 1, 1, `ALU_DIV_OP);

    // addi x5, x6, 7
    instruction = 32'h00730293;
    #PERIOD;
    `assert_immediate_instruction("addi", 5, 6, 7, `ALU_ADD_OP);

    // slti x20, x21, -100
    instruction = 32'hf9caaa13;
    #PERIOD;
    `assert_immediate_instruction("slti", 20, 21, -100, `ALU_SLT_OP);

    // sltiu x15, x15, 0
    instruction = 32'h0007b793;
    #PERIOD;
    `assert_immediate_instruction("sltiu", 15, 15, 0, `ALU_SLTU_OP);

    // xori x0, x0, 10
    instruction = 32'h00a04013;
    #PERIOD;
    `assert_immediate_instruction("xori", 0, 0, 10, `ALU_XOR_OP);

    // ori x31, x31, -1024
    instruction = 32'hc00fef93;
    #PERIOD;
    `assert_immediate_instruction("ori", 31, 31, -1024, `ALU_OR_OP);

    // andi x19, x20, 2047
    instruction = 32'h7ffa7993;
    #PERIOD;
    `assert_immediate_instruction("andi", 19, 20, 2047, `ALU_AND_OP);

    // slli x1, x2, 30
    instruction = 32'h01e11093;
    #PERIOD;
    `assert_immediate_instruction("slli", 1, 2, 30, `ALU_SLL_OP);

    // srli x3, x4, 1
    instruction = 32'h00125193;
    #PERIOD;
    `assert_immediate_instruction("srli", 3, 4, 1, `ALU_SRL_OP);

    // srai x5, x6, 0
    instruction = 32'h40035293;
    #PERIOD;
    `assert_immediate_instruction("srai", 5, 6, 0, `ALU_SRA_OP);

    // lb x20, 16(x10)
    instruction = 32'h01050a03;
    #PERIOD;
    `assert_load_instruction("lb", 20, 16, 10, `MEM_BYTE);

    // lh x1, 0(x1)
    instruction = 32'h00009083;
    #PERIOD;
    `assert_load_instruction("lh", 1, 0, 1, `MEM_HALF);

    // lw x4, -32(x8)
    instruction = 32'hfe042203;
    #PERIOD;
    `assert_load_instruction("lw", 4, -32, 8, `MEM_WORD);

    // lbu x15, 1024(x4)
    instruction = 32'h40024783;
    #PERIOD;
    `assert_load_instruction("lbu", 15, 1024, 4, `MEM_BYTE_U);

    // lhu x19, 4(x31)
    instruction = 32'h004fd983;
    #PERIOD;
    `assert_load_instruction("lhu", 19, 4, 31, `MEM_HALF_U);

    // sw x1, -16(x2)
    instruction = 32'hfe112823;
    #PERIOD;
    `assert_store_instruction("sw", 1, -16, 2, `MEM_WORD);

    // sh x5, 0(x6)
    instruction = 32'h00531023;
    #PERIOD;
    `assert_store_instruction("sh", 5, 0, 6, `MEM_HALF);

    // sb x4, 32(x3)
    instruction = 32'h02418023;
    #PERIOD;
    `assert_store_instruction("sb", 4, 32, 3, `MEM_BYTE);

    // beq x1, x5, 4
    instruction = 32'h00508263;
    #PERIOD;
    `assert_branch_instruction("beq", 1, 5, 4, `BRANCH_EQ);

    // bne x7, x9, -4
    instruction = 32'hfe939ee3;
    #PERIOD;
    `assert_branch_instruction("bne", 7, 9, -4, `BRANCH_NE);

    // lui x15, 0xf4
    instruction = 32'h000f47b7;
    #PERIOD;
    `assert_lui_instruction("lui", 15, 32'hf4 << 12);

    // lw x15, 0(x15) -- COMPACT
    instruction = 32'h0000439c;
    #PERIOD;
    `assert_load_instruction("lw (compact)", 15, 0, 15, `MEM_WORD);

    // lwsp x8, 28(x2) -- COMPACT
    instruction = 32'h00004472;
    #PERIOD;
    `assert_load_instruction("lwsp (compact)", 8, 28, 2, `MEM_WORD);

    // sw x14,0(x15)
    instruction = 32'h0000c398;
    #PERIOD;
    `assert_store_instruction("sw (compact)", 14, 0, 15, `MEM_WORD);

    // swsp x8, 28(x2) -- COMPACT
    instruction = 32'h0000ce22;
    #PERIOD;
    `assert_store_instruction("swsp (compact)", 8, 28, 2, `MEM_WORD);

    // addi x2, x2, -32 -- COMPACT             
    instruction = 32'h00001101;
    #PERIOD;
    `assert_immediate_instruction("addi (compact)", 2, 2, -32, `ALU_ADD_OP);

    // li x14, 1  
    instruction = 32'h00004705;
    #PERIOD;
    `assert_immediate_instruction("li (compact)", 14, 0, 1, `ALU_ADD_OP);

    // addi x2, x2, 32
    instruction = 32'h00006105;
    #PERIOD;
    `assert_immediate_instruction("addi16sp (compact)", 2, 2, 32, `ALU_ADD_OP);

    // add x8, x2, 32
    instruction = 32'h00001000;
    #PERIOD;
    `assert_immediate_instruction("addi4spn (compact)", 8, 2, 32, `ALU_ADD_OP);

    // jc -2
    instruction = 32'h0000bffd;
    #PERIOD;
    `assert_jal_instruction("jc (compact)", 0, -2);

    // jr x1
    instruction = 32'h00008082;
    #PERIOD;
    `assert_jalr_instruction("jr (compact)", 0, 0, 1);

    // jal 10 <operation>
    instruction = 32'h0000375d;
    #PERIOD;
    `assert_jal_instruction("jal (compact)", 1, -90);

    // beqz x15,54 <main+0x44>
    instruction = 32'h0000c785;
    #PERIOD;
    `assert_branch_instruction("beqz (compact)", 15, 0, 40, `BRANCH_EQ);

    // bnez x15,54 <main+0x44>
    instruction = 32'h0000e791;
    #PERIOD;
    `assert_branch_instruction("bnez (compact)", 15, 0, 12, `BRANCH_NE);

    // sub x14, x14, x15
    instruction = 32'h00008f1d;
    #PERIOD;
    `assert_register_instruction("sub (compact)", 14, 14, 15, `ALU_SUB_OP);

    // and x15, x15, x14
    instruction = 32'h00008ff9;
    #PERIOD;
    `assert_register_instruction("and (compact)", 15, 15, 14, `ALU_AND_OP);

    // or x15, x15, x14
    instruction = 32'h00008fd9;
    #PERIOD;
    `assert_register_instruction("or (compact)", 15, 15, 14, `ALU_OR_OP);

    // xor x15, x15, x13
    instruction = 32'h00008fb5;
    #PERIOD;
    `assert_register_instruction("xor (compact)", 15, 15, 13, `ALU_XOR_OP);

    // and x15, x15, 10
    instruction = 32'h00008ba9;
    #PERIOD;
    `assert_immediate_instruction("and (compact)", 15, 15, 10, `ALU_AND_OP);

    // srai x15, x15, 2
    instruction = 32'h00008789;
    #PERIOD;
    `assert_immediate_instruction("srai (compact)", 15, 15, 2, `ALU_SRA_OP);

    // srli x15, x15, 2
    instruction = 32'h00008389;
    #PERIOD;
    `assert_immediate_instruction("srli (compact)", 15, 15, 2, `ALU_SRL_OP);

    // slli x15, x15, 2
    instruction = 32'h0000078a;
    #PERIOD;
    `assert_immediate_instruction("slli (compact)", 15, 15, 2, `ALU_SLL_OP);

    // lui x15, 2
    instruction = 32'h00006789;
    #PERIOD;
    `assert_lui_instruction("lui (compact)", 15, 32'h2 << 12);
  end
endmodule

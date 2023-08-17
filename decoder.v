module decoder (
    input wire [31:0] instruction,
    output wire [4:0] rs1,
    output wire [4:0] rs2,
    output wire [4:0] rd,
    output reg [31:0] immediate,
    output wire alu_source,
    output reg [3:0] alu_op,
    output wire should_write
);

  wire [2:0] funct3;
  assign funct3 = instruction[14:12];

  wire [6:0] opcode;
  assign opcode = instruction[6:0];

  assign rs1 = instruction[19:15];
  assign rs2 = instruction[24:20];
  assign rd = instruction[11:7];

  assign alu_source = instruction[5];

  // FIXME
  assign should_write = 1;

  always @* begin
    if (opcode == 7'b0010011 && funct3 != 3'b101) begin
      // Immediate instructions except for SRLI and SRAI
      alu_op = {1'b0, funct3};
    end else begin
      alu_op = {instruction[30], funct3};
    end

    // TODO: edge cases for load and store
    // if opcode == 0000011 or 0100011 set alu_op to 0000

    if (opcode == 7'b0010011 && funct3 == 3'b101) begin
      // SRLI and SRAI shamt immediate
      immediate = instruction[24:20];
    end else begin
      immediate = $signed(instruction[31:20]);
    end

  end

endmodule

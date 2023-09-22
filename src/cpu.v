module cpu (
    input wire clock,
    input wire btn,
    output wire flashClk,
    input wire flashMiso,
    output wire flashMosi,
    output wire flashCs,
    output wire [5:0] led
);
  localparam WAIT_TIME = 54000000;
  // localparam WAIT_TIME = 4;

  reg [31:0] pc = 0;
  wire [31:0] instruction;

  wire [4:0] rs1;
  wire [4:0] rs2;
  wire [4:0] rd;
  wire [31:0] immediate;
  wire alu_use_rs2;
  wire [3:0] alu_op;
  wire reg_write;

  wire [31:0] rs1_data;
  wire [31:0] rs2_data;

  wire [31:0] alu_b;
  assign alu_b = alu_use_rs2 == 0 ? immediate : rs2_data;

  wire alu_should_bypass_a, alu_should_bypass_b;
  assign alu_should_bypass_a = wb_reg_write && wb_rd == ex_rs1;
  assign alu_should_bypass_b = wb_reg_write && (wb_rd == ex_rs2 && ex_alu_use_rs2);

  wire zero;
  wire [31:0] result;

  wire [31:0] id_instruction;

  wire [31:0] ex_a;
  wire [31:0] ex_b;
  wire [3:0] ex_op;
  wire [4:0] ex_rd;
  wire [4:0] ex_rs1;
  wire [4:0] ex_rs2;
  wire ex_reg_write;
  wire ex_alu_use_rs2;

  wire [31:0] wb_alu_result;
  wire [4:0] wb_rd;
  wire wb_reg_write;

  assign led[5] = ~pc[2];
  // assign led[4:0] = ~wb_alu_result[4:0];

  wire controlled_clock;
  // assign controlled_clock = btn;
  
  reg [25:0] clock_counter = 0;
  // reg [4:0] clock_counter = 0;
  always @(posedge clock) begin
    clock_counter <= clock_counter + 1;
    
    if (clock_counter == WAIT_TIME / 2) begin
      controlled_clock <= 0;
    end

    if (clock_counter == WAIT_TIME) begin
      clock_counter <= 0;
      controlled_clock <= 1;
    end
  end

  always @(posedge controlled_clock) begin
    pc <= pc + 4;
  end

  // instruction_memory instruction_memory (
  //   .pc(pc),
  //   .instruction(instruction),
  //   .clock(clock),
  //   .flashClk(flashClk),
  //   .flashMiso(flashMiso),
  //   .flashMosi(flashMosi),
  //   .flashCs(flashCs)
  // );

  memory instruction_memory (
      .address(pc >> 2),
      .input_data(0),
      .mem_write(1'b0),
      .mem_read(1'b1),
      .mem_type(`MEM_ROM),
      .clock(clock),
      .output_data(instruction)
  );

  if_id_pipeline_registers if_id_pipeline_registers (
    .clock(controlled_clock),
    .if_instruction(instruction),
    .id_instruction(id_instruction),
  );

  decoder decoder (
    .instruction(id_instruction),
    .rs1(rs1),
    .rs2(rs2),
    .rd(rd),
    .immediate(immediate),
    .alu_use_rs2(alu_use_rs2),
    .alu_op(alu_op),
    .reg_write(reg_write)
  );

  registers registers (
    .rs1(rs1),
    .rs2(rs2),
    .rd(wb_rd),
    .data(wb_alu_result),
    .reg_write(wb_reg_write),
    .clock(controlled_clock),
    .rs1_data(rs1_data),
    .rs2_data(rs2_data),
    .led(led[4:0])
  );

  id_ex_pipeline_registers id_ex_pipeline_registers (
    .clock(controlled_clock),
    .id_a(rs1_data),
    .id_b(alu_b),
    .id_op(alu_op),
    .id_rd(rd),
    .id_rs1(rs1),
    .id_rs2(rs2),
    .id_reg_write(reg_write),
    .id_alu_use_rs2(alu_use_rs2),
    .ex_a(ex_a),
    .ex_b(ex_b),
    .ex_op(ex_op),
    .ex_rd(ex_rd),
    .ex_rs1(ex_rs1),
    .ex_rs2(ex_rs2),
    .ex_reg_write(ex_reg_write),
    .ex_alu_use_rs2(ex_alu_use_rs2)
  );

  alu alu (
<<<<<<< Updated upstream
    .a(rs1_data),
    .b(alu_b),
    .op(alu_op),
=======
    .clock(clock),
    .a(ex_a),
    .b(ex_b),
    .op(ex_op),
    .bypass_data(wb_alu_result),
    .use_bypass_a(alu_should_bypass_a),
    .use_bypass_b(alu_should_bypass_b),
>>>>>>> Stashed changes
    .zero(zero),
    .result(result)
  );

  // alu alu (
  //   .clock(clock),
  //   .a(rs1_data),
  //   .b(alu_b),
  //   .op(alu_op),
  //   .zero(zero),
  //   .result(result)
  // );

  post_ex_pipeline_registers post_ex_pipeline_registers (
    .clock(controlled_clock),
    .ex_alu_result(result),
    .ex_rd(ex_rd),
    .ex_reg_write(ex_reg_write),
    .wb_alu_result(wb_alu_result),
    .wb_rd(wb_rd),
    .wb_reg_write(wb_reg_write)
  );

  // post_ex_pipeline_registers post_ex_pipeline_registers (
  //   .clock(controlled_clock),
  //   .ex_alu_result(result),
  //   .ex_rd(rd),
  //   .ex_reg_write(reg_write),
  //   .wb_alu_result(wb_alu_result),
  //   .wb_rd(wb_rd),
  //   .wb_reg_write(wb_reg_write)
  // );
endmodule

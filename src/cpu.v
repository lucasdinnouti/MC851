module cpu (
    input wire clock,
    input wire [1:0] photores,
    output wire [5:0] led
);
  wire [31:0] pc;
  wire [31:0] if_instruction;

  wire [31:0] peripheral_bus;
  wire [31:0] wb_peripheral_bus;

  wire [31:0] id_instruction;
  wire [4:0] id_rs1;
  wire [4:0] id_rs2;
  wire [4:0] id_rd;
  wire [31:0] id_immediate;
  wire id_alu_use_rs2;
  wire [4:0] id_alu_op;
  wire id_reg_write;
  wire id_mem_write;
  wire id_mem_read;
  wire [2:0] id_mem_op_length;
  wire [2:0] id_branch_type;
  wire [31:0] id_rs1_data;
  wire [31:0] id_rs2_data;

  wire alu_should_bypass_a, alu_should_bypass_b;

  wire [31:0] ex_rs1_data;
  wire [31:0] ex_rs2_data;
  wire [31:0] ex_alu_a;
  wire [31:0] ex_alu_b;
  wire [4:0] ex_alu_op;
  wire [4:0] ex_rd;
  wire [4:0] ex_rs1;
  wire [4:0] ex_rs2;
  wire ex_reg_write;
  wire ex_alu_use_rs2;
  wire [31:0] ex_immediate;
  wire [31:0] ex_alu_result;
  wire ex_mem_write;
  wire ex_mem_read;
  wire [2:0] ex_mem_op_length;

  wire [31:0] mem_alu_result;
  wire [31:0] mem_rs2_data;
  wire [4:0] mem_rd;
  wire mem_reg_write;
  wire mem_mem_write;
  wire mem_mem_read;
  wire [2:0] mem_mem_op_length;
  wire [31:0] mem_mem_data;

  wire [31:0] wb_alu_result;
  wire [31:0] wb_rd_data;
  wire [4:0] wb_rd;
  wire wb_reg_write;
  wire [31:0] wb_mem_data;
  assign wb_rd_data = wb_mem_read == 0 ? wb_alu_result : wb_mem_data;

  wire [31:0] r1;

  assign led[5] = ~pc[2];
  // assign led[0] = ~r1[0];
  // assign led[4:0] = ~wb_alu_result[4:0];

  wire cpu_clock;

  // Uncomment for uncontrolled clock
  assign cpu_clock = clock;
  
  // Uncomment for controlled clock  
  // localparam WAIT_TIME = 54000000;
  // reg [25:0] clock_counter = 0;
  // reg [4:0] clock_counter = 0;
  // always @(posedge clock) begin
  //   clock_counter <= clock_counter + 1;
  //   
  //   if (clock_counter == WAIT_TIME / 2) begin
  //     cpu_clock <= 0;
  //   end
  // 
  //   if (clock_counter == WAIT_TIME) begin
  //     clock_counter <= 0;
  //     cpu_clock <= 1;
  //   end
  // end

  branch branch (
    .pc(pc),
    .clock(cpu_clock),
    .rs1_data(id_rs1_data),
    .rs2_data(id_rs2_data),
    .immediate(id_immediate),
    .branch_type(id_branch_type)
  );

  memory instruction_memory (
      .address(pc >> 2),
      .input_data(0),
      //.wb_peripheral_bus(wb_peripheral_bus),
      .mem_read(1'b1),
      .mem_write(1'b0),
      .mem_type(`MEM_ROM),
      .clock(cpu_clock),
      .output_data(if_instruction)
      //.peripheral_bus(peripheral_bus)
  );

  if_id_pipeline_registers if_id_pipeline_registers (
    .clock(cpu_clock),
    .if_instruction(if_instruction),
    .id_instruction(id_instruction)
  );

  decoder decoder (
    .instruction(id_instruction),
    .rs1(id_rs1),
    .rs2(id_rs2),
    .rd(id_rd),
    .immediate(id_immediate),
    .alu_use_rs2(id_alu_use_rs2),
    .alu_op(id_alu_op),
    .reg_write(id_reg_write),
    .mem_write(id_mem_write),
    .mem_read(id_mem_read),
    .mem_op_length(id_mem_op_length),
    .branch_type(id_branch_type)
  );

  registers registers (
    .rs1(id_rs1),
    .rs2(id_rs2),
    .rd(wb_rd),
    .data(wb_rd_data),
    .reg_write(wb_reg_write),
    .clock(cpu_clock),
    .rs1_data(id_rs1_data),
    .rs2_data(id_rs2_data),
    .r1(r1)
  );

  //peripherals peripherals(
  //  .peripheral_bus(peripheral_bus),
  //  .btn(btn),
  //  .photores(photores),
  //  .led(led[4:0]),
  //  .wb_peripheral_bus(wb_peripheral_bus)
  //);

  id_ex_pipeline_registers id_ex_pipeline_registers (
    .clock(cpu_clock),
    .id_rs1_data(id_rs1_data),
    .id_rs2_data(id_rs2_data),
    .id_alu_op(id_alu_op),
    .id_rd(id_rd),
    .id_rs1(id_rs1),
    .id_rs2(id_rs2),
    .id_reg_write(id_reg_write),
    .id_alu_use_rs2(id_alu_use_rs2),
    .id_immediate(id_immediate),
    .id_mem_write(id_mem_write),
    .id_mem_read(id_mem_read),
    .id_mem_op_length(id_mem_op_length),
    .ex_rs1_data(ex_rs1_data),
    .ex_rs2_data(ex_rs2_data),
    .ex_alu_op(ex_alu_op),
    .ex_rd(ex_rd),
    .ex_rs1(ex_rs1),
    .ex_rs2(ex_rs2),
    .ex_reg_write(ex_reg_write),
    .ex_alu_use_rs2(ex_alu_use_rs2),
    .ex_immediate(ex_immediate),
    .ex_mem_write(ex_mem_write),
    .ex_mem_read(ex_mem_read),
    .ex_mem_op_length(ex_mem_op_length)
  );

  forwarding forwarding(
    .ex_rs1_data(ex_rs1_data),
    .ex_rs2_data(ex_rs2_data),
    .ex_immediate(ex_immediate),
    .ex_rs1(ex_rs1),
    .ex_rs2(ex_rs2),
    .ex_alu_use_rs2(ex_alu_use_rs2),
    .mem_reg_write(mem_reg_write),
    .mem_mem_read(mem_mem_read),
    .mem_rd(mem_rd),
    .mem_alu_result(mem_alu_result),
    .mem_mem_data(mem_mem_data),
    .wb_rd(wb_rd),
    .wb_rd_data(wb_rd_data),
    .wb_reg_write(wb_reg_write),
    .alu_a(ex_alu_a),
    .alu_b(ex_alu_b)
  );

  alu alu (
    .a(ex_alu_a),
    .b(ex_alu_b),
    .op(ex_alu_op),
    .result(ex_alu_result)
  );

  ex_mem_pipeline_registers ex_mem_pipeline_registers(
    .clock(cpu_clock),
    .ex_alu_result(ex_alu_result),
    .ex_rs2_data(ex_rs2_data),
    .ex_rd(ex_rd),
    .ex_reg_write(ex_reg_write),
    .ex_mem_write(ex_mem_write),
    .ex_mem_read(ex_mem_read),
    .ex_mem_op_length(ex_mem_op_length),
    .mem_alu_result(mem_alu_result),
    .mem_rs2_data(mem_rs2_data),
    .mem_rd(mem_rd),
    .mem_reg_write(mem_reg_write),
    .mem_mem_write(mem_mem_write),
    .mem_mem_read(mem_mem_read),
    .mem_mem_op_length(mem_mem_op_length)
  );

  memory data_memory (
      .address(mem_alu_result),
      .input_data(mem_rs2_data),
      .mem_write(mem_mem_write),
      .mem_read(mem_mem_read),
      .mem_type(`MEM_RAM),
      .clock(cpu_clock),
      .output_data(mem_mem_data)
      //.wb_peripheral_bus(wb_peripheral_bus),
      //.peripheral_bus(peripheral_bus)
  );

  mem_wb_pipeline_registers mem_wb_pipeline_registers (
    .clock(cpu_clock),
    .mem_alu_result(mem_alu_result),
    .mem_mem_data(mem_mem_data),
    .mem_rd(mem_rd),
    .mem_reg_write(mem_reg_write),
    .mem_mem_read(mem_mem_read),
    .wb_alu_result(wb_alu_result),
    .wb_mem_data(wb_mem_data),
    .wb_rd(wb_rd),
    .wb_reg_write(wb_reg_write),
    .wb_mem_read(wb_mem_read)
  );
endmodule

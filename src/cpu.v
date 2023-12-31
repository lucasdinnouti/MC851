module cpu (
    input wire clock,
    input wire [3:0] input_peripherals,
    output wire [3:0] output_peripherals,
    output wire [5:0] led
);
  wire [31:0] if_pc;
  wire [31:0] if_l1i_output_data;
  wire [31:0] if_instruction;
  wire if_is_instruction_first_half;
  wire if_is_compact;
  wire if_is_instruction_second_half;

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
  wire [3:0] id_branch_type;
  wire [31:0] id_rs1_data;
  wire [31:0] id_rs2_data;
  wire [31:0] id_pc;
  wire [4:0] id_atomic_op;
  wire id_is_compact;

  wire [31:0] ex_rs1_data;
  wire [31:0] ex_rs2_data;
  wire [31:0] ex_rs1_data_forwarded;
  wire [31:0] ex_rs2_data_forwarded;
  wire [31:0] ex_alu_b;
  wire [4:0] ex_alu_op;
  wire ex_alu_busy;
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
  wire [31:0] ex_pc;
  wire ex_should_branch;
  wire [3:0] ex_branch_type;
  wire [31:0] ex_next_instruction_address;
  wire [31:0] ex_result;
  wire [4:0] ex_atomic_op;
  wire ex_is_compact;

  wire [31:0] mem_result;
  wire [31:0] mem_rs2_data_forwarded;
  wire [4:0] mem_rd;
  wire mem_reg_write;
  wire mem_mem_write;
  wire mem_mem_read;
  wire [2:0] mem_mem_op_length;
  wire [4:0] mem_atomic_op;
  wire [31:0] mem_atomic_result;
  wire [31:0] mem_full_input_data;
  wire [31:0] mem_full_output_data;
  reg [31:0] mem_input_data = 0;
  reg [31:0] mem_output_data = 0;

  wire [31:0] wb_result;
  wire [31:0] wb_rd_data;
  wire [4:0] wb_rd;
  wire wb_reg_write;
  wire [31:0] wb_mem_data;
  wire wb_mem_read;

  wire [31:0] l1i_address;
  wire l1i_hit, l1d_hit;
  wire l1i_ready, l1d_ready;
  wire [31:0] memory_controller_output_data;
  wire [ 1:0] memory_controller_data_source;
  wire stall_l1i, stall_l1d;
  assign l1i_address = if_is_instruction_second_half ? (if_pc + 2) : if_pc;

`ifdef SIMULATOR
  // Uncontrolled clock
  wire cpu_clock;
  assign cpu_clock = clock;
`else
  // Controlled clock
  reg cpu_clock = 0;
  localparam WAIT_TIME = 13500;
  reg [23:0] clock_counter = 0;
  always @(posedge clock) begin
    if (clock_counter < WAIT_TIME) begin
      clock_counter <= clock_counter + 1;
    end else begin
      clock_counter <= 0;
      cpu_clock <= ~cpu_clock;
    end
  end
`endif

  assign led[4]   = ~cpu_clock;
  assign led[3:0] = 4'b1111;

  memory_controller memory_controller (
      .l1i_address(l1i_address),
      .l1d_address(mem_result),
      .l1d_input_data(mem_input_data),
      .l1i_mem_read(~l1i_hit),
      .l1d_mem_write(mem_mem_write),
      .l1d_mem_read(~l1d_hit && mem_mem_read),
      .clock(cpu_clock),
      .input_peripherals(input_peripherals),
      .output_peripherals(output_peripherals),
      .output_data(memory_controller_output_data),
      .data_source(memory_controller_data_source),
      .stall_l1i(stall_l1i),
      .stall_l1d(stall_l1d)
  );

  branch branch (
      .ex_pc(ex_pc),
      .clock(cpu_clock),
      .rs1_data(ex_rs1_data_forwarded),
      .rs2_data(ex_rs2_data_forwarded),
      .immediate(ex_immediate),
      .branch_type(ex_branch_type),
      .if_is_compact(if_is_compact),
      .increment_pc(~if_is_instruction_first_half && ~ex_alu_busy && (ex_should_branch || ~stall_l1i)),
      .if_pc(if_pc),
      .should_branch(ex_should_branch)
  );

  l1 l1i (
      .address(l1i_address),
      .input_data(0),
      .should_write(1'b0),
      .memory_controller_output_data(memory_controller_output_data),
      .should_cache(memory_controller_data_source == `DATA_SOURCE_ROM),
      .memory_controller_ready(~stall_l1i),
      .clock(cpu_clock),
      .output_data(if_l1i_output_data),
      .hit(l1i_hit),
      .ready(l1i_ready)
  );

  assign if_is_compact = (if_instruction[1:0] != 2'b11 && if_instruction != 32'b0);

  fetch fetch (
      .clock(cpu_clock),
      .pc(if_pc),
      .instruction_memory_output(if_l1i_output_data),
      .instruction(if_instruction),
      .is_instruction_first_half(if_is_instruction_first_half),
      .is_instruction_second_half(if_is_instruction_second_half)
  );

  if_id_pipeline_registers if_id_pipeline_registers (
      .clock(cpu_clock),
      .if_instruction(if_instruction),
      .if_pc(if_pc),
      .id_instruction(id_instruction),
      .id_pc(id_pc),
      .reset(ex_should_branch || ~l1i_ready),
      .stall(ex_alu_busy)
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
      .branch_type(id_branch_type),
      .atomic_op(id_atomic_op),
      .is_compact(id_is_compact)
  );

  registers registers (
      .rs1(id_rs1),
      .rs2(id_rs2),
      .rd(wb_rd),
      .data(wb_rd_data),
      .reg_write(wb_reg_write),
      .clock(cpu_clock),
      .rs1_data(id_rs1_data),
      .rs2_data(id_rs2_data)
  );

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
      .id_pc(id_pc),
      .id_branch_type(id_branch_type),
      .id_atomic_op(id_atomic_op),
      .id_is_compact(id_is_compact),
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
      .ex_mem_op_length(ex_mem_op_length),
      .ex_pc(ex_pc),
      .ex_branch_type(ex_branch_type),
      .ex_atomic_op(ex_atomic_op),
      .ex_is_compact(ex_is_compact),
      .reset(ex_should_branch),
      .stall(ex_alu_busy)
  );

  forwarding forwarding (
      .ex_rs1_data(ex_rs1_data),
      .ex_rs2_data(ex_rs2_data),
      .ex_immediate(ex_immediate),
      .ex_rs1(ex_rs1),
      .ex_rs2(ex_rs2),
      .ex_alu_use_rs2(ex_alu_use_rs2),
      .mem_reg_write(mem_reg_write),
      .mem_mem_read(mem_mem_read),
      .mem_rd(mem_rd),
      .mem_result(mem_result),
      .mem_mem_data(mem_output_data),
      .wb_rd(wb_rd),
      .wb_rd_data(wb_rd_data),
      .wb_reg_write(wb_reg_write),
      .rs1_data_forwarded(ex_rs1_data_forwarded),
      .rs2_data_forwarded(ex_rs2_data_forwarded)
  );

  assign ex_alu_b = (ex_alu_use_rs2 == 0) ? ex_immediate : ex_rs2_data_forwarded;

  alu alu (
      .clock(cpu_clock),
      .a(ex_rs1_data_forwarded),
      .b(ex_alu_b),
      .op(ex_alu_op),
      .result(ex_alu_result),
      .busy(ex_alu_busy)
  );

  assign ex_next_instruction_address = ex_pc + (ex_is_compact ? 2 : 4);
  assign ex_result = (ex_branch_type == `BRANCH_JAL || ex_branch_type == `BRANCH_JALR) ? ex_next_instruction_address : ex_alu_result;

  ex_mem_pipeline_registers ex_mem_pipeline_registers (
      .clock(cpu_clock),
      .ex_result(ex_result),
      .ex_rs2_data_forwarded(ex_rs2_data_forwarded),
      .ex_rd(ex_rd),
      .ex_reg_write(ex_reg_write),
      .ex_mem_write(ex_mem_write),
      .ex_mem_read(ex_mem_read),
      .ex_mem_op_length(ex_mem_op_length),
      .ex_atomic_op(ex_atomic_op),
      .mem_result(mem_result),
      .mem_rs2_data_forwarded(mem_rs2_data_forwarded),
      .mem_rd(mem_rd),
      .mem_reg_write(mem_reg_write),
      .mem_mem_write(mem_mem_write),
      .mem_mem_read(mem_mem_read),
      .mem_mem_op_length(mem_mem_op_length),
      .mem_atomic_op(mem_atomic_op),
      .reset(ex_alu_busy)
  );

  assign mem_full_input_data = (mem_atomic_op == `ATOMIC_NO_OP) ? mem_rs2_data_forwarded : mem_atomic_result;

  always @* begin
    case (mem_mem_op_length)
      `MEM_HALF: mem_input_data <= $signed(mem_full_input_data[15:0]);
      `MEM_BYTE: mem_input_data <= $signed(mem_full_input_data[7:0]);
      `MEM_HALF_U: mem_input_data <= {16'b0, mem_full_input_data[15:0]};
      `MEM_BYTE_U: mem_input_data <= {24'b0, mem_full_input_data[7:0]};
      default: mem_input_data <= mem_full_input_data;
    endcase
  end

  always @* begin
    case (mem_mem_op_length)
      `MEM_HALF: mem_output_data <= $signed(mem_full_output_data[15:0]);
      `MEM_BYTE: mem_output_data <= $signed(mem_full_output_data[7:0]);
      `MEM_HALF_U: mem_output_data <= {16'b0, mem_full_output_data[15:0]};
      `MEM_BYTE_U: mem_output_data <= {24'b0, mem_full_output_data[7:0]};
      default: mem_output_data <= mem_full_output_data;
    endcase
  end

  l1 l1d (
      .address(mem_result),
      .input_data(mem_input_data),
      .should_write(mem_mem_write),
      .memory_controller_output_data(memory_controller_output_data),
      .should_cache(memory_controller_data_source == `DATA_SOURCE_RAM),
      .memory_controller_ready(~stall_l1d),
      .clock(cpu_clock),
      .output_data(mem_full_output_data),
      .hit(l1d_hit),
      .ready(l1d_ready)
  );

  atomic atomic (
      .a(mem_output_data),
      .b(mem_rs2_data_forwarded),
      .op(mem_atomic_op),
      .result(mem_atomic_result)
  );

  mem_wb_pipeline_registers mem_wb_pipeline_registers (
      .clock(cpu_clock),
      .mem_result(mem_result),
      .mem_mem_data(mem_output_data),
      .mem_rd(mem_rd),
      .mem_reg_write(mem_reg_write),
      .mem_mem_read(mem_mem_read),
      .wb_result(wb_result),
      .wb_mem_data(wb_mem_data),
      .wb_rd(wb_rd),
      .wb_reg_write(wb_reg_write),
      .wb_mem_read(wb_mem_read),
      .reset(1'b0)
  );

  assign wb_rd_data = wb_mem_read == 0 ? wb_result : wb_mem_data;
endmodule

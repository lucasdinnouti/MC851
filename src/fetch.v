module fetch (
  input wire clock,
  input wire [31:0] pc,
  input wire [31:0] instruction_memory_output,
  output reg [31:0] instruction,
  output wire misaligned_instruction,
  output reg previous_misaligned = 0
);
  reg [15:0] previous_instruction_half = 0;

  reg [31:0] previous_pc = 0;

  assign misaligned_instruction = pc[1] == 1 && !previous_misaligned;
  assign pc_changed = pc != previous_pc;

  always @(posedge clock) begin
    previous_pc = pc;

    if (previous_misaligned) begin
      previous_misaligned <= 0;
    end else if (misaligned_instruction && !pc_changed) begin
      previous_instruction_half <= instruction_memory_output[31:16];
      previous_misaligned <= 1;
    end
  end

  always @* begin
    if (previous_misaligned) begin
      instruction <= {instruction_memory_output[15:0], previous_instruction_half};
    end else if (misaligned_instruction) begin
      instruction <= 0;
    end else begin
      instruction <= instruction_memory_output;
    end
  end
endmodule
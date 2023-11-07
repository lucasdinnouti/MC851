module fetch (
  input wire clock,
  input wire [31:0] pc,
  input wire [31:0] instruction_memory_output,
  output reg [31:0] instruction,
  output wire misaligned_instruction
);
  reg [15:0] previous_instruction_half = 0;
  reg previous_misaligned = 0;

  assign misaligned_instruction = pc[1] == 1;

  always @(posedge clock) begin
    if (previous_misaligned) begin
      previous_misaligned <= 0;
    end else if (misaligned_instruction) begin
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
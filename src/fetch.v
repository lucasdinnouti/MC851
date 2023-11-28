module fetch (
    input wire clock,
    input wire [31:0] pc,
    input wire [31:0] instruction_memory_output,
    output reg [31:0] instruction,
    output wire is_instruction_first_half,
    output wire is_instruction_second_half
);
  reg [15:0] previous_instruction_half = 0;
  reg previous_was_first_half = 0;

  reg [31:0] previous_pc = 0;
  assign pc_changed = pc != previous_pc;

  assign is_instruction_first_half = pc[1] == 1 && !is_instruction_second_half;
  assign is_instruction_second_half = previous_was_first_half && !pc_changed;

  always @(posedge clock) begin
    previous_pc <= pc;

    if (previous_was_first_half) begin
      previous_was_first_half <= 0;
    end else if (is_instruction_first_half) begin
      previous_instruction_half <= instruction_memory_output[31:16];
      previous_was_first_half   <= 1;
    end
  end

  always @* begin
    if (is_instruction_second_half) begin
      instruction <= {instruction_memory_output[15:0], previous_instruction_half};
    end else if (is_instruction_first_half) begin
      instruction <= 0;
    end else begin
      instruction <= instruction_memory_output;
    end
  end
endmodule

module if_id_pipeline_registers(
  input wire clock,
  input wire [31:0] if_instruction,
  input wire [31:0] if_pc,
  input wire reset,
  input wire stall,
  input wire forward_pc,
  output wire [31:0] id_instruction,
  output wire [31:0] id_pc
);
  reg [31:0] instruction = 0;
  reg [31:0] pc = 0;

  assign id_instruction = instruction;
  assign id_pc = pc;

  always @(posedge clock) begin
    if (reset) begin
      instruction <= 0;
    end else if (!stall) begin
      instruction <= if_instruction;
    end

    if (forward_pc) begin
      pc <= if_pc;
    end else begin
      // Do nothing (keep pc value)
    end
  end
endmodule
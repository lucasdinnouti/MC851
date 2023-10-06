module if_id_pipeline_registers(
  input wire clock,
  input wire [31:0] if_instruction,
  input wire [31:0] if_pc,
  input wire stall,
  output wire [31:0] id_instruction,
  output wire [31:0] id_pc
);
  reg [31:0] instruction = 0;
  // TODO: check better way to do this
  // To run on simulator change to -8
  reg [31:0] pc = -4;

  assign id_instruction = instruction;
  assign id_pc = pc;

  always @(posedge clock) begin
    if (stall) begin
      instruction <= 0;
    end else begin
      instruction <= if_instruction;
      pc <= if_pc;
    end
  end
endmodule
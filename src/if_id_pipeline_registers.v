module if_id_pipeline_registers(
  input wire clock,
  input wire [31:0] if_instruction,
  output wire [31:0] id_instruction,
);
  reg [31:0] instruction = 0;

  assign id_instruction = instruction;

  always @(posedge clock) begin
    instruction <= if_instruction;
  end
endmodule
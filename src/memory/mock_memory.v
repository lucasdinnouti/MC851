module memory (
    input wire [31:0] address,
    input wire [31:0] input_data,
    input wire [31:0] wb_peripheral_bus,
    input wire mem_write,
    input wire mem_read,
    input wire mem_type,
    input wire clock,
    output reg [31:0] output_data = 0,
    output wire [31:0] peripheral_bus
);

  reg [31:0] ram[31:0];
  reg [31:0] rom[31:0];

  integer i;
  initial begin
    for (i = 0; i < 64; i = i + 1) begin
      ram[i] = 0;
      rom[i] = 0;
    end

    $readmemh("../resources/full-instruction-set.riscv", rom);
  end

  always @(posedge clock) begin
    if (mem_write) begin
      case (mem_type)
        `MEM_ROM: rom[address] = input_data;
        `MEM_RAM: ram[address] = input_data;
      endcase
    end
    ram[63] = wb_peripheral_bus;
  end

  always @(negedge clock) begin
    if (mem_read) begin
      case (mem_type)
        `MEM_ROM: output_data = rom[address];
        `MEM_RAM: output_data = ram[address];
      endcase
    end
    peripheral_bus[31:0] = ram[63];
  end
endmodule

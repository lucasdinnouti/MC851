module memory (
    input wire [31:0] address,
    input wire [31:0] input_data,
    input wire mem_write,
    input wire mem_read,
    input wire clock,
    input wire mem_type,
    output wire [31:0] output_data
);

  reg [31:0] ram[63:0];
  reg [31:0] rom[63:0];

  integer i;
  initial begin
    for (i = 0; i < 64; i = i + 1) begin
      ram[i] = 0;
      rom[i] = 0;
    end

    // Test code
    rom[0]  = 8'h00100113;
    rom[1]  = 8'h00200193;
    rom[2]  = 8'h000000b3;
    rom[3]  = 8'h003080b3;
    rom[4]  = 8'h402080b3;
    rom[5]  = 8'h003080b3;
    rom[6]  = 8'h402080b3;
    rom[7]  = 8'h003080b3;
    rom[8]  = 8'h402080b3;
    rom[9]  = 8'h03f0c093;
    rom[10] = 8'h03f00093;
    rom[11] = 8'h00000093;
  end

  always @(posedge clock) begin
    if (mem_write) begin
      case (mem_type)
        `MEM_ROM: rom[address] = input_data;
        `MEM_RAM: ram[address] = input_data;
      endcase
    end
    if (mem_read) begin
      case (mem_type)
        `MEM_ROM: output_data = rom[address];
        `MEM_RAM: output_data = ram[address];
      endcase
    end
  end
endmodule

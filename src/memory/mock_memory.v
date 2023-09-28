module memory (
    input wire [31:0] address,
    input wire [31:0] input_data,
    //input wire [31:0] wb_peripheral_bus,
    input wire mem_write,
    input wire mem_read,
    input wire mem_type,
    input wire clock,
    output reg [31:0] output_data = 0
    //output wire [31:0] peripheral_bus
);

  reg [31:0] ram[63:0];
  reg [31:0] rom[63:0];

  integer i;
  initial begin
    for (i = 0; i < 64; i = i + 1) begin
      ram[i] = 0;
      rom[i] = 0;
    end

    
    // main:
    // 0:  addi x5, zero, 3
    // 4:  sw x5, 0(zero)
    // 8:  jal x1, function
    // 12:  addi x5, zero, 10
    // 16:  mul x10, x10, x5
    // 20:  addi x5, zero, 100
    // 24:  beq x10, x5, success
    // 28:  j fail
    // function:
    // 32:  lw x5, 0(zero)
    // 36:  addi x10, zero, 0
    //   loop:
    // 40:    add x10, x10, x5
    // 44:    addi x5, x5, -1
    // 48:    bne x5, zero, loop
    // 52:  addi x10, x10, 4
    // 56:  jalr zero, x1, 0
    // 60:  j fail
    // success:
    // 64:  addi x1, zero, 15
    // 68:  j end
    // fail:
    // 72:  addi x1, zero, 8
    //   end:
    rom[0] = 32'h00300293;
    rom[1] = 32'h00502023;
    rom[2] = 32'h018000ef;
    rom[3] = 32'h00a00293;
    rom[4] = 32'h02550533;
    rom[5] = 32'h06400293;
    rom[6] = 32'h02550463;
    rom[7] = 32'h02c0006f;
    rom[8] = 32'h00002283;
    rom[9] = 32'h00000513;
    rom[10] = 32'h00550533;
    rom[11] = 32'hfff28293;
    rom[12] = 32'hfe029ce3;
    rom[13] = 32'h00450513;
    rom[14] = 32'h00008067;
    rom[15] = 32'h00c0006f;
    rom[16] = 32'h00f00093;
    rom[17] = 32'h0080006f;
    rom[18] = 32'h00800093;

    //ram[63] = 32'b00000000000000000000000000000001;
  end

  always @(posedge clock) begin
    if (mem_write) begin
      case (mem_type)
        `MEM_ROM: rom[address] = input_data;
        `MEM_RAM: ram[address] = input_data;
      endcase
    end
   // ram[63] = wb_peripheral_bus;

  end
  always @(negedge clock) begin
    if (mem_read) begin
      case (mem_type)
        `MEM_ROM: output_data = rom[address];
        `MEM_RAM: output_data = ram[address];
      endcase
    end
    //peripheral_bus[31:0] = ram[63];
  end
endmodule

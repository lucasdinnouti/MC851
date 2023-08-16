`timescale 1 ns/10 ps

module test_cpu_tb;
    reg [31:0] instruction;
    reg clock;

    localparam PERIOD = 10;

    test_cpu test_cpu(.instruction(instruction), .clock(clock));
    
    initial begin
        $dumpfile("test_cpu.vcd");
        $dumpvars(0, test_cpu_tb);
    end

    initial begin
        // addi x5, x6, 7
        instruction = 32'b00000000011100110000001010010011;
        #PERIOD;
        clock = ~clock;
        #PERIOD;
        clock = ~clock;
        #PERIOD;
    end
endmodule
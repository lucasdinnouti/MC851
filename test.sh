#!/bin/sh

echo "Running ALU tests"
iverilog src/constants.v test/assert.v src/alu.v test/alu_tb.v && ./a.out

echo "Running registers tests"
iverilog test/assert.v src/registers.v test/registers_tb.v && ./a.out

echo "Running decoder tests"
iverilog src/constants.v test/assert.v src/decoder.v test/decoder_tb.v && ./a.out

echo "Running CPU mock tests"
iverilog test/mock_cpu_tb.v && ./a.out
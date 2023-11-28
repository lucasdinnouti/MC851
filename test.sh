#!/bin/sh

cd src

echo "-> Running ALU tests"
iverilog constants.v ../test/assert.v divider.v alu.v ../test/alu_tb.v && ./a.out
echo

echo "-> Running registers tests"
iverilog ../test/assert.v registers.v ../test/registers_tb.v && ./a.out
echo

echo "-> Running decoder tests"
iverilog constants.v ../test/assert.v decoder.v ../test/decoder_tb.v && ./a.out
echo

echo "-> Running CPU test"
iverilog -DSIMULATOR -DPROGRAM='`"full-instruction-set.riscv`"' constants.v alu.v branch.v decoder.v memory/memory_controller.v memory/ram.v memory/rom.v memory/l1.v memory/peripherals.v registers.v ex_mem_pipeline_registers.v id_ex_pipeline_registers.v if_id_pipeline_registers.v mem_wb_pipeline_registers.v forwarding.v atomic.v divider.v cpu.v ../test/assert.v ../test/cpu_tb.v && ./a.out

rm a.out
cd ..

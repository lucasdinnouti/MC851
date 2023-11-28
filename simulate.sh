#!/bin/bash

PROGRAM="\`\"$1.riscv\`\""

echo "Simulating CPU with program $PROGRAM"
cd src
iverilog -DSIMULATOR -DPROGRAM=$PROGRAM constants.v alu.v branch.v decoder.v memory/memory_controller.v memory/ram.v memory/rom.v memory/l1.v memory/peripherals.v registers.v ex_mem_pipeline_registers.v id_ex_pipeline_registers.v if_id_pipeline_registers.v mem_wb_pipeline_registers.v forwarding.v atomic.v divider.v fetch.v cpu.v ../test/assert.v ../test/cpu_tb.v && ./a.out
rm a.out
cd ..

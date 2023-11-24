#!/bin/bash

PROGRAM=compile/programs/$1
OUTPUT=src/resources/$1-compiled.riscv

riscv32-unknown-elf-gcc -c compile/header.s -g -march=rv32im -std=gnu99 -mabi=ilp32
riscv32-unknown-elf-gcc -g -march=rv32im -std=gnu99 -mabi=ilp32 $PROGRAM.c -o $PROGRAM.elf -T compile/linker.ld -nostartfiles -lc -lm

echo "// ============================================================" > $OUTPUT
cat $PROGRAM.c | awk '{print "// "$0}' >> $OUTPUT
echo "// ============================================================" >> $OUTPUT
riscv32-unknown-elf-objdump -j .text -d $PROGRAM.elf | grep -A 99999 "Disassembly of section .text" | tail -n +3 | awk '{print "// "$0}' >> $OUTPUT
echo "// ============================================================" >> $OUTPUT
riscv32-unknown-elf-objcopy --gap-fill 0x00 -O binary $PROGRAM.elf $PROGRAM.bin
xxd -c 4 -e $PROGRAM.bin | awk '{print $2}' >> $OUTPUT

rm $PROGRAM.elf
rm $PROGRAM.bin
rm header.o
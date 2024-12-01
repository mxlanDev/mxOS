set architecture x86_64 
layout asm
layout reg
set disassembly-flavor intel
target remote localhost:26000
symbol-file kernel/build/kernel.elf
b *0x7c00
b main

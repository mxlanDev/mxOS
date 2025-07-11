set architecture i386:x86-64
layout asm
layout reg
set disassembly-flavor intel
target remote localhost:26000
watch *(unsigned long long)0x10000 == 0xDEADBEEF
continue
set $base = *(unsigned long long)0x10008
add-symbol-file bootloader/build/bootx64.efi.debug -o $base


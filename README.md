# mxOS
Simple kernel and bootloader written in x86 Assembly.
Bootloader currently loading in Realmode.

Bootloader TODOs: Implementing UEFI, changing to long mode<br>
Kernel TODOS: Terminal window, memory management, etc...

# Dependencies

Gcc x86_64 elf compiler <br>
Qemu <br>
OVMF <br>
Make <br>
mtools <br>
gnu-efi <br>

# Building 
```bash
git clone https://github.com/mxlanDev/mxOS.git
cd mxOS
make
```

# Building

```bash
make qemu
```

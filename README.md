# mxOS

A simple kernel and bootloader written in x86 Assembly and C. The master branch contains a legacy BIOS bootloader operating in Real Mode. The UEFI branch introduces a modern UEFI bootloader using gnu-efi.

## Project Status

### Master Branch
- [x] Real Mode BIOS bootloader
- [x] FAT12 loading
- [x] Basic kernel entry

### UEFI Branch
- [ ] UEFI bootloader using gnu-efi
- [ ] Switch to Long Mode
- [ ] Terminal window
- [ ] Memory management

## Dependencies

| Package | Purpose |
|---------|---------|
| gcc (x86_64 elf) | Cross-compiler for kernel and bootloader |
| nasm | Assembler for legacy bootloader |
| qemu | System emulation |
| OVMF | UEFI firmware for QEMU |
| make | Build orchestration |
| mtools | FAT image manipulation |
| gnu-efi | UEFI development libraries |
| binutils | ld, objcopy for linking and binary generation |

## Building

### Master Branch (Legacy BIOS)

```bash
git clone https://github.com/mxlanDev/mxOS.git
cd mxOS
make
```

### UEFI branch

```bash
git clone https://github.com/mxlanDev/mxOS.git
cd mxOS
git checkout uefi
make
```

## Running

```bash
make qemu
```

## Licence

See LICENSE file for details

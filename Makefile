.POSIX:
.DELETE_ON_ERROR:

KERNEL_DIR:= kernel
KERNEL_BIN:= $(KERNEL_BIN)/build/kernel.elf

BOOT_DIR:= bootloader 
BOOT_BIN:= $(BOOT_DIR)/build/kernel.elf

BUILD_DIR:= build
DISK_IMG:=$(BUILD_DIR)/disk.img
DISK_IMG_SIZE:=2880

QEMU_FLAGS:=-bios OMVF.fd \
						-drive if=none,id=uas-disk1,file=${DISK_IMG},format=raw \
						-device usb-storage,drive=uas-disk1 \
						-serial stdio \
						-usb\
						-vga std \
						-net none

all: $(DISK_IMG) 

.PHONY: all clean qemu

$(BOOT_BIN):
	make -C bootloader

$(KERNEL_BIN):
	make -C kernel 

$(DISK_IMG): ${BUILD_DIR} ${BOOT_BIN} ${KERNEL_BIN}
	# @echo "size is $(size)"
	# @echo "count is $(count)"
	dd if=/dev/zero of=$(DISK_IMG) bs=512 count=$(DISK_IMG_SIZE)
	mformat -i ${DISK_IMG} -f ${DISK_IMG_SIZE} ::
	mmd -i ${DISK_IMG} ::/EFI
	mmd -i ${DISK_IMG} ::/EFI/BOOT
	# Copy the bootloader to the boot partition.
	mcopy -i ${DISK_IMG} ${BOOT_BIN} ::/efi/boot/bootx64.efi
	mcopy -i ${DISK_IMG} ${KERNEL_BIN} ::/kernel.elf
debug:
	qemu-system-x86_64 -machine q35 -fda $(DISK_IMG) -gdb tcp::26000 -S

qemu:
	qemu-system-x86_64 $(QEMU_FLAGS) $(DISK_IMG) -gdb tcp::26000 -S

clean:
	make -C $(BOOT_DIR) clean
	make -C $(KERNEL_DIR) clean
	rm -f $(DISK_IMG)
	rm -rf $(BUILD_DIR)

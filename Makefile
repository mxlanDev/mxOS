.POSIX:
.DELETE_ON_ERROR:

KERNEL_DIR:= kernel
KERNEL_BIN:= $(KERNEL_DIR)/build/kernel.elf

BOOT_DIR:= bootloader
BOOT_BIN:= $(BOOT_DIR)/build/bootx64.efi

BUILD_DIR:= build
DISK_IMG:=$(BUILD_DIR)/disk.img
DISK_IMG_SIZE:=2880

OVMF_PATH := /usr/share/OVMF

QEMU_FLAGS:=-drive if=pflash,format=raw,unit=0,file=${OVMF_PATH}/OVMF_CODE.fd,readonly=on \
  					-drive if=pflash,format=raw,unit=1,file=${OVMF_PATH}/OVMF_VARS.fd,\
						-serial mon:stdio \
						-usb \
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
	mcopy -i ${DISK_IMG} ${KERNEL_BIN} ::/kernel.elf
	mcopy -i ${DISK_IMG} ${BOOT_BIN} ::/efi/boot/BOOTX64.EFI
debug:
	qemu-system-x86_64 -machine q35 -fda $(DISK_IMG) -gdb tcp::26000 -S

qemu:
	qemu-system-x86_64 $(QEMU_FLAGS) $(DISK_IMG) -gdb tcp::26000 -S

${BUILD_DIR}:
	mkdir -p ${BUILD_DIR}

clean:
	make -C $(BOOT_DIR) clean
	make -C $(KERNEL_DIR) clean
	rm -f $(DISK_IMG)
	rm -rf $(BUILD_DIR)

.POSIX:
.DELETE_ON_ERROR:

ARCH:= x86_64
CC:= ${ARCH}-elf-gcc

BUILD_DIR:= build
SRC_DIR:= src
OBJ_DIR:=${SRC_DIR}/obj

EFI_INC_DIR:= /usr/include/efi
INCLUDE_DIRS:= ${EFI_INC_DIR} \
	${EFI_INC_DIR}/${ARCH} \
	${EFI_INC_DIR}/protocol \
	inc

INCLUDE_FLAG := $(foreach d, $(INCLUDE_DIRS), -I$d)

CFLAGS := ${INCLUDE_FLAG} \
	-ffreestanding \
	-fno-common \
	-fno-stack-protector \
	-fno-stack-check \
	-fpic \
	-fshort-wchar \
	-mno-red-zone \
	-Wall \
	-Wextra \
	-Wmissing-prototypes \
	-Wstrict-prototypes \
	-DEFI_FUNCTION_WRAPPER

LIB          := /usr/lib
EFI_LIB      := /usr/lib
EFI_CRT_OBJS := ${EFI_LIB}/crt0-efi-${ARCH}.o
EFI_LDS      := ${EFI_LIB}/elf_${ARCH}_efi.lds
LDFLAGS      := -nostdlib \
	-znocombreloc \
	-T ${EFI_LDS} \
	-shared \
	-Bsymbolic \
	-L ${EFI_LIB} \
	-L ${LIB} ${EFI_CRT_OBJS}


C_SOURCES := ${SRC_DIR}/elf.c

OBJECTS := ${OBJ_DIR}/main.o 

BINARY_ELF := ${BUILD_DIR}/bootx64.so

BINARY_EFI := ${BUILD_DIR}/bootx64.efi


.PHONY: all clean emu

all: ${BINARY_EFI}

${BINARY_EFI}: ${BINARY_ELF}
	objcopy -j .text \
		-j .sdata \
		-j .data \
		-j .dynamic \
		-j .dynsym \
		-j .rel \
		-j .rela \
		-j .reloc \
		--target=efi-app-${ARCH} $^ $@

${BINARY_ELF}: ${BUILD_DIR} ${OBJECTS} 
	ld ${LDFLAGS} ${OBJECTS} -o $@ -lefi -lgnuefi

${OBJ_DIR}/%.o: ${SRC_DIR}/%.c
	${CC} ${CFLAGS} -c $< -o $@

${BUILD_DIR}:
	mkdir -p ${BUILD_DIR}

${OBJ_DIR}:
	mkdir -p ${OBJ_DIR}

clean:
	rm -f ${OBJECTS}
	rm -f ${BINARY_ELF}
	rm -f ${BINARY_EFI}
	rm -rf ${BUILD_DIR}

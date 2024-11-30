.POSIX:
.DELETE_ON_ERROR:

SRC_DIR:= src
INC_DIR:= inc
INC_FLAG:= ${foreach d, $(INC_DIR),-I$d}

DIRS:= build
$(info $(shell mkdir -p $(DIRS)))

BUILD_DIR:= $(DIRS)

ARCH:=x86_64
CC:=$(ARCH)-elf-gcc

CFLAGS:= -std=gnu99 -ffreestanding -fno-common -O2 -mno-red-zone -Wall -Wextra

LDFLAGS:=-ffreestanding -O2 -nostdlib -z max-page-size=0x1000

C_SRC:= $(SRC_DIR)/kernel.c

OBJECTS:= $(C_SRC:.c=.o)

BINARY:= ${BUILD_DIR}/kernel.elf

.PHONY: all clean

all: kernel 

kernel: ${BUILD_DIR} ${OBJECTS}
	${CC} -T ${SRC_DIR}/kernel.ld -g3 -o ${BINARY} ${LDFLAGS} ${OBJECTS} -lgcc

%.o: %.c
	${CC} ${INCLUDE_FLAG} -g -c $< -o $@ ${CFLAGS} 

clean:
	rm -f ${OBJECTS}
	rm -f ${BINARY}

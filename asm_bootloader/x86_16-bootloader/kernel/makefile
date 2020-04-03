CC	=	gcc

DISK	=	../disk.img

SRC	=	./C_kernel/main.c

OBJ	=	$(SRC:%.c=%.o)

NAME	=	$(SRC:%.c=%)


CFLAGS	+=	-ffreestanding -nostdlib -gdwarf-4 -m32 -ggdb3 -masm=intel

all: 		$(DISK)

$(DISK):	$(OBJ)
		ld -m elf_i8086 -nmagic -T main.lds $(OBJ) -o ./kernel

clean:
		rm $(OBJ)


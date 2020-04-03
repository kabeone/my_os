CC          = nasm
DISK        = disk.img
SIZE_SECTOR = 512

BOOTLOADER  = ./boot/bootloader.asm
BOOTL_ELF   = ./boot/bootloader.elf
BOOTL_OBJ   = ./boot/bootloader

KERNEL	    = ./kernel/kernel

CFLAGS      = -f bin

RM 	    = rm -rf



all:		$(DISK)

$(BOOTL_OBJ): 	$(BOOTLOADER)
		nasm $(BOOTLOADER) -f elf -F dwarf -g -o $(BOOTL_ELF)
		objcopy -O binary $(BOOTL_ELF) $(BOOTL_OBJ)

$(DISK):	$(BOOTL_OBJ)
		cd kernel && make
		dd if=/dev/zero of=$(DISK) bs=$(SIZE_SECTOR) count=2880
		dd conv=notrunc if=$(BOOTL_OBJ) of=$(DISK) bs=$(SIZE_SECTOR) count=1 seek=0
		dd conv=notrunc if=$(KERNEL) of=$(DISK) bs=$(SIZE_SECTOR) count=$$(($(shell stat --printf="%s" $(KERNEL))/512)) seek=1


clean:
		$(RM) $(DISK)

fclean:		clean
		$(RM) $(BOOTL_OBJ)

re:		fclean all

qemu:
	qemu-system-i386 -machine q35 -fda $(DISK) -gdb tcp::26000 -S

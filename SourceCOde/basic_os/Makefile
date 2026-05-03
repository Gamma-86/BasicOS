include common_vars.mk


all:
	make clean
	make multiboot_DVDtest.iso



multiboot.o: $(PathTo_Multiboot_files)/multiboot.nasm
	nasm  \
		$(NASM_default_flags) \
		-i$(PathTo_Multiboot_files) \
		-f elf32 \
		$(PathTo_Multiboot_files)/multiboot.nasm \
		-o multiboot_ASM.o
	$(C_compiler) \
		$(C_default_flags) \
		$(PathTo_Multiboot_files)/multiboot.c \
		-I$(PathTo_Multiboot_files)\
		-c \
		-o multiboot_C.o
	$(LINKER) -m elf_i386 -r multiboot_ASM.o multiboot_C.o -o multiboot.o
	mv  multiboot.o ./BIN_OBJ_filesDump/
	rm  multiboot_ASM.o
	rm  multiboot_C.o

multiboot.elf:
	make multiboot.o
	ld -m elf_i386 -T $(Linker_Script_Full_Path)  $(PathTo_BIN_OBJ_filesDump)/multiboot.o -o $(PathTo_BIN_OBJ_filesDump)/multiboot.elf
	rm $(PathTo_BIN_OBJ_filesDump)/multiboot.o

multiboot_DVDtest.iso:
	make multiboot.elf
	mv $(PathTo_BIN_OBJ_filesDump)/multiboot.elf $(PathTo_GrubDiskSystem)/boot
	grub-mkrescue $(PathTo_GrubDiskSystem) -o $(PathTo_BIN_OBJ_filesDump)/multiboot_DVDtest.iso

clean:
	rm -f *.o *.so
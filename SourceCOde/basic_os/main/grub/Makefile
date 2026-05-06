include $(Include1_For_MakeSubDirs_PathFull)


multiboot.o:
	nasm  \
		$(NASM_default_flags) \
		-i$(PathTo_Multiboot_files) \
		-f elf32 \
		multiboot.nasm \
		-o multiboot_ASM.o
	nasm \
		$(NASM_default_flags)\
		-i$(PathTo_Multiboot_files)
		-f elf32 \
		./PortDebugOutput/PortDebugOutput.nasm \
		-o multiboot_port.o
	$(C_compiler) \
		$(C_default_flags) \
		multiboot.c \
		-I$(PathTo_Multiboot_files)\
		-c -o multiboot_C.o
	$(LINKER) -m elf_i386 -r multiboot_ASM.o multiboot_C.o multiboot_port.o -o multiboot.o
	rm  multiboot_ASM.o
	rm  multiboot_C.o
	rm  multiboot_port.o


multiboot.elf: multiboot.o
	$(LINKER) -m elf_i386 -T $(Linker_Script_Full_Path)  multiboot.o -o multiboot.elf
	rm multiboot.o
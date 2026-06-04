all:

debug_high_level:
	nasm -f elf32 -Ddebug_high_level $(NASM_default_flags) main_gdt.nasm -o main_gdt_NASM.o
	$(ADA_compiler) $(ADA_default_flags) -c x86_protection.adb -o x86_protection.o
	$(ADA_compiler) $(ADA_default_flags) -c main_gdt.adb -o main_gdt_ADA.o
	$(LINKER) -m elf_i386 -r main_gdt_ADA.o main_gdt_NASM.o x86_protection.o -o main_gdt.o
	rm main_gdt_ADA.o
	rm main_gdt_NASM.o
	rm x86_protection.o
	gcc  main_gdt_test.c main_gdt.o -o main_gdt_test
all:
	make clean


InitialAllocators.o:
	$(C_Compiler) \
		$(C_default_flags)\
		InitialAllocators.c\
		-f elf32\
		-c -o InitialAllocators_C.o

InitialAllocators.elf: InitialAllocators_C.o
	$(LINKER) -m elf_i386 -T $(PathToFull_Linker_Script)  \
	InitialAllocators_C.o \
	-o InitialAllocators.elf
	rm InitialAllocators_C.o

Testing:
	gcc InitialAllocators.c InitialAllocators_test.c -f elf32 -g -Wall -o InitialAllocators_test.elf
	

clean:
	rm -f ./*.o
	rm -f ./*.elf
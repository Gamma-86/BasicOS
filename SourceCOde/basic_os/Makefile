PathTo_32bitKernel = ./main/32bit

PathTo_Multiboot_files = ./main/grub

PathTo_OS_return_codes = ./main/OS_includes



PathTo_MemoryManagers = ./main/32bit/KernelMemoryManagers
PathTo_IntitalRAMAllocators = $(PathTo_MemoryManagers)/allocators/IntialAllocators


PathTo_NASM_default_macroses = .
PathTo_IA32Macroses_NASM = ./includes_i686

PathTo_ADA_INCLUDES = ./includes_i686/adainclude
PathTo_GNAT_ADC = ./includes_i686/adaCompConfig/gnat.adc

PathTo_OS_include = ./main/Kernel/OS_includes

ADA_default_flags = -I$(PathTo_OS_include)/ -gnatp -ffreestanding -nostdlib -fno-exceptions -gnatec=$(PathTo_GNAT_ADC)
NASM_default_flags = -i$(PathTo_OS_include)/ -i$(PathTo_NASM_default_macroses)/ -i$(PathTo_IA32Macroses_NASM)/ -g
C_default_flags = -I$(PathTo_OS_include)/ -m32 -ffreestanding -fno-stack-protector -fno-pic -fno-pie

C_compiler = ~/crossCOMPs/gccses/bin/i686-elfNoOS-gcc
ADA_compiler = ~/crossCOMPs/gccses/bin/i686-elfNoOS-gcc
ASSEMBLER = nasm
LINKER = ld

PathTo_LinkerScript = ./main/grub

all:
	make clean
	make multiboot.o



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
		-o multiboot_C.o
	$(LINKER) -r multiboot_ASM.o multiboot_C -o multiboot.o
	mv  multiboot.o ./BIN_OBJ_filesDump/


clean:
	rm -f *.o *.so
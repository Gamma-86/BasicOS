
PathTo_32bitKernel = ./main/32bit

PathTo_Multiboot_files = ./main/grub
Linker_Script_Full_Path = ./main/grub/link.ld
PathTo_BIN_OBJ_filesDump = ./BIN_OBJ_filesDump
PathTo_GrubDiskSystem = ./test_disk

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
C_default_flags = -I$(PathTo_OS_include)/ -Wall -g -m32 -ffreestanding -fno-stack-protector -fno-pic -fno-pie

C_compiler = ~/crossCOMPs/gccses/bin/i686-elfNoOS-gcc
ADA_compiler = ~/crossCOMPs/gccses/bin/i686-elfNoOS-gcc
ASSEMBLER = nasm
LINKER = ld

PathTo_LinkerScript = ./main/grub

CURRENT_DIR := $(CURDIR)
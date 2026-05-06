
PathTo_32bitKernel = $(ROOT)/main/32bit

PathTo_Multiboot_files = $(ROOT)/main/grub
Linker_Script_Full_Path = $(ROOT)/main/grub/link.ld
PathTo_BIN_OBJ_filesDump = $(ROOT)/BIN_OBJ_filesDump
PathTo_GrubDiskSystem = $(ROOT)/test_disk

PathTo_OS_return_codes = $(ROOT)/main/OS_includes



PathTo_MemoryManagers = $(ROOT)/main/32bit/KernelMemoryManagers
PathTo_IntitalRAMAllocators = $(ROOT)/$(PathTo_MemoryManagers)/allocators/IntialAllocators


PathTo_NASM_default_macroses = $(ROOT)
PathTo_IA32Macroses_NASM = $(ROOT)/includes_i686

PathTo_ADA_INCLUDES = $(ROOT)/includes_i686/adainclude
PathTo_GNAT_ADC = $(ROOT)/includes_i686/adaCompConfig/gnat.adc

PathTo_OS_include = $(ROOT)/main/Kernel/OS_includes

ADA_default_flags = -I$(PathTo_OS_include)/ -gnatp -ffreestanding -nostdlib -fno-exceptions -gnatec=$(PathTo_GNAT_ADC)
NASM_default_flags = -i$(PathTo_OS_include)/ -i$(PathTo_NASM_default_macroses)/ -i$(PathTo_IA32Macroses_NASM)/ -g
C_default_flags = -I$(PathTo_OS_include)/ -Wall -g -m32 -ffreestanding -fno-stack-protector -fno-pic -fno-pie

C_compiler = ~/crossCOMPs/gccses/bin/i686-elfNoOS-gcc
ADA_compiler = ~/crossCOMPs/gccses/bin/i686-elfNoOS-gcc
ASSEMBLER = as
LINKER = ld

PathTo_LinkerScript = $(ROOT)/main/grub


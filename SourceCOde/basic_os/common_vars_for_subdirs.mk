#Important Pathes
PathTo_Kernel = $(ROOT)/main/Kernel
PathTo_LinkerScript = $(ROOT)/main/grub
PathTo_GrubDiskSystem = $(ROOT)/test_disk

#Pathes for assemblers and compilers setting
PathTo_Multiboot_files = $(ROOT)/main/grub
Linker_Script_Full_Path = $(ROOT)/main/grub/link.ld
PathTo_BIN_OBJ_filesDump = $(ROOT)/BIN_OBJ_filesDump


#General Include Pathes
PathTo_OS_return_codes = $(ROOT)/main/OS_includes
PathTo_OS_include = $(ROOT)/main/Kernel/OS_includes

#Pathes to different modules and other stuff
PathTo_MemoryManagers = $(ROOT)/$(PathTo_Kernel)/KernelMemoryManagers
PathTo_IntitalRAMAllocators = $(PathTo_MemoryManagers)/allocators/IntialAllocators

#Pathes for NASM includes
PathTo_NASM_default_macroses = $(ROOT)/includes_i686/NASM_Macroses
PathTo_IA32Macroses_NASM = $(ROOT)/includes_i686/NASM_Macroses

#path for ADA includes
PathTo_ADA_INCLUDES = $(ROOT)/includes_i686/adainclude
PathTo_GNAT_ADC = $(ROOT)/includes_i686/adaCompConfig/gnat.adc


#Compilers options
ADA_default_flags = -I$(PathTo_OS_include)/ -gnatp -ffreestanding -nostdlib -fno-exceptions -gnatec=$(PathTo_GNAT_ADC)
NASM_default_flags = -i$(PathTo_OS_include)/ -i$(PathTo_NASM_default_macroses)/ -i$(PathTo_IA32Macroses_NASM)/ -g
C_default_flags = -I$(PathTo_OS_include)/ -Wall -g -m32 -ffreestanding -fno-stack-protector -fno-pic -fno-pie

#Compilers themselves
C_compiler = ~/crossCOMPs/gccses/bin/i686-elfNoOS-gcc
ADA_compiler = ~/crossCOMPs/gccses/bin/i686-elfNoOS-gcc
ASSEMBLER = as
LINKER = ld




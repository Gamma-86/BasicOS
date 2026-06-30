#!/bin/sh

export ROOT="$PWD"

#export Version = normal
#export Version = debug

#Important Pathes
export PathTo_Kernel="${ROOT}"/main/Kernel
export PathTo_LinkerScript="${ROOT}"/main/grub
export PathTo_GrubDiskSystem="${ROOT}"/test_disk

#Pathes for assemblers and compilers setting
export PathTo_Multiboot_files="${ROOT}"/main/grub
export PathToFull_Linker_Script="${ROOT}"/main/grub/link.ld
export PathTo_BIN_filesDump="${ROOT}"/BIN_filesDump
export PathTo_OBJ_filesDump="${ROOT}"/OBJ_filesDump


#General Include Pathes
export PathTo_OS_include="${ROOT}"/main/Kernel/OS_includes
export PathTo_OS_return_codes="${PathTo_OS_includes}"

#miscellanious pathes
export PathTo_miscellanious = "${ROOT}"/main/Kernel/miscellanious
export PathTo_AtomicOperations = "${PathTo_miscellanious}"/AtomicOperations
export PathTo_VGA_80_25 = "${PathTo_miscellanious}"/VGA_80_25
export PathTo_LowLevel_Functions = "${PathTo_miscellanious}"/LowLevel_Functions
export PathTo_Bitwise_Algebra = "${PathTo_miscellanious}"/bitwise_and_al_bebra

#Pathes to different modules and other stuff
export PathTo_MemoryManagers="${PathTo_Kernel}"/KernelMemoryManagers
export PathTo_IntitalRAMAllocators="${PathTo_MemoryManagers}"/allocators/IntialAllocators
export PathTo_GDTManager="${PathTo_MemoryManagers}"/GDT_manager

#Pathes for NASM includes
export PathTo_NASM_default_macroses="${ROOT}"/includes_i686/NASM_Macroses
export PathTo_IA32Macroses_NASM="${ROOT}"/includes_i686/NASM_Macroses

#path for ADA includes
export PathTo_ADA_INCLUDES="${ROOT}"/includes_i686/adainclude
export PathTo_GNAT_ADC="${ROOT}"/includes_i686/adaCompConfig/


#Compilers options
export ADA_default_flags=-I${PathTo_OS_include}/ -I${PathTo_ADA_INCLUDES}/ -I${PathTo_GNAT_ADC} -gnatp -ffreestanding -nostdlib -fno-exceptions -m32 -gnatec=$(PathTo_GNAT_ADC) -gnatwa -gnatwe
export NASM_default_flags=-i${PathTo_OS_include}/ -i$(PathTo_NASM_default_macroses)/ -i$(PathTo_IA32Macroses_NASM)/ -g
export C_default_flags=-I${PathTo_OS_include}/ -Wall -g -m32 -ffreestanding -fno-stack-protector -fno-pic -fno-pie

#Compilers themselves
export CC=i686-elf-gcc
export C_COMPILER=${CC}
export ADA_COMPILER=i686-elf-gnat
export AS_ASSEMBLER=as
export LINKER=ld

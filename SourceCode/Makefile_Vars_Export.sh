export ROOT="$PWD"

#export Version = normal
#export Version = debug

#Important Pathes
export PathTo_Kernel="${ROOT}"/main/Kernel
export PathTo_LinkerScript="${ROOT}"/main/grub
export PathTo_GrubDiskSystem="${ROOT}"/test_disk

#Pathes for assemblers and compilers setting
export PathTo_Multiboot_files="${ROOT}"/main/grub
export Linker_Script_Full_Path="${ROOT}"/main/grub/link.ld
export PathTo_BIN_OBJ_filesDump="${ROOT}"/BIN_OBJ_filesDump


#General Include Pathes
export PathTo_OS_return_codes="${ROOT}"/main/OS_includes
export PathTo_OS_include="${ROOT}"/main/Kernel/OS_includes

#Pathes to different modules and other stuff
export PathTo_MemoryManagers="${PathTo_Kernel}"/KernelMemoryManagers
export PathTo_IntitalRAMAllocators="${PathTo_MemoryManagers}"/allocators/IntialAllocators
export PathTo_GDTManager="${PathTo_MemoryManagers}"/GDT_manager

#Pathes for NASM includes
export PathTo_NASM_default_macroses="${ROOT}"/includes_i686/NASM_Macroses
export PathTo_IA32Macroses_NASM="${ROOT}"/includes_i686/NASM_Macroses

#path for ADA includes
export PathTo_ADA_INCLUDES="${ROOT}"/includes_i686/adainclude
export PathTo_GNAT_ADC="${ROOT}"/includes_i686/adaCompConfig/gnat.adc


#Compilers options
export ADA_default_flags=-I${PathTo_OS_include}/ -gnatp -ffreestanding -nostdlib -fno-exceptions -gnatec=$(PathTo_GNAT_ADC)
export NASM_default_flags=-i${PathTo_OS_include}/ -i$(PathTo_NASM_default_macroses)/ -i$(PathTo_IA32Macroses_NASM)/ -g
export C_default_flags=-I${PathTo_OS_include}/ -Wall -g -m32 -ffreestanding -fno-stack-protector -fno-pic -fno-pie

#Compilers themselves
export CC=~/crossCOMPs/gccses/bin/i686-elfNoOS-gcc
export C_compiler=${CC}
export ADA_compiler=~/crossCOMPs/gccses/bin/i686-elfNoOS-gcc
export ASSEMBLER=as
export LINKER=ld

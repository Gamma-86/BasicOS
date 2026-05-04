ROOT := $(CURDIR)
CURRENT_DIR := $(CURDIR)
Include1_For_MakeSubDirs_PathFull = $(ROOT)/common_vars_for_subdirs.mk

include common_vars.mk

all:
	make clean
	make multiboot_DVDtest.iso



multiboot.o: $(PathTo_Multiboot_files)/multiboot.nasm
	$(MAKE) -C $(PathTo_Multiboot_files) \
	ROOT=$(ROOT) \
	Include1_For_MakeSubDirs_PathFull=$(Include1_For_MakeSubDirs_PathFull) \
	multiboot.o
	
	mv   $(PathTo_Multiboot_files)/multiboot.o $(PathTo_BIN_OBJ_filesDump) 

multiboot.elf:
	$(MAKE) -C $(PathTo_Multiboot_files) ROOT=$(ROOT) \
	Include1_For_MakeSubDirs_PathFull=$(Include1_For_MakeSubDirs_PathFull) \


multiboot_DVDtest.iso: multiboot.elf
	mv $(PathTo_Multiboot_files)/multiboot.elf $(PathTo_GrubDiskSystem)/boot
	grub-mkrescue $(PathTo_GrubDiskSystem) -o $(PathTo_BIN_OBJ_filesDump)/multiboot_DVDtest.iso

clean:
	rm -f *.o *.so
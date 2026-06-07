all:
	make clean
	make multiboot_DVDtest.iso



multiboot.o:
	$(MAKE) -C $(PathTo_Multiboot_files) multiboot.o
	mv   $(PathTo_Multiboot_files)/multiboot.o $(PathTo_OBJ_filesDump)

multiboot.elf:
	$(MAKE) -C $(PathTo_Multiboot_files) multiboot.elf
	mv   $(PathTo_Multiboot_files)/multiboot.elf $(PathTo_BIN_filesDump)

multiboot_DVDtest.iso: multiboot.elf
	mv $(PathTo_BIN_filesDump)/multiboot.elf $(PathTo_GrubDiskSystem)/boot
	grub-mkrescue $(PathTo_GrubDiskSystem) -o $(PathTo_BIN_filesDump)/multiboot_DVDtest.iso

clean:
	rm -f $(PathTo_BIN_filesDump)/* 
	rm -f $(PathTo_OBJ_filesDump)/*.o
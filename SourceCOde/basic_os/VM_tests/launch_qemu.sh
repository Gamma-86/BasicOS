qemu-system-i386 -M pc -m 256M -parallel file:lpt.log -serial file:serial.log \
-device piix3-usb-uhci,bus=pci.0 -device e1000,bus=pci.0 \
 -S -s -monitor stdio -cpu pentium-v1  -cdrom multiboot_DVDtest.iso
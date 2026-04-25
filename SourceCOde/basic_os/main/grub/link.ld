ENTRY(_start)
OUTPUT_FORMAT(elf32-i386)

MEMORY
{
    IVT_and_DATA (r) : ORIGIN = 0, LENGTH = 1280
    FREE_RAM1 (rwx) : ORIGIN = 1280, LENGTH = 0x76FF
    BOOT(r) : ORIGIN = 0x7C00, LENGTH = 512
    FREE_RAM2 (rwx) : ORIGIN = 0x7E00, LENGTH = 0x78000
    BIOS_and_others (r) : ORIGIN = 0x80000, LENGTH = 0x7FFFF
    FREE_RAM_HIGH (rwx) : ORIGIN = 0x100000, LENGTH = 14M
}

SECTIONS
{
    . = 0x100000;
    .multiboot : ALIGN(8)  
    {
        header_start = .;
        *(.multiboot)
        header_end = .;
    
    }
    .text : ALIGN(4096){*(.text*)}
    .data : ALIGN(4096){*(.data*)}
    .rodata : ALIGN(4096){*(.rodata*)}
    .bss : ALIGN(4096){*(.bss*)}
    .heap1 : ALIGN(4096){*(.heap1*)}
}


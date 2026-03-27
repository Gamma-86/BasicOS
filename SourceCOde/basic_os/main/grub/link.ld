ENTRY(_start)

MEMORY
{
    IVT_and_DATA (r) : ORIGIN = 0, LENGTH = 1280
    FREE_RAM1 (rwx) : ORIGIN = 1280, LENGTH = 0x76FF
    BOOT(r) : ORIGIN = 0x7C00, LENGTH = 512
    FREE_RAM2 (rwx) : ORIGIN = 0x7E00, LENGTH = 0x78000
    BIOS_and_others (r) : ORIGIN = 0x80000, LENGTH = 7FFFF
    FREE_RAM_HIGH (rwx) : ORIGIN = 0x100000, LENGTH = 14M
}

SECTIONS
{
    .multiboot ALIGN(8) : 
    {
        header_start = .;
        *(.multiboot)
        header_end = .;
    
    }>FREE_RAM_HIGH
    .text  ALIGN(4096){*(.text*)}>FREE_RAM_HIGH
    .data  ALIGN(4096){*(.data*)}>FREE_RAM_HIGH
    .rodata  ALIGN(4096){*(.rodata*)}>FREE_RAM_HIGH
    .bss  ALIGN(4096){*(.bss*)}>FREE_RAM_HIGH
    .heap1  ALIGN(4096){*(.heap1*)}>FREE_RAM2
}


org  0x7C00
bits 16
CPU 386

%define SP_INITIAL 0x7BF0

section MasterBootRecord

_start0:
    jmp   0:_start
_start:
    cli
    xor   ax,ax
    mov   sp,SP_INITIAL
    mov   ss,ax
    mov   ds,ax
    mov   es,ax
    sti


%assign MBR_size ($-$$)
%assign MBR_free 510-MBR_size
times   MBR_size   db 0

%warning MBR_free bytes in MBR left,  the size is : MBR_size

dw  0xAA55

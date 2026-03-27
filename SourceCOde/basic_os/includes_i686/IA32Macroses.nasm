%define SegmentDescriptorSize 8

%define IsCode 0b1000
%define CodeIsConforming 0b0100
%define CodeIsReadable 0b0010
%define CodeIsAccessed 0b0001

%define IsData 0b0000
%define DataIsExpandingDown 0b0100
%define DataIsWritable 0b0010
%define DataIsAccessed 0b0001

%define GDT_LIMIT_MAX 0xFF_FFFF

%macro Define_GDT_Segment__limit_base_type_privelege_is32_granular 6
;%1=limit 
;%2=base
;%3=type
;%4=privelege
;%5=is32
;%6=granular
dw   (%1)&0xFFFF ;Segment limit 1 part
dw   (%2)&0xFFFF ;Base part 1
db   ((%2)&0xFF0000)>>16;Base part 2
db   ((%3)&0xF) | 1<<4 | (%4&3)<<5 | 1<<7 
db   (((%1)>>16)&0xf) | (0<<4) | (((%5)&1)<<6) | (((%6)&1)<<7) 
db   (((%2)&0xFF000000)>>24)
%endmacro

%macro DEFINE_GDT_FLATCODE386 0
    Define_GDT_Segment__limit_base_type_privelege_is32_granular   GDT_LIMIT_MAX, 0, IsCode|CodeIsReadable|CodeIsConforming, 0, 1, 1 
%endmacro
%macro DEFINE_GDT_FLATDATA386 0
    Define_GDT_Segment__limit_base_type_privelege_is32_granular   GDT_LIMIT_MAX, 0, IsData|DataIsWritable, 0, 1, 1 
%endmacro

%macro DEFINE_GDT_FLAT286CODE 0
    dw 0xFFFF
    dw 0
    db 0
    db 0b1_______00________1______1_____1_______1____0
    ;    Present Level     Normal EXE   Conform Read Accessed
    dw 0
%endmacro
%macro DEFINE_GDT_FLAT286DATA 0
    dw 0xFFFF
    dw 0
    db 0
    db 0b1_______00________1______0_____0_______1____0
    ;    Present Level     Normal Data  Down   Write Accessed
    dw 0
%endmacro




%macro DEFINE_SEGMENT_ACCESSBYTE_DATA__writable_growsDown_privilege 3
    db   0 | (((%1)&1)<<1) | (((%2)&1)<<2) | (1<<4) | (((%3)&3)<<5) | (1<<7)
%endmacro
%macro DEFINE_SEGMENT_ACCESSBYTE_CODE_readable_conforming_privelege 3
    db   0 | (((%1)&1)<<1) | (((%2)&1)<<2) | (1<<3) | (1<<4) | (((%3)&3)<<5) | (1<<7)
%endmacro

%define SEGMENT_ACCESS_BYTE_CODE__readable_conform_privlge(R, CONF, PRIVLGE) ( 0 | (((R)&1)<<1)    | (((CONF)&1)<<2) |   (1<<3) | (1<<4) | (((PRIVLGE)&3)<<5) | (1<<7) )
%define SEGMENT_ACCESS_BYTE_DATA__writable_GoDown_privlge(W, GoDown, PRIVLGE) (   0 | (((W)&1)<<1) | (((GoDown)&1)<<2) | (0<<3) | (1<<4) | (((PRIVLGE&3)<<5)) | (1<<7)  )
%define SEGMENT_SIZE_HIGH_NIBBLE__isAvailable_is32_isGranular(AVL, IS32, ISGRANULAR) ( (   (((ISGRANULAR)&1)<<3) | (((IS32)&1)<<2) | ((AVL)&1)    ) <<4)

%define SEGMENT_DATA386_BLANK__Writabl_ExpndDown_Privlg_is32_Granular_available(W, Down, DPL, is32, granular, AVL) (  (((W)&1)<<(32+9)) | ( ((Down)&1) << (32+10) ) | (0 << (32+11)) |(1 << (32+12)) | (((DPL)&3) << (32+13)) | (1 << (32+15)) | (((is32)&1) << (32+22)) | (((granular)&1) << (32+23)) | (((AVL)&1)<< (32 + 20)) )
%define SEGMENT_CODE386_BLANK__Readabl_Conformin_Privlg_is32_Granular_available(R, Conf, DPL, is32, granular, AVL) (  (((R)&1)<<(32+9)) | ( ((Conf)&1) << (32+10) ) | (1 << (32+11)) |(1 << (32+12)) | (((DPL)&3) << (32+13)) | (1 << (32+15)) | (((is32)&1) << (32+22)) | (((granular)&1) << (32+23)) | (((AVL)&1)<< (32 + 20)) )


%define SEGMENT_286DATA_DESCRIPTOR(LIMIT, BASE, WRITABLE ,E_DOWN, PRIVLG, PRESENT) ( ((LIMIT)&0xFFFF) | (((BASE)&0xFF_FFFF) <<16) | (((WRITABLE)&1)<<(16+24+1)) | (((E_DOWN)&1)<<(16+24+2)) | (0<<(16+24+3)) | (1<<(16+24+4)) | (((PRIVLG)&3) << (16+24+5)) | (((PRESENT)&1) << (16+24+5+2) ) )
%define SEGMENT_286CODE_DESCRIPTOR(LIMIT, BASE, READABLE ,CONFOR, PRIVLG, PRESENT) ( ((LIMIT)&0xFFFF) | (((BASE)&0xFF_FFFF) <<16) | (((READABLE)&1)<<(16+24+1)) | (((CONFOR)&1)<<(16+24+2)) | (1<<(16+24+3)) | (1<<(16+24+4)) | (((PRIVLG)&3) << (16+24+5)) | (((PRESENT)&1) << (16+24+5+2) ) )
%define SEGMENT_286SELECTOR(INDEX, IS_LOCAL, PRIVLG) ((  (INDEX<<3) | (((IS_LOCAL)&1) << 2) | ((PRIVLG)&3)  )&0xffff )


struc GDT_descriptop
    .limit0_15 resb 2
    .base0_15  resb 2
    .base16_23 resb 1
    .access_byte resb 1
    .limit19_16__sizeNibble resb 1
    .base24_31 resb 1
endstruc

struc TSS_save_space 
    .prev_tss resb 2
    .zeroed1 resb 2
    .esp0 resb 4
    .ss0  resb 2
    .zeroed2 resb 2
    .esp1 resb 4
    .ss1  resb 2
    .zeroed3 resb 2
    .esp2 resb 4
    .ss2  resb 2
    .zeroed4 resb 2
    .cr3 resb 4
    .eip resb 4
    .eflags resb 4
    .eax resb 4
    .ecx resb 4
    .edx resb 4
    .ebx resb 4
    .esp resb 4
    .ebp resb 4
    .esi resb 4
    .edi resb 4
    .es  resb 2
    .zeroedES resb 2
    .cs resb 2
    .zeroedCS resb 2
    .ss resb 2
    .zeroedSS resb 2
    .ds resb 2
    .zeroedDS resb 2
    .fs resb 2
    .zeroedFS resb 2
    .gs resb 2
    .zeroedGS resb 2
    .LDT_selector resb 2
    .zeroedLDT resb 2
    .T_bit_Bool16 resb 2
    .IO_map_base resb 2
endstruc
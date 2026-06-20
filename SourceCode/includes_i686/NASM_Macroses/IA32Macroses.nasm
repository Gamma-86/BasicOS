%define SegmentDescriptorSize 8

%define GDT_LIMIT_MAX 0xFF_FFFF

struc GDT_Descriptor
    .limit resb 2
    .GDT_pointer resb 4
endstruc

struc Segment_descriptor
    .limit0_15 resb 2
    .base0_15  resb 2
    .base16_23 resb 1
    .access_byte resb 1
    .limit19_16__SizeTypeNibble resb 1
    .base24_31 resb 1
endstruc
struc DataSegment_Descriptor_Bits
    .Limit_Low resb 16
    .Base_Low resb 24
    .Accessed resb 1
    .Writable resb 1
    .Exp_Down resb 1
    .IsCode  resb 1
    .IsNotSystem resb 1
    .Privelege resb 2
    .IsPresent resb 1
    .Limit_High resb 4
    .Available resb 1
    .Reserved64 resb 1
    .Is32       resb 1
    .Granular   resb 1
    .Base_High  resb 1
endstruc
struc CodeSegment_Descriptor_Bits
    .Limit_Low resb 16
    .Base_Low resb 24
    .Accessed resb 1
    .Readable resb 1
    .Conforming resb 1
    .IsCode   resb 1
    .IsNotSystem resb 1
    .Privelege resb 2
    .IsPresent resb 1
    .Limit_High resb 4
    .Available resb 1
    .Reserved64 resb 1
    .Is32       resb 1
    .Granular   resb 1
    .Base_High  resb 1
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

struc cr0_indexes
    .PE resb 0
    .PE_Protected_enabled resb 1
    .MP resb 0
    .MP_FPU_monitored resb 1
    .EM resb 0
    .EM_FPU_emulated resb 1
    .TS resb 0
    .TS_Task_Was_Switched resb 1
    .ET resb 0
    .ET_X87_installed resb 1
    .NE resb 0
    .NE_X87_Exceptions_mode resb 11
    .WP resb 0
    .WP_Cant_Write_Pages resb 2
    .AM resb 0
    .AM_Check_Alignment resb 11
    .NW resb 0
    .NW_NonWrite_Cache resb 1
    .CD resb 0
    .CD_Cache_Deisabled resb 1
    .PG resb 0
    .PG_Pagind_Enabled resb 1
endstruc

struc cr4_indexes
    .VME resb 0
    .VME_V8086_INT_Hard_Support resb 1

    .PVI resb 0
    .PVI_Enable_V_interrupt_flag resb 1

    .TSD resb 0
    .TSD_Limit_RDTSC_ToLvl0 resb 1

    .DE resb 0
    .DE_Disable_DR4_DR5 resb 1

    .PSE resb 0
    .PSE_Enable_BigPages resb 1

    .PAE resb 0
    .PAE_Enable_36bit_Mode resb 1

    .MCE resb 0
    .MCE_Allow_Machine_Check_INT resb 1

    .PGE resb 0
    .PGE_Enable_Global_Pages resb 1

    .PCE resb 0
    .PCE_Allow_RDPMC_ToUser resb 1

    .OSFXSR resb 0
    .OSFXSR_SaveSSE_When_fxsave resb 1

    .OSXMMEXCPT resb 0
    .OSXMMEXCPT_Enble_SSE_XF_INT resb 1
endstruc



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
%include "NASM_default_macroses.nasm"
%include "IA32Macroses.nasm"
%include "multiboot_structures.nasm"

bits 32
CPU WILLAMETTE

struc HeaderTagGeneral
    .type resb 2
    .flags resb 2
    .size resb 4
endstruc

%define Tagtype_PageAlign 7
%define Tagtype_VideoMode 5
    %define VMODEwidth 1024
    %define VMODEheight 768
    %define VMODEdepth 32

%define MB2_MAGIC 0xE85250D6
%define MB2_ARCH 0
%define MB2_LENGTH header_end-header_start
%define MB2_CHECKSUM -(MB2_MAGIC + MB2_ARCH + MB2_LENGTH)

section .multiboot
header_start:
    dd MB2_MAGIC
    dd MB2_ARCH
    dd MB2_LENGTH
    dd MB2_CHECKSUM

align 8
    istruc HeaderTagGeneral
        at .type, dw Tagtype_VideoMode
        at .flags,dw 0
        at .size, dd 20
    iend
    dd   VMODEwidth
    dd   VMODEheight
    dd   VMODEdepth

align 8
    dw 0
    dw 0
    dd 8

header_end:




section .data







section .bss
resb  65536+4096
stack_top:




section .data
MultibootInfoPTR dd 0
section .text

extern   kernel_main ;(unsigned int EAX_magic, void* EBX_structure)
_start:
    CLI
    mov   byte[0xb8000], 'A'
    mov   byte[0xb8001], 0x0F
    mov   esp, stack_top
        cmp   eax, 0x36D76289
        jne   Not_multiboot
    mov   [MultibootInfoPTR], ebx
    call  Sort_multiboot_struct ;Sort things that multiboot gave in EBX*




Not_multiboot:
    hlt

section .bss
MB2_RAM_map_array resb RAMMap_entry_size*256
MB2_WholeStruct_size resd 1
section .text
Get_next_eip:
    mov   eax, [esp]
    ret




extern Multiboot2_info_main_parser
%macro Roof_to_align8__reg_FreeReg  2
    mov   %2, %1
    and   %2, 0x7
    ;to align first 3 bit to 8, we should
    ;   sub 3 bits from 8
    ;   and add  result to 3 bit
    ;   (8 - 3bit) + 3bit
    sub  %2, 8 ; 3 bit - 8
    neg  %2    ; 8 - 3bit
    add  %1, %2; Aligned
%endmacro
Sort_multiboot_struct: ;void (ebx=*multiboot structure) Sort them to different arrays
    %define multi_struct ebp-4
    %define multi_struct_fullSize ebp-8
    %define CurrentTagPointer ebp-12
    %define MaxIteration ebp-16
    enter 32,0
    push  ebx
    push  esi
    push  edi

    mov   [multi_struct], ebx
    
    add   ebx, MB2Info_MainHead_size
    mov   [CurrentTagPointer], ebx
    mov   eax, [ebx + MB2Info_MainHead.Total_size]
    mov   [multi_struct_fullSize], eax
    mov   word[MaxIteration], 8192

    ;while tag type !=0 analyze it
    ;but try repeating it only 8192 times

.lp1_tag_analyzation:
    %define counter_reg16 di
    %define CurrentTagPointerREG ebx
    cmp   counter_reg16, word[MaxIteration]
        jae   .lp1_end
    cmp dword[CurrentTagPointerREG + MB2Info_TagHead.Type], 0
        je    .lp1_end

    push   ebx
    call   Multiboot2_info_main_parser
    add    esp,4

    inc   counter_reg16
    jmp   .lp1_tag_analyzation
    %undef CurrentTagPointerREG
    %undef counter_reg16
.lp1_end:


    pop   edi
    pop   esi
    pop   ebx
    leave
    ret
%undef MaxIteration
%undef CurrentTagPointer
%undef multi_struct
%undef multi_struct_fullSize
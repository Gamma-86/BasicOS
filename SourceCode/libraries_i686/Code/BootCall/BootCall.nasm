bits 32
CPU 386

%include "NASM_default_macroses.nasm"
struc Selector_Bits
    .RPL resb 2
    .Is_LDT resb 1
    .Index resb 13
endstruc



%define CallGate_Privelege 0
%define CallGate_Offset 16*8
%define CallGate_Selector CallGate_Offset | 1<<Selector_Bits.Is_LDT

Call_bootloader:;ReturnBitfield Call_bootloader(uint32_t CallCode, size_t Arg1,  size_t Arg2,  size_t Arg3, size_t Arg4, size_t Arg5)
    MACRO_ENTER_NATIVE 0, 0
    push  ebx
    push  esi
    push  edi

    push  STACK_ARG6_BP32
    push  STACK_ARG5_BP32
    push  STACK_ARG4_BP32
    mov   edi, STACK_ARG3_BP32
    mov   esi, STACK_ARG2_BP32
    mov   ebx, STACK_ARG1_BP32
    call  CallGate_Selector:0xFFFF_FFFF
    add   esp, SizeOfPTR*6

    pop   edi
    pop   esi
    pop   ebx
    leave
    ret
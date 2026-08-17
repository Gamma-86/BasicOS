CPU WILLAMETTE
bits 32
%include "NASM_default_macroses.nasm"
%include "IA32Macros.nasm"

section .data
global MainGDT_start
global MainGDT_end
global MainGDT_Descriptor



Align 8
MainGDT_start:
    dq 0
times 8192-(($-MainGDT_start)/8) dq 0 | BIT_MASK(DataSegment_Descriptor_Bits.Available)
MainGDT_end:


Align 8
times 2 db 0
MainGDT_Descriptor:
    dw   Initial_GDT_end-MainGDT_start-1
    dd   MainGDT_start




globASM_FUN_lgdt:;void (Pointer from where to load)
    mov   AX_PTRSIZE, STACK_ARG1_SP
        lgdt  [AX_PTRSIZE]
    ret
globASM_FUN_sgdt:;void (Pointer where to store)
    mov   AX_PTRSIZE, STACK_ARG1_SP
        sgdt [AX_PTRSIZE]
    ret




globASM_FUN_lldt:;void globASM_FUN_lldt(uint16_t Segment_selector)
    mov   ax, STACK_ARG1_SP16
        lldt ax
    ret
globASM_FUN_sldt:;uint16_t globASM_FUN_sldt()
    sldt ax
    ret
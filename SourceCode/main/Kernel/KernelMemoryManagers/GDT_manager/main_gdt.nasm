CPU WILLAMETTE
bits 32
%include "NASM_default_macroses.nasm"
%include "NASM_advanced_macroses32.nasm"
%include "IA32Macros.nasm"
%include "OS_return_codes.nasm"
%include "Pos_Indep_Code.nasm"
section .data
global MainGDT_start
global MainGDT_end
global MainGDT_Descriptor

Align 8
MainGDT_start:
times 8192-(($-MainGDT_start)/8) dq 0 | BIT_MASK(DataSegment_Descriptor_Bits.Available)
MainGDT_end:
Align 8
times 2 db 0
MainGDT_Descriptor:
    dw   Initial_GDT_end-MainGDT_start-1
    dd   MainGDT_start

struc KernelInitialSegment_RequestDescriptorEntry
    .Base32 resb 4
    .Limit20_32 resb 4

    .Access_Bit resb 1
    .Is_Readable_Or_Writable resb 1
    .Is_Conforming_Or_ExpandDown resb 1
    .Is_Code resb 1
    .Is_NotSystemSegment resb 1
    .Privelege resb 1
    .Is_Present resb 1

    .Is_Available resb 1
    .ReservedFor_AMD64 resb 1
    .Is32 resb 1
    .Is_Granular resb 1

    .System_SegmentType resb 1
    .CallGate_Selector resb 2
endstruc





globASM_FUN_lgdt:;void (Pointer from where to load)
    mov   AX_PTRSIZE, STACK_ARG1_SP
        lgdt  [AX_PTRSIZE]
    ret
globASM_FUN_sgdt:;void (Pointer where to store)
    mov   AX_PTRSIZE, STACK_ARG1_SP
        sgdt [AX_PTRSIZE]
    ret
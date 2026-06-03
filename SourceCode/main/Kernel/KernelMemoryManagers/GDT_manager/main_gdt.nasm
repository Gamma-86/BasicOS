CPU WILLAMETTE
bits 32
%include "NASM_default_macroses.nasm"
%include "IA32Macros.nasm"
%include "OS_return_codes.nasm"
%include "Pos_Indep_Code.nasm"
section .data
global MainGDT_start
global MainGDT_end
global MainGDT_Descriptor

Align 8
MainGDT_start:
    ;1
dq 0
.code32Flat: ;2
DEFINE_GDT_FLATCODE386
.data32Flat: ;3
DEFINE_GDT_FLATDATA386
Initial_GDT_end:
times 8192-(($-MainGDT_start)/8) dq 0 ;| BIT_MASK(DataSegment_Descriptor_Bits.Available)

MainGDT_end:
Align 8
times 6 db 0
MainGDT_Descriptor:
    dw   Initial_GDT_end-MainGDT_start-1
    dd   MainGDT_start
GDT_Stack_Pointer dw Initial_GDT_end - MainGDT_start

globASM_FUN_GDT_pushDescriptor: ;selector (long long Descriptor)
    %push Saved_Context


    ret
    %pop
globASM_FUN_lgdt:;void (Pointer from where to load)
    mov   AX_PTRSIZE, STACK_ARG1_SP
        lgdt  [AX_PTRSIZE]
    ret
globASM_FUN_sgdt:;void (Pointer where to store)
    mov   AX_PTRSIZE, STACK_ARG1_SP
        sgdt [AX_PTRSIZE]
    ret
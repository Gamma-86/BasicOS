CPU WILLAMETTE
bits 32
%include "NASM_default_macroses.nasm"
%include "IA32Macros.nasm"
%include "OS_return_codes.nasm"

section .data
global Main_GDT
global MainGDT_Descriptor
global MainGDT_end
Align 8
MainGDT_start:
    ;1
dq 0
.code32Flat: ;2
DEFINE_GDT_FLATCODE386
.data32Flat: ;3
DEFINE_GDT_FLATDATA386

%rep 8179 ; because we have 3 segments and 8192 is maximum amount
    dq 0 | BIT_MASK(DataSegment_Descriptor_Bits.Available)
%endrep
MainGDT_end:

Align 8
times 6 db 0
MainGDT_Descriptor:
    dw   MainGDT_end-MainGDT_start-1
    dd   MainGDT_start



globASM_FUN_lgdt:;void (Pointer from where to load)
    mov   eax, [esp+4]
        lgdt  [eax]
    ret
globASM_FUN_sgdt:;void (Pointer where to store)
    mov   eax, [esp+4]
        sgdt [eax]
    ret
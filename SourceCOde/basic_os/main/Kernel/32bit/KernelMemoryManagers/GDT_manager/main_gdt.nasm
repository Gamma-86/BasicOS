CPU WILLAMETTE
bits 32
%include "NASM_default_macroses.nasm"
%include "IA32Macros.nasm"
%include "OS_return_codes.nasm"

section .data
global Main_GDT
global MainGDT_Descriptor
global MainGDT_end

MainGDT:
    ;1
dq 0
.code32Flat: ;2
DEFINE_GDT_FLATCODE386
.data32Flat: ;3
DEFINE_GDT_FLATDATA386

.code16FlatMax:;4
DEFINE_GDT_FLAT286CODE
.data16FlatMax:;5
DEFINE_GDT_FLAT286DATA
.vga_VramMain: ;6
DEFINE_GDT_286DATA__limit_base_writable_down_privilege 65536, 0xA000, 1, 0, 0

MainGDT_end:
MainGDT_Descriptor:
    dw   MainGDT_end-MainGDT-1
    dd   MainGDT

globASM_FUN_lgdt:;void (Pointer from where to load)
    %push LocContext
    %stacksize flat
    %arg GDT_DESC_PTR:PTR_word

    mov   eax, [PTR_word]
    lgdt  [eax]


    ret
    %pop
globASM_FUN_sgdt:;void (Pointer where to store)

    ret
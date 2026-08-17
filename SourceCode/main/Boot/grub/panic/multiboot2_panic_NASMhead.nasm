%ifndef MULTIBOOT2_PANIC_NASM_HEAD_NASM_SENTRY
%DEFINE MULTIBOOT2_PANIC_NASM_HEAD_NASM_SENTRY

struc MB2panic_EnumCodes
    .GenericPanic resb 1
    .Found_Unsupported_UEFI_RAMmap resb 1
    .Unsupported_Loader resb 1
    .Multiboot_UnalignedPTR resb 1
endstruc
%macro I_AM_MULTIBOOT_IDK_WAHTTODO_PANIC 1
    push %1
    call   multiboot2_LoadPanic
%endmacro

%macro I_AM_MULTIBOOT_IDK_WANT_CUSTOM_PANIC 1
section .data
%%Panic_String: db %1
section .text
    push  %%Panic_String
    call  multiboot2_LoadPanic_customSTR
%ENDIF
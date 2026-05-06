%IFNDEF PORTDEBUGOUTPUT_NASMMACRO_NASM_SENTRY
%define PORTDEBUGOUTPUT_NASMMACRO_NASM_SENTRY
%macro CALL_PRINT_STR_LPT 1
section .data
    %$String %1
section .text
    push %$String
    call Print_str_lpt
    add  SP_NATIVE, SizeOfPTR
%endmacro
%endif
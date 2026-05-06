%IFNDEF PORTDEBUGOUTPUT_NASMMACRO_NASM_SENTRY
%define PORTDEBUGOUTPUT_NASMMACRO_NASM_SENTRY
extern Print_str_lpt

%macro CALL_PRINT_STR_LPT 1
%push Print_context
section .data
    %$String db %1
    db 0
section .text

    call Print_str_lpt
    add  SP_NATIVE, SizeOfPTR
%pop
%endmacro



%endif
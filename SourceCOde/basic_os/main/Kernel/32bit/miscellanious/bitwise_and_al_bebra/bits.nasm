bits 32
CPU WILLAMETTE
%include "NASM_default_macroses.nasm"

global Bit_scan_forward16
global Bit_scan_forward32
;int Bit_scan_forward16(short int scanned_thing)
Bit_scan_forward16:
    mov   edx, 16
    bsf   ax, STACK_ARG1_SP16
    cmovZ eax, edx
        movzx   eax, ax
    ret
;int Bit_scan_forward32(int scanned_thing)
Bit_scan_forward32:
    mov   edx, 32
    bsf   eax, STACK_ARG1_SP
    cmovZ eax, edx

    ret



;int Bit_scan_reverse16(short int scanned_thing)
Bit_scan_reverse16:
    mov   edx, 16
    bsr   ax, STACK_ARG1_SP16
    cmovZ eax, edx
        movzx   eax, ax
    ret
;int Bit_scan_reverse32(int scanned_thing)
Bit_scan_reverse32:
    mov   edx, 32
    bsr   eax, STACK_ARG1_SP
    cmovZ eax, edx

    ret
%include "NASM_default_macroses.nasm"

bits 32
CPU WILLAMETTE

section .text

global outb
global globASM_FUN_outb

global outw
global globASM_FUN_outw

global outd
global globASM_FUN_outd

outb:
globASM_FUN_outb: ;void (short int address, char TheByte)
    mov   dx, STACK_ARG1_SP16
    mov   al, STACK_ARG2_SP8
    out   dx, al
    ret
outw:
globASM_FUN_outw: ;void (Short int address, short int TheWord)
    mov   dx, STACK_ARG1_SP16
    mov   ax, STACK_ARG2_SP16
    out   dx, ax
    ret
outd:
globASM_FUN_outd: ;void (short int address, unsigned int TheDoubleWord)
    mov   dx, STACK_ARG1_SP16
    mov   eax, STACK_ARG2_SP32
    out   dx,  eax
    ret


global set_IOPL_minLvl

set_IOPL_minLvl: ;void(char level)
    movzx eax,byte[esp+4]
    and   eax,3
    shl   eax,12

    pushf
        pop   edx
        and   edx, ~(3<<12)
        or    edx,eax
        push  edx
    popf

    ret

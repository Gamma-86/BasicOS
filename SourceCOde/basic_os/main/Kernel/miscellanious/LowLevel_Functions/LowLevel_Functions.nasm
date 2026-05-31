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



global inB
global globASM_FUN_inB
global inW
global globASM_FUN_inW
global inD
global globASM_FUN_inD
inB:
globASM_FUN_inB: ; unsgined char (Uint16 PortAddress)
    movzx edx, STACK_ARG1_SP16
    in    al, dx
    ret
inW:
globASM_FUN_inW: ; Uint16 (Uint16 PortAddress)
    movzx edx, STACK_ARG1_SP16
    in    ax, dx
    ret
inD:
globASM_FUN_inD:;uint32 (uint16 PortAddress)
    movzx edx, STACK_ARG1_SP16
    in    eax, dx
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








global WRMSR_
global Write_ModelSpecific_Register
global RDMSR_
global Read_ModelSpecifi_Register

WRMSR_:
Write_ModelSpecific_Register:;void (int WhereWrite, Long Long WhatWrite)
    %push Context
    %define WhereWrite STACK_ARG1_SP
    %define WhatWriteLOW STACK_ARG2_SP
    %define WhatWriteHIGH STACK_ARG3_SP
    mov   ecx, WhereWrite
    mov   eax, WhatWriteLOW
    mov   edx, WhatWriteHIGH
        WRMSR
    ret
    %pop
RDMSR_:
Read_ModelSpecific_Register:;long long (int WhereRead)
    %push Context
    %define WhereRead STACK_ARG1_SP
    mov   ecx, WhereWrite
        RDMSR
    ret
    %pop
%include "NASM_default_macroses.nasm"

bits 32
CPU 386

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
    %define WhereRead STACK_ARG1_SP
    mov   ecx, WhereWrite
        RDMSR
    ret
    %undef WhereRead




global get_CR0
global get_CR2
global get_CR3
global get_CR4

global globASM_FUN_get_CR0
global globASM_FUN_get_CR2
global globASM_FUN_get_CR3
global globASM_FUN_get_CR4

get_CR0:;uint32_t get_CR0();
globASM_FUN_get_CR0:;uint32_t globASM_FUN_get_CR0();
    mov   eax, cr0
    mov   rax, rdx
    ret

get_CR2:;uint32_t get_CR2();
globASM_FUN_get_CR2:;uint32_t globASM_FUN_get_CR2();
    mov   eax, cr2
    ret

get_CR3:;uint32_t get_CR3();
globASM_FUN_get_CR3:;uint32_t globASM_FUN_get_CR3();
    mov   eax, cr3
    ret

get_CR4:;uint32_t get_CR4();
globASM_FUN_get_CR4:;uint32_t globASM_FUN_get_CR4();
    mov   eax, cr4
    ret





global write_CR0
global write_CR2
global write_CR3
global write_CR4

global globASM_FUN_write_CR0
global globASM_FUN_write_CR2
global globASM_FUN_write_CR3
global globASM_FUN_write_CR4

write_CR0:;void write_CR0(uint32_t Control_Register);
globASM_FUN_write_CR0:;void globASM_FUN_write_CR0(uint32_t Control_Register);
    mov   eax, STACK_ARG1_SP
    mov   cr0, eax

    ret
write_CR2:;void write_CR2(uint32_t Control_Register);
globASM_FUN_write_CR2:;void globASM_FUN_write_CR2(uint32_t Control_Register);
    mov   eax, STACK_ARG1_SP
    mov   cr2, eax

    ret

write_CR3:;void write_CR3(uint32_t Control_Register);
globASM_FUN_write_CR3:;void globASM_FUN_write_CR3(uint32_t Control_Register);
    mov   eax, STACK_ARG1_SP
    mov   cr3, eax

    ret

write_CR4:;void write_CR4(uint32_t Control_Register);
globASM_FUN_write_CR4:;void globASM_FUN_write_CR4(uint32_t Control_Register);
    mov   eax, STACK_ARG1_SP
    mov   cr4, eax

    ret


global X86_Check_CPUID
X86_Check_CPUID:
    pushfd                               ;Save EFLAGS
    pushfd                               ;Store EFLAGS
    xor dword [esp],0x00200000           ;Invert the ID bit in stored EFLAGS
    popfd                                ;Load stored EFLAGS (with ID bit inverted)
    pushfd                               ;Store EFLAGS again (ID bit may or may not be inverted)
    pop eax                              ;eax = modified EFLAGS (ID bit may or may not be inverted)
    xor eax,[esp]                        ;eax = whichever bits were changed
    popfd                                ;Restore original EFLAGS
    and eax,0x00200000                   ;eax = zero if ID bit can't be changed, else non-zero
    ret

global globASM_FUN_CPUID
struc CPUID_Return
    .AX_info   resb 8
    .BX_info   resb 8
    .CX_info   resb 8
    .DX_info   resb 8
endstruc

globASM_FUN_CPUID:; void globASM_FUN_CPUID(struct CPUID_Return* Return_Info, uint32_t Leaf, uint32_t Subleaf)
    MACRO_ENTER_NATIVE 0,0
    push   BX_PTRSIZE
    push   DI_PTRSIZE

    mov   eax, STACK_ARG2_BP32
    mov   ecx, STACK_ARG3_BP32
    cpuid

    mov   DI_PTRSIZE, STACK_ARG1_BP
        mov   [DI_PTRSIZE + CPUID_Return.AX_info], eax
        mov   [DI_PTRSIZE + CPUID_Return.BX_info], ebx
        mov   [DI_PTRSIZE + CPUID_Return.CX_info], ecx
        mov   [DI_PTRSIZE + CPUID_Return.DX_info], edx

    pop    DI_PTRSIZE
    pop    BX_PTRSIZE
    leave
    ret
bits 32
CPU Katmai
%include "NASM_default_macroses.nasm"

global Usub8
global Ssub8
global Uadd8
global Sadd8
Usub8: ;uint8 (NUM1_8, NUM2_8, CaryPTR, OverPTR)
Ssub8: ;sint8 (NUM1_8, NUM2_8, CaryPTR, OverPTR)
    %push Context
    %define NUM1_8 STACK_ARG1_SP8
    %define NUM2_8 STACK_ARG2_SP8
    %define CaryPTR STACK_ARG3_SP
    %define OverPTR STACK_ARG4_SP
    neg   STACK_ARG2_SP8
Uadd8: ;uint8 (NUM1_8, NUM2_8, CaryPTR, OverPTR)
Sadd8: ;sint8 (NUM1_8, NUM2_8, CaryPTR, OverPTR)

    movzx eax, NUM1_8
    movzx edx, NUM2_8
        add   al, dl
        setC  dl
        setO  dh
    mov   ecx, CaryPTR
        mov   [ecx], dl
    mov   ecx, OverPTR
        mov   [ecx], dh

    ret
    %pop Context

Usub8_16:
Ssub8_16: ;uint16 NUM1-NUM2 (NUM1_8, NUM2_8, CaryPTR, OverPTR)
    %push Context
    %define NUM1_8 STACK_ARG1_SP8
    %define NUM2_8 STACK_ARG2_SP8
    %define CaryPTR STACK_ARG3_SP
    %define OverPTR STACK_ARG4_SP
    neg   STACK_ARG2_SP8
Uadd8_16: ;uint16 (NUM1_8, NUM2_8, CaryPTR, OverPTR)
Sadd8_16:

    movzx eax, NUM1_8
    movzx edx, NUM2_8
        add   al, dl
        setC  dl
        setO  dh
            adc   ah, 0
    mov   ecx, CaryPTR
        mov   [ecx], dl
    mov   ecx, OverPTR
        mov   [ecx], dh

    ret
    %pop Context


Ssub16:;uint16 (NUM1_16, NUM2_16, CaryPTR, OverPTR)
Usub16:
    %push Context
    %define NUM1   STACK_ARG1_SP16
    %define NUM2   STACK_ARG2_SP16
    %define CaryPTR   STACK_ARG3_SP
    %define OverPTR   STACK_ARG4_SP
    neg   NUM2
Sadd16:; uint16 (NUM1_16, NUM2_16, CaryPTR, OverPTR)
Uadd16:
    movzx eax, NUM1
        mov   ecx, CaryPTR
    add   ax, NUM2
        setC  dl
        setO  dh
        mov   [ecx], dl
    mov   ecx, OverPTR
        mov   [ecx], dh
    ret
    %pop

Usub16_32:; uint32 (NUM1_16, NUM2_16, CaryPTR, OverPTR)
Ssub16_32:
    %push Context
    %define NUM1 STACK_ARG1_SP16
    %define NUM2 STACK_ARG2_SP16
    %define CaryPTR STACK_ARG3_SP
    %define OverPTR STACK_ARG4_SP
    neg   NUM2
Uadd16_32:
Sadd16_32:
    mov   ecx, CaryPTR
    movzx eax, NUM1
        add   ax, NUM2
        setC  dl
        setO  dh
        rol   eax, 16
            or   al, dl
        rol   eax, 16
        mov   [ecx], dl
    mov   ecx, OverPTR
        mov   [ecx], dh

    ret
    %pop

Umul_8: ;uint16 (NUM1_8, NUM2_8, CaryPTR, OverPTR)
    %push Context
    %define NUM1_8 STACK_ARG1_SP8
    %define NUM2_8 STACK_ARG2_SP8
    %define CaryPTR STACK_ARG3_SP
    %define OverPTR Stack_ARG4_SP
    mov   ecx, CaryPTR
    movzx eax, NUM1_8
        mul   NUM2_8
        setc  dl
        mov   [ecx], dl
    mov   ecx, OverPTR
        mov   [ecx], dl

    ret
    %pop
Smul_8: ;sint16(NUM1_8, NUM2_8, CaryPTR, OverPTR)
    %push context
    %define NUM1 STACK_ARG1_SP8
    %define NUM2 STACK_ARG2_SP8
    %define CaryPTR STACK_ARG3_SP
    %define OverPTR STACK_ARG4_SP
    movzx eax, NUM1
    mov   ecx, CaryPTR
        imul  NUM2
        setc  dl
        mov   [ecx], dl
    mov   ecx, OverPTR
        mov   [ecx], dl

    ret
    %pop

Udiv8_8: ;uint8 Div Result (NUM1_8, NUM2_8, Remainder_8PTR)
    %push Context
    %define NUM1 STACK_ARG1_SP8
    %define NUM2 STACK_ARG2_SP8
    %define Remainder_8PTR STACK_ARG3_SP
    mov   ecx, Remainder_8PTR
    movzx eax, NUM1
        div   NUM2
        mov   [ecx], ah
    ret
    %pop
Sdiv8_8: ;uint8 Div Result(NUM1_8, NUM2_8, Remainder_8PTR)
    %push Context
    %define NUM1 STACK_ARG1_SP8
    %define NUM2 STACK_ARG2_SP8
    %define Remainder_8PTR STACK_ARG3_SP
    mov   ecx, Remainder_8PTR
    movzx ecx, NUM1
        idiv  NUM2
        mov   [ecx], ah
    ret
    %pop

Udiv16_8: ;uint8 Div Result(NUM1_16, NUM2_8, Remainder_8PTR)
    %push Context
    %define NUM1 STACK_ARG1_SP16
    %define NUM2 STACK_ARG2_SP8
    %define Remainder_8PTR STACK_ARG3_SP
    mov   ecx, Remainder_8PTR
    movzx eax, NUM1
        div   NUM2
        mov   [ecx], ah
    ret
    %pop
Sdiv16_8: ;uint8 Result(NUM1_16, NUM2_8, Remainder_8PTR)
    %push Context
    %define NUM1 STACK_ARG1_SP16
    %define NUM2 STACK_ARG2_SP8
    %define Remainder_8PTR STACK_ARG3_SP
    mov   ecx, Remainder_8PTR
    movzx eax, NUM1
        idiv  NUM2
        mov   [ecx], ah
    ret
    %pop
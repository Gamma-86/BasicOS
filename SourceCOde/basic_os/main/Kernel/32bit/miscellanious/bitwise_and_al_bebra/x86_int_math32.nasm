bits 32
CPU WILLAMETTE
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



global Umul_8
global Smul_8

global Umul8_16
global Smul8_16
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
    movsx eax, NUM1
        mov   ecx, CaryPTR
        imul  NUM2
        setc  dl
        mov   [ecx], dl
    mov   ecx, OverPTR
        mov   [ecx], dl

    ret
    %pop

Umul8_16:; uint16 (NUM1_8, NUM2_8, CarryPTR, OverPTR)
    %push Context
    %define NUM1 STACK_ARG1_SP8
    %define NUM2 STACK_ARG2_SP8
    %define CarryPTR STACK_ARG3_SP
    %define OverPTR STACK_ARG4_SP
    movzx   eax, NUM1
        mul   NUM2
        mov   ecx, CarryPTR
            setc  dl
            mov   [ecx], dl
        mov   ecx, OverPTR
            mov   [ecx], dl
    ret
    %pop
Smul8_16:; sint16 (NUM1_8, NUM2_8, CarryPTR, OverPTR)
    %push Context
    %define NUM1 STACK_ARG1_SP8
    %define NUM2 STACK_ARG2_SP8
    %define CarryPTR STACK_ARG3_SP
    %define OverPTR STACK_ARG4_SP
    movzx   eax, NUM1
        imul  NUM2
        mov   ecx, CarryPTR
            setc  dl
            mov   [ecx], dl
        mov   ecx, OverPTR
            mov   [ecx], dl
    ret
    %pop

    ret


global Udiv8_8
global Sdiv8_8

global Udiv16_8
global Sdiv16_8

global Udiv16_16
global Sdiv16_16

global Udiv32_16
global Sdiv32_16

global Udiv32_32
global Sdiv32_32
Udiv8_8: ;uint8 Div Result (NUM1_8, NUM2_8, Remainder_8PTR)
    %push Context
    %define NUM1 STACK_ARG1_SP8
    %define NUM2 STACK_ARG2_SP8
    %define Remainder_8PTR STACK_ARG3_SP
    movzx eax, NUM1
        div   NUM2
        mov   ecx, Remainder_8PTR
        mov   [ecx], ah
    ret
    %pop
Sdiv8_8: ;uint8 Div Result(NUM1_8, NUM2_8, Remainder_8PTR)
    %push Context
    %define NUM1 STACK_ARG1_SP8
    %define NUM2 STACK_ARG2_SP8
    %define Remainder_8PTR STACK_ARG3_SP
    movsx eax, NUM1
        idiv  NUM2
        mov   ecx, Remainder_8PTR
        mov   [ecx], ah
    ret
    %pop

Udiv16_8: ;uint8 Div Result(NUM1_16, NUM2_8, Remainder_8PTR)
    %push Context
    %define NUM1 STACK_ARG1_SP16
    %define NUM2 STACK_ARG2_SP8
    %define Remainder_8PTR STACK_ARG3_SP
    movzx eax, NUM1
        div   NUM2;divide ax by NUM2_8
        mov   ecx, Remainder_8PTR
        mov   [ecx], ah
    ret
    %pop
Sdiv16_8: ;uint8 Result(NUM1_16, NUM2_8, Remainder_8PTR)
    %push Context
    %define NUM1 STACK_ARG1_SP16
    %define NUM2 STACK_ARG2_SP8
    %define Remainder_8PTR STACK_ARG3_SP
    movsx eax, NUM1
        idiv  NUM2 ;divide ax by NUM2_8
        mov   ecx, Remainder_8PTR
        mov   [ecx], ah ;so that al=result, ah=remainder
    ret
    %pop

Udiv16_16:; uint16 Result (NUM1_16, NUM2_16, Remainder_PTR)
    %push Context
    %define NUM1 STACK_ARG1_SP16
    %define NUM2 STACK_ARG2_SP16
    %define Remainder_PTR STACK_ARG3_SP
    movzx eax, NUM1
        xor   edx, edx
        div   NUM2
        mov   ecx, Remainder_PTR
        mov   [ecx], dx
    ret
    %pop
Sdiv16_16:;uint16 (NUM1_16, NUM2_16, Remainder16_PTR)
    %push Context
    %define NUM1 STACK_ARG1_SP16
    %define NUM2 STACK_ARG2_SP16
    %define Remainder_PTR STACK_ARG3_SP
    movzx eax, NUM1
        cwd
        idiv  NUM2 ;divide dx:ax by NUM2_16
        mov   ecx, Remainder_PTR
        mov   [ecx], dx
    ret
    %pop


Sdiv32_16: ;uint16 Result (NUM1_32, NUM2_16, Remainder_PTR)
    %push Context
    %define NUM1 STACK_ARG1_SP16
    %define NUM1_HIGH word[esp+4+2]
    %define NUM2 STACK_ARG2_SP16
    %define Remainder_PTR STACK_ARG3_SP
    mov   ax, NUM1
    mov   dx, NUM1_HIGH
        idiv  NUM2
        mov   ecx, Remainder_PTR
        mov   [ecx], dx
    ret
    %pop
Udiv32_16: ;uint16 Result(NUM1_32, NUM2_16, Remainder16_PTR)
    %push  Context
    %define NUM1 STACK_ARG1_SP16
    %define NUM1_HIGH word[esp+4+2]
    %define NUM2 STACK_ARG2_SP16
    %define Remainder_PTR STACK_ARG3_SP
    mov   ax, NUM1
    mov   dx, NUM1_HIGH
        div   NUM2
        mov   ecx, Remainder_PTR
        mov   [ecx], dx
    ret
    %pop

Sdiv32_32:;uint32t (NUM1_32, NUM2_32, Remainder PTR)
    %push Context
    %define NUM1 STACK_ARG1_SP32
    %define NUM2 STACK_ARG2_SP32
    %define Remainder_PTR STACK_ARG3_SP
    mov   eax, NUM1
        cdq
        idiv NUM2
        mov   ecx, Remainder_PTR
        mov   [ecx], edx
    ret
    %pop
Udiv32_32:;uint32t (NUM1_32, NUM2_32, Remainder PTR)
    %push Context
    %define NUM1 STACK_ARG1_SP32
    %define NUM2 STACK_ARG2_SP32
    %define Remainder_PTR STACK_ARG3_SP
    mov   eax, NUM1
        xor   edx, edx
        div   NUM2
            mov   ecx, Remainder_PTR
            mov   [ecx], edx
    ret
    %pop

Sdiv64_32:;sint32 (NUM1_64, NUM2_32, Remainder32_PTR)
    %push Context
    %define NUM1_LOW STACK_ARG1_SP32
    %define NUM1_HIGH STACK_ARG2_SP32
    %define NUM2 STACK_ARG3_SP32
    %define Remainder_PTR STACK_ARG4_SP
    mov   eax, NUM1_LOW
    mov   edx, NUM1_HIGH
        idiv  NUM2
        mov   ecx, Remainder_PTR
        mov   [ecx], edx
    ret
    %pop
Udiv64_32:;sint32 (NUM1_64, NUM2_32, Remainder32_PTR)
    %push Context
    %define NUM1_LOW STACK_ARG1_SP32
    %define NUM1_HIGH STACK_ARG2_SP32
    %define NUM2 STACK_ARG3_SP32
    %define Remainder_PTR STACK_ARG4_SP
    mov   eax, NUM1_LOW
    mov   edx, NUM1_HIGH
        div   NUM2
        mov   ecx, Remainder_PTR
        mov   [ecx], edx
    ret
    %pop
Udiv64_64:;uint64 (NUM1_64, NUM2_64, Remainder64_PTR)
    %push Context
    %define NUM1LOW STACK_ARG1_SP32
    %define NUM1HIGH STACK_ARG2_SP32
    %define NUM2LOW STACK_ARG3_SP32
    %define NUM2HIGH STACK_ARG4_SP32
    %define Remainder_PTR STACK_ARG5_SP
    
    ret
    %pop
Sdiv64_64:;sint64 (NUM1_64, NUM2_64, Remainder64_PTR)
    %push Context
    %define NUM1LOW STACK_ARG1_SP32
    %define NUM1HIGH STACK_ARG2_SP32
    %define NUM2LOW STACK_ARG3_SP32
    %define NUM2HIGH STACK_ARG4_SP32
    %define Remainder_PTR STACK_ARG5_SP
    
    ret
    %pop

global IntABS_8
global IntABS_16
global IntABS_32
global IntABS_64
IntABS_8:;int8 (NUM8)
    movzx eax, byte[esp+4]
    cbw
    xor   al, ah
    sub   al, ah
    ret
IntABS_16: ;int16(NUM16)
    movzx eax, word[esp+4]
    cwd
    xor   ax, dx
    sub   ax, dx
    ret
IntABS_32:; int32 (NUM32)
    mov   eax, [esp+4]
    cdq
    xor   eax, edx
    sub   eax, edx
    ret
IntABS_64:; int64 (NUM64)
    %push Context
    %define NUM_LOW STACK_ARG1_SP32
    %define NUM_HIGH STACK_ARG2_SP32
    mov   eax, NUM_LOW
    mov   edx, NUM_HIGH
        mov   ecx, edx
            shr   ecx, 30
            neg   ecx
            xor   eax, ecx
            xor   edx, ecx
            sub   eax, ecx
            sbb   edx, ecx
    ret
    %pop
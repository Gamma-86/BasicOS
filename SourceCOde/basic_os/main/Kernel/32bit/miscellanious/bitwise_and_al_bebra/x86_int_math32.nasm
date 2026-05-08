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

%if (__?BITS?__) = 64

    %macro GET_LABEL_FLAT_ADDRESS_POS_INDEP 1
        lea   rax, [rel %1]
    %endmacro

%elif (__?BITS?__) = 32

    LocalASM_FUN_Get_Next_EIP:
        mov   eax, [esp]
        ret
    %macro GET_LABEL_FLAT_ADDRESS_POS_INDEP 1
        call   LocalASM_FUN_Get_Next_EIP
    .next_eip:
        lea   eax, [eax - .next_eip + %1]
    %endmacro

%else ;bits 16

    LocalASM_FUN_Get_Next_IP:
        push  bp
        mov   bp, sp

        mov   ax, [bp+2]

        mov   sp, bp
        pop   bp
        ret
    
    %macro GET_LABEL_FLAT_ADDRESS_POS_INDEP 1
        call LocalASM_FUN_Get_Next_IP
    .next_eip:
        xchg   bx, ax
        lea    bx, [bx - .next_eip + %1]
        xchg   bx, ax
    %endmacro

%endif
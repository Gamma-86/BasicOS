%include "NASM_default_macroses.nasm"

bits 32
CPU KATMAI

;void* source memcpy(&dest, &source, amount)
;void* source memmove(&dest, &source, amount)
;void* PTR memchr(&SearchPTR, Char, How long)
;void* memset(&where, what char, how many)

;int memcmp(&cmp1, &cmp2, how many chars compare)



memcpy: ;void* dest memcpy(*dest, *source, amount)
    ;The functions moves some bytes from one place to another
    ;If locations overlap, the result is undefined
    ;it returns destination pointer

    ;Use rep movsb, movsd for copying:
    ;1 Prepare Stack Frame
    ;2 Save edi esi, flags cause we clear direction flag

    ;3 detination to edi, source to esi, the length to ecx
    ;   3.1 If they are equal, jump to they are equal part
    ;   3.2 If the pointer is null, call int 14(0Eh page fault,Maybe will change this)
    ;4 if edi is above, (after, bigger) than esi, xchg them
    ;   edi should be before esi
    ;   esi should be after edi

    ;5  move most bytes with movsd, move remaining bytes with movsb
    ;6 return destination


    ;1 
    MACRO_ENTER_NATIVE 0, 0
    ;2 saveing required registers
    push  edi
    push  esi
    pushf

    ;3 Destiantion(ARG1) to edi, Source(Arg2) to esi amount(Arg3) to ecx 
    mov   edi, STACK_ARG1_BP
        mov   eax, edi  ;6 RETURN DESTINATION
    mov   esi, STACK_ARG2_BP
    mov   ecx, STACK_ARG3_BP
    ;NOW we should xchg edi and esi if edi is >(above) esi
    ;Setting up edi and esi
    cmp   edi, esi
    je  .both_equal
        mov   edx, edi
        mov   edi, esi 
        ;Both of edi, esi are esi
        cmovB edi, edx ;edi to edi if below
        cmovA esi, edx ;edi to esi if above
    ;5 Moving bytes normally
    mov   edx, ecx
        shr   ecx, 2;ecx is how many 4 byte moves
        and   edx, 3;remaining 1 byte moves
    cld
    rep   movsd

    mov   ecx, edx
    rep   movsb

    ;6 Returning
    popf
    pop   esi
    pop   edi
    ret

.both_equal:
    ;3.1 if they are equal jump here
    test   edi, edi
    ;3.2 if Pointers are NULL call int 0Eh
        jz    .NULL_vector
    nop
    ;3,2 If pointer is NOT NULL DONT INT 0Eh 
    jmp   .Normal_return
.NULL_vector:
    int 14
.Normal_return:
    popf
    pop   esi
    pop   edi
    ret






memmove:;void* dest memmove(&dest, &source, amount)
    ;THE BEGAVIOUR IS LITERALY THE SAME AS MEMCPY

    MACRO_ENTER_NATIVE 0, 0
    push  edi
    push  esi
    pushf

    mov   edi, STACK_ARG1_BP
        mov   eax, edi  ;RETURN DESTINATION
    mov   esi, STACK_ARG2_BP
    mov   ecx, STACK_ARG3_BP
    ;NOW we should xchg edi and esi if edi is >(above) esi
    ;Setting up edi and esi
    cmp   edi, esi
    je  .both_equal
        mov   edx, edi
        mov   edi, esi ;Both of them are esi
        ;if edi is above esi xchg esi, edi
        ;Which one will DEST go
        cmovB edi, edx ;edi to edi if 
        cmovA esi, edx
    ;Moving bytes normally
    mov   edx, ecx
        shr   ecx, 2
        and   edx, 3
    cld
    rep   movsd

    mov   ecx, edx
    rep   movsb

    popf
    pop   esi
    pop   edi
    ret

.both_equal:
    test   edi, edi
        jz    .NULL_vector
    nop
    jmp   .Normal_return
.NULL_vector:
    int 14
.Normal_return:
    popf
    pop   esi
    pop   edi
    ret

bits 32
CPU Katmai

%include "NASM_default_macroses.nasm"

global Mutex_Lock
global Mutex_Lock_Watchdog
global Mutex_Unlock

Mutex_Lock:;void Mutex_Lock(unsigned char* LockingBool)
    mov   AX_PTRSIZE, STACK_ARG1_SP

.lp1:
    xor   edx, edx
        not   edx
    xchg   dl, [AX_PTRSIZE]
    
    test   dl, dl
        jz    .lp1_end
    pause
    jmp   .lp1
.lp1_end:

    ret

Mutex_Lock_Watchdog:;unsigned char Mutex_Lock(unsigned char* LockingBool, unsigned int WatchdogTime)
    mov   AX_PTRSIZE, STACK_ARG1_SP
    mov   CX_INTSIZE, STACK_ARG2_SP

    test  CX_INTSIZE, CX_INTSIZE
        jz    .lp1_watchdog_end
.lp1:
    xor   edx, edx
        not   edx
    xchg  [AX_PTRSIZE], dl

    test  dl, dl
        jz    .lp1_end
    dec   CX_INTSIZE
        jz    .lp1_watchdog_end
    pause
    jmp   .lp1
.lp1_end:
    xor   eax, eax
    ret
.lp1_watchdog_end:
    mov   eax, 1
    ret

Mutex_Unlock: ;void Mutex_Unlock(unsigned char* LockingBool)
    mov   AX_PTRSIZE, STACK_ARG1_SP
    mov   byte[AX_PTRSIZE], 0
    ret





Locked_increment8: ;void Locked_increment8(unsgined char* Incremented)
    mov   AX_PTRSIZE, STACK_ARG1_SP
    lock inc byte[AX_INTSIZE]

    ret
Locked_increment16: ;void Locked_increment16(unsigned short* Incremented)
    mov   AX_PTRSIZE, STACK_ARG1_SP
    lock inc word[AX_INTSIZE]

    ret
Locked_increment32: ;void Locked_increment32(uint32_t* Incremented)
    mov   AX_PTRSIZE, STACK_ARG1_SP
    lock inc dword[AX_INTSIZE]

    ret
Locked_increment64: ;void Locked_increment64(uint64_t* Incremented)
;Plan : use repeat incrementing with cmpxchg8b until done
;if remained the same(edx:eax), xchg ecx:ebx with [mem]
;else move [mem] to edx:eax
;    MACRO_ENTER_NATIVE 0, 0
    push  BX_PTRSIZE
    push  SI_PTRSIZE
.lp_increment_start:
    mov   SI_PTRSIZE, STACK_ARG1_BP
        mov   eax, [SI_PTRSIZE] ;Loading initial numbers
        mov   edx, [SI_PTRSIZE+4];to specific cmpxchg8b registers

        mov   ebx, eax;copying number to increment it
        mov   ecx, edx;because edx:eax saves initial number before add

    ;inc ecx:ebx
    add   ebx, 1
        adc   ecx, 0
    lock cmpxchg8b [SI_PTRSIZE]
    ;since cmpxchg is cmp, if initial = [mem] => Zero flag
    je    .lp_increment_end
        pause
        pause
        pause
    jmp   .lp_increment_start
.lp_increment_end:
    pop   SI_PTRSIZE
    pop   BX_PTRSIZE
    leave
    ret


Locked_decrement8: ;void Locked_decrement8(unsigned char* Decremented);
    mov   AX_PTRSIZE, STACK_ARG1_SP
    lock dec byte[AX_PTRSIZE]

    ret
Locked_decrement16: ;void Locked_decrement16(unsigned short* Decremented)
    mov   AX_PTRSIZE, STACK_ARG1_SP
    lock dec word[AX_PTRSIZE]

    ret
Locked_decrement32: ;void Locked_decrement32(uint32_t* Decremented)
    mov   AX_PTRSIZE, STACK_ARG1_SP
    lock dec dword[AX_PTRSIZE]

    ret
Locked_decrement64: ;void Locked_decrement64(uint64_t* Decremented)
;Plan : use repeat decrementing with cmpxchg8b until done
;if remained the same(edx:eax), xchg ecx:ebx with [mem]
;else move [mem] to edx:eax
    MACRO_ENTER_NATIVE 0, 0
    push  BX_PTRSIZE
    push  SI_PTRSIZE
.lp_decrement_start:
    mov   SI_PTRSIZE, STACK_ARG1_BP
        mov   eax, [SI_PTRSIZE] ;Loading initial numbers
        mov   edx, [SI_PTRSIZE+4];to specific cmpxchg8b registers

        mov   ebx, eax;copying number to increment it
        mov   ecx, edx;because edx:eax saves initial number before sub

    ;dec ecx:ebx
    sub   ebx, 1
        sbb   ecx, 0
    lock cmpxchg8b [SI_PTRSIZE]
    ;since cmpxchg is cmp, if initial = [mem] => Zero flag
    je    .lp_increment_end
        pause
        pause
        pause
    jmp   .lp_increment_start
.lp_decrement_end:
    pop   SI_PTRSIZE
    pop   BX_PTRSIZE
    leave
    ret



Locked_uadd8: ;unsigned char Locked_uadd8(unsigned char* increased, unsigned char increase)
Locked_sadd8: ;signed char Locked_sadd8(signed char* increased, signed char increase)
    mov   CX_PTRSIZE, STACK_ARG1_SP8
    mov   al, STACK_ARG2_SP8
    lock xadd byte[CX_PTRSIZE], al

    ret
Locked_uadd16: ;uint16_t Locked_uadd16(uint16_t* increased, uint16_t increase)
Locked_sadd16: ; int16_t Locked_sadd16( int16_t* increased, int16_t increase)
    mov   CX_PTRSIZE, STACK_ARG1_SP
    mov   ax, STACK_ARG2_SP16
    lock xadd word[CX_PTRSIZE], ax

    ret
Locked_uadd32: ;uint32_t Locked_uadd32(uint32_t* increased, uint32_t increase)
Locked_sadd32: ;int32_t  Locked_sadd32(int32_t*  increased, int32_t  increase)
    mov   CX_PTRSIZE, STACK_ARG1_SP
    mov   eax, STACK_ARG2_SP32
    lock  xadd dword[CX_PTRSIZE], eax

    ret
Locked_uadd64: ;uint64_t Locked_uadd64(uint64_t* increased, uint64_t increase)
Locked_sadd64: ;int64_t Locked_sadd64(int64_t* increased, int64_t increase)
;    MACRO_ENTER_NATIVE 0, 0
    push  SI_PTRSIZE
    push  BX_PTRSIZE
.lp_adding_start:
    mov   SI_PTRSIZE, STACK_ARG1_BP
        mov   eax, [SI_PTRSIZE]
        mov   edx, [SI_PTRSIZE+4]

        mov   ebx, eax
        mov   ecx, edx
    add   ebx, [STACK_ARG2_BP]
        adc   ecx, [STACK_ARG3_BP]
    lock cmpxchg8b [SI_PTRSIZE]
    je    .lp_adding_end
        pause
        pause
        pause
    jmp   .lp_adding_start
.lp_adding_end:
    pop   BX_PTRSIZE
    pop   SI_PTRSIZE
    leave
    ret
bits 32
CPU WILLAMETTE

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

Mutex_Unlock:;void Mutex_Unlock(unsigned char* LockingBool)
    mov   AX_PTRSIZE, STACK_ARG1_SP
    mov   byte[AX_PTRSIZE], 0
    ret
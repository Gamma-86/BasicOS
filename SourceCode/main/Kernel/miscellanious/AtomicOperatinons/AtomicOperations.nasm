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
    ret

Mutex_Unlock:;void Mutex_Unlock(unsigned char* LockingBool)
    mov   AX_PTRSIZE, STACK_ARG1_SP
    mov   byte[AX_PTRSIZE], 0
    ret
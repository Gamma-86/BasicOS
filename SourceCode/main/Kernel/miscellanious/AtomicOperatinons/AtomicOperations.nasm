bits 32
CPU WILLAMETTE

%include "NASM_default_macroses.nasm"

Mutex_Lock:;void Mutex_Lock(unsigned char* LockingBool)

    ret

Mutex_Lock_Watchdog:;unsigned char Mutex_Lock(unsigned char* LockingBool, unsigned int WatchdogTime)

    ret

Mutex_Ulnock:;void Mutex_Unlock(unsigned char* LockingBool)

    ret
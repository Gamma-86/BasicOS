#ifndef MULTIBOOT2_PANIC_H_SENTRY
#define MULTIBOOT2_PANIC_H_SENTRY

enum{
    MB2panic_code_GenericPanic = 0,
    MB2panic_code_Found_Unsupported_UEFI_RAMmap,
    MB2panic_code_Unsupported_Loader,
    MB2panic_code_Multiboot_UnalignedPTR,
};


void multiboot2_LoadPanic(int PanicCode);
void multiboot2_LoadPanic_customSTR(char* string_to_write);
#endif
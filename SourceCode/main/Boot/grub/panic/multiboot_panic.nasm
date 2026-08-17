bits 32
cpu 386
VGA8025_print_32:;void (char*)
    mov   esi, [esp+4]
    mov   edi, 0xB8000
    cld
    mov   ah, 0xF
    mov   ecx, 0xFF
.lp1:
    lodsb
    test  al, al
        jz    .break
    stosw
    loop  .lp1
.break:
    ret



;LPT1=0x378
;LPT2=0x278
;COM1=0x3F8
;COM2=0x2F8

struc Base_address_of
    .padding1 resb 0x278
    .LPT2  resb 0
    .padding2 resb 0x2F8-0x278
    .COM2  resb 0
    .padding3 resb 0x378-0x2F8
    .LPT1 resb 0
    .padding4 resb 0x3F8-0x378
    .COM1 resb 0
endstruc

struc LPT_offset_REG
    .data resb 1
    .status resb 1
    .control resb 1
endstruc

struc LPT_StatusReg_Bit
    .padding resb 2
    .Interrupt resb 1
    .ErrorPresent_index resb 1
    .Selected_index resb 1
    .PapierOut_index resb 1
    .DataAcknowledge_index resb 1
    .NOTBusy_index resb 1
endstruc

struc LPT_ControlReg_Bit
    .NOTstrobe_index resb 1
    .NOTAutoNewLine_index resb 1
    .Reset_index resb 1
    .Select_index resb 1
endstruc


struc COM_DLAB0_offset_REG
    .Data_buffer resb 1
    .Interrupt_enabled resb 1
    .READ_Interrupt_indentificator resb 0
    .WRITE_FIFO_Queue_control resb 1
    .Line_control resb 1
    .Modem_control resb 1
    .Line_status resb 1
    .Modem_statusc resb 1
    .Scratch resb 1
endstruc


LPT_print_32:;void(char*)
.lp1:
    ;2
    mov   dx, Base_address_of.LPT1 + LPT_offset_REG.data
        mov   al, [esi]
        out   dx, al
    mov   dx, Base_address_of.LPT2 + LPT_offset_REG.data
        outsb
    ;3
    mov   dx, Base_address_of.LPT1 + LPT_offset_REG.control
        mov   al, 1<<(LPT_ControlReg_Bit.NOTstrobe_index)
        out   dx, al
    mov   dx, Base_address_of.LPT2 + LPT_offset_REG.control
        out   dx, al

    ;4
    mov   dx, Base_address_of.LPT1 + LPT_offset_REG.control
        xor   al, al
        out   dx, al
    mov   dx, Base_address_of.LPT2 + LPT_offset_REG.control
        out   dx, al

    test  byte[esi], 0xFF
    loopnz .lp1 
.lp1_end:

    ret
COM_print_32:;void(char*)

    ret
VGA13h_print_32:;void(char*)

    ret





PanicStrs:
.GenericPanic db "The generic multiboot loader panic occured, could not parse MB2 info", 0
.Found_Unsupported_UEFI_RAMmap db "The Muliboot 2 parser found UEFI RAM map tage without MB2 one, does not support this !", 0
.Unsupported_Loader db "The unsupported loader has loaded me to RAM, There is nothing I can do", 0
.Multiboot_UnalignedPTR db "The give PTR to Boot info tags or whatever is not aligned(it should be aligned 8)"





UnknownCodePanic db "The unknown type of multiboot 2 loader and panic happened, IDK what to say", 0

PanicStrs_PTRArray:
    dd PanicStrs.GenericPanic
    dd PanicStrs.Found_Unsupported_UEFI_RAMmap
    dd PanicStrs.Unsupported_Loader
    dd PanicStrs.Multiboot_UnalignedPTR
PanicStrs_PTRArray_end:

struc MB2panic_EnumCodes
    .GenericPanic resb 1
    .Found_Unsupported_UEFI_RAMmap resb 1
    .Unsupported_Loader resb 1
    .Multiboot_UnalignedPTR resb 1
endstruc



global multiboot2_LoadPanic
multiboot2_LoadPanic: ;void (uint32_t panic_code)
    cli
    lidt  [NULL_IDTR]

    mov    edx, PanicStrs_PTRArray
        mov    eax, [esp+4]
        mov    eax, [edx + eax*4]
        mov    [esp+4], eax

    cmp   dword[esp+4], (PanicStrs_PTRArray_end-PanicStrs_PTRArray)/4
    jna    .not_unknown_code
    mov   dword[esp+4], UnknownCodePanic
.not_unknown_code:

    push   dword[esp+4]
    call   VGA8025_print_32
    add    esp, 4

    push   dword[esp+4]
    call   VGA13h_print_32
    add    esp, 4

    push   dword[esp+4]
    call   LPT_print_32
    add    esp, 4

    push   dword[esp+4]
    call   COM_print_32
    add    esp, 4


    mov   ecx, 0xFFF_FFFF
.end:
    pause
    loop  .end
    int 3

global multiboot2_LoadPanic_customSTR
multiboot2_LoadPanic_customSTR: ;void(char*)
    jmp   multiboot2_LoadPanic.not_unknown_code



NULL_IDTR:
    dw 0
    dd 0
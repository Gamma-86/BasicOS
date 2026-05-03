bits 32
cpu WILLAMETTE
%include "NASM_default_macroses.nasm"
%inlcude "OS_return_codes.nasm"
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




Print_str_lpt: ;OS_returnCodes Amount printed (pointer to string)
;Idea:
; Put out char to lpt data port
;Put strobe bit in corntrol register to 1
;Put strobe bit in control register to 0
; do it 2^28 times or until meet zero byte

;How to steps:
; 1 get string pointer to esi, and clear direction flag
; 1.1 test if ESI is already pointing to 0 and test for NULL pointer
; 1.2 mov 1<<28 to ecx
; LOOP
; 2 out with string instruction to the LPT data port
; 3 out 1(strobe bit) to the LPT contol data port
; 4 out 0 to the LPT control data port
; 5 test char at esi for 0
; 6 loopz
; 7 jecxz or not and set return bitfield correspondibly 

    %push LPT_print
    %stacksize flat
    %assign %$localsize 0

    %arg String_ptr:PTR_word
    %local SI_save:uint32_t, BX_save:uint32_t 
    
    MACRO_ENTER_NATIVE %$localsize, 0
    mov   [SI_save], esi
    mov   [BX_save], ebx

    xor   ebx, ebx
        mov   bl, LOW8_ReturnBitfield_Namespace.GeneralOS
;1
    mov   esi, [String_ptr]
        TEST_REG_NULL esi
        jz    .NullPTR
        
;1.1
    test  byte[esi], 0xFF
        jz   .absolute_end
;1.2
    mov   ecx, 1<<28
    cld
.lp1:
    ;2
    mov   dx, Base_address_of.LPT1 + LPT_offset_REG.data
        mov   al, [esi]
        out   dx, al
    mov   dx, Base_address_of.LPT2 + LPT_offset_REG.data
        outsb
    ;3
    mov   dx, Base_address_of.LPT1 + LPT_offset_REG.control
        mov   al, BIT_MASK(LPT_ControlReg_Bit.NOTstrobe_index)
        out   dx, al
    mov   dx, Base_address_of.LPT2 + LPT_offset_REG.contol
        out   dx, al

    ;4
    mov   dx, Base_address_of.LPT1 + LPT_offset_REG.control
        xor   al, al
        out   dx, al
    mov   dx, Base_address_of.LPT2 + LPT_offset_REG.control
        out   dx, al

    test  byte[esi], 0xFF
    loopz .lp1 
lp1_end:
    jecxz .cx_zero
    nop
    jmp   .absolute_end
.cx_zero:
    or    ebx, BIT_MASK(ReturnBitfields_GeneralOS_BitIndexes.WatchdogSet)
    jmp   .absolute_end
.NullPTR:
    or   ebx, BIT_MASK(ReturnBitfields_GeneralOS_BitIndexes.NullPTR)
.absolute_end:
    mov   eax, ebx
    mov   ebx, [BX_save]
    mov   esi, [SI_save]
    leave
    ret
    %pop
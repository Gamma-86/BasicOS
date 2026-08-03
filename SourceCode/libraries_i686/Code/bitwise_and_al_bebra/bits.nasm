bits 32
CPU Katmai
%include "NASM_default_macroses.nasm"
%include "Pos_Indep_Code.nasm"


global Bit_scan_forward16
global Bit_scan_forward32
;int Bit_scan_forward16(short int scanned_thing)
Bit_scan_forward16:
    mov   edx, 16
    bsf   ax, STACK_ARG1_SP16
    cmovZ eax, edx
        movzx   eax, ax
    ret
;int Bit_scan_forward32(int scanned_thing)
Bit_scan_forward32:
    mov   edx, 32
    bsf   eax, STACK_ARG1_SP
    cmovZ eax, edx

    ret



;int Bit_scan_reverse16(short int scanned_thing)
Bit_scan_reverse16:
    mov   edx, 16
    bsr   eax, STACK_ARG1_SP16
    cmovZ eax, edx

    ret
;int Bit_scan_reverse32(int scanned_thing)
Bit_scan_reverse32:
    mov   edx, 32
    bsr   eax, STACK_ARG1_SP
    cmovZ eax, edx

    ret








global BitTest16
global BitTest32

BitTest16: ;unsigned char BitTest16(uint16_t Bitfield, unsigned char Bit_index );
    movzx eax, STACK_ARG2_SP16
    bt    STACK_ARG1_SP16, eax
        setc  al

    ret
BitTest32: ;unsigned char BitTest32(uint32_t Bitfield, unsigned char Bit_index)
    mov   eax, STACK_ARG2_SP
    bt    STACK_ARG1_SP, eax
        setc al
    
    ret







section .rodata
%assign i 0
%assign Bit_Count 0
Bit_Pop_Cnt8_Lookup_Table:
%rep 256
%assign Bit_Count (i&1) + ( (i&2)>>1 ) + ((i&0b100)>>2) + ( (i&0b1000)>>3 ) + ( (i&0x10)>>4 ) + ( (i&0x20)>>5 ) + ( (i&0x40)>>6 ) + ( (i&0x80)>>7 )
db Bit_Count
%assign i i+1
%endrep

section .text
BitPopCount8:;unsigned char BitPopCount8(unsigned char BitField);
    movzx edx, STACK_ARG1_SP8
    
    GET_LABEL_FLAT_ADDRESS_POS_INDEP    Bit_Pop_Cnt8_Lookup_Table
    movzx eax, byte[eax + edx]

    ret
BitPopCount16: ;unsigned char BitPopCount16(uint16_t BitField);
;Steps:
;0-call macros to get address position independently of LookupTable 
;1-get high 8 bits of argument
;  1.1 - get full argument,
;  1.2 - shift right 8 bits, to get high bits
;2-get population count to ecx through 8bit lookup table (in eax)
;3-Get low bits of argument to edx
;4-get population count of low 8 bit to edx
;5 add it to ecx
;get final result to eax

;0
    GET_LABEL_FLAT_ADDRESS_POS_INDEP   Bit_Pop_Cnt8_Lookup_Table
;1
;1.1
    movzx edx, STACK_ARG1_SP16
;1.2
        shr   edx, 8
;2
        movzx ecx, byte[eax + edx]
;3
    movzx edx, STACK_ARG1_SP8
;4
        movzx   edx, byte[eax + edx]
;5
        add   ecx, edx
;finale
    mov   eax, ecx

    ret




%macro X_Bits_PopCount_Macros__InvertThing 1
;Steps: Load byte, Pass it through table, add result to counter, repeant Size times
;   1 - Initialize registers for loop, table lookup, 
;          Create Stack frame
;   1.1-save ebx, esi
;   1.2-Get table address position independently
;   1.3-move it to ebx
;   1.4-move Bitfield PTr argument to ESI
;   1.5-clear direction flag
;   1.6-move Size to cx
;   1.7-test ecx(Size) to 0, jump to immediate end
;   1.8-reset edx to 0(Counter)

;   2 - load byte from bitfield with lodsb
;
;   Invert it depending on the flag
;
;   3 - Process it through table with XLATB
;   4 - add result to counter(edx)
;   4.1-zero expand al to eax
;   4.2-add eax to edx
;   5 loop counter amount of times
;   5.1-test cx,cx
;   5.2-loop with if not zero with loopnz

;   6-  THE END
;   6.1-restore ebx, esi
;   6.2-destroy stack frame
;   6.3-move counter(edx) to return register(eax)
;   6.4-return



;1
    MACRO_ENTER_NATIVE 0, 0
;1.1
    push  ebx
    push  esi
;1.2
    GET_LABEL_FLAT_ADDRESS_POS_INDEP   Bit_Pop_Cnt8_Lookup_Table
;1.3
    mov   ebx, eax
;1.4
    mov   esi, STACK_ARG1_BP
;1.5
    cld
;1.6
    movzx ecx, STACK_ARG2_BP16
        ;1.7
        test  ecx, ecx
        jz    .SizeZeroCase
;1.8
    xor   edx, edx


%%.lp_PopCnt:
;2
    lodsb
%if %1
    not   al
%endif

;3
    xlatb
;4
;4.1
    movzx eax, al
;4.2
    add   edx, eax

;5
;5.1
    test  cx, cx
;5.2
    loopnz .lp1_PopCnt


%%.SizeZeroCase:
;6
;6.1
    pop   esi
    pop   ebx
;6.2
    leave
;6.3
    mov   eax, edx
;6.4
    ret
%endmacro


global X_1Bits_PopCount
global X_0Bits_PopCount

X_1Bits_PopCount:   ;uint32_t X_1Bits_PopCount(unsigned char* Bitfield_Array, uint16_t Size)
X_Bits_PopCount_Macros__InvertThing 0

X_0Bits_PopCount:   ;uint32_t X_0Bits_PopCount(unsigned char* Bitfield_Array, uint16_t Size)
X_Bits_PopCount_Macros__InvertThing 1
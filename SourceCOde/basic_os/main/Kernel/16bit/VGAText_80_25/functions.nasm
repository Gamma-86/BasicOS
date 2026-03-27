bits 16
cpu 286
org 0h
BINARY_START:


%define SegmentDescriptorSize 8

%macro DEFINE_GDT_286DATA__limit_base_writable_down_privilege 5
;%1 = limit
;%2 = base
;%3 = writable
;%4 = GrowDown
;%5 = PrivelegeLevel
dw   (%1)&0xFFFF
dw   (%2)&0xFFFF 
db   ((%2)>>16)&0xFF
db   (((%3)&1)<<1) | (((%4)&1)<<2) |(1<<4) | (((%5)&3)<<5) | (1<<7)
dw   0
%endmacro

%macro DEFINE_GDT_286CODE__limit_base_read_conform_privilege 5
;%1 = limit
;%2 = base
;%3 = readable
;%4 = comform
;%5 = PrivelegeLevel
dw   (%1)&0xFFFF 
dw   (%2)&0xFFFF
db   ((%2)>>16)&0xFF
db   (((%3)&1)<<1) | (((%4)&1)<<2) | (1<<3) | (1<<4) | (((%5)&3)<<5) | (1<<7)
%endmacro

%macro DEFINE_SEGMENT_ACCESSBYTE_DATA__writable_growsDown_privilege 3
    db   0 | (((%1)&1)<<1) | (((%2)&1)<<2) | (1<<4) | (((%3)&3)<<5) | (1<<7)
%endmacro
%macro DEFINE_SEGMENT_ACCESSBYTE_CODE_readable_conforming_privelege 3
    db   0 | (((%1)&1)<<1) | (((%2)&1)<<2) | (1<<3) | (1<<4) | (((%3)&3)<<5) | (1<<7)
%endmacro

%define SEGMENT_SELECTOR(INDEX, IS_LOCAL, RequestedLevel) (( ((INDEX)<<3) | ((IS_LOCAL)&1) | ((RequestedLevel)&3) )&0xFFFF )





struc VGAText_80_25_descriptor
    .TextPage1_offset resb 4
    .TextPage2_offset resb 4
    .TextPage3_offset resb 4
    .TextPage4_offset resb 4
    .LDT_offset resb 4
    .LDT_size resb 4
    .String_Buffer_Offset resb 4
    .String_Buffer_Size resb 4
    .MAIN_CALLED_FUNCTION_OFFSET resb 4
    .MAIN_CALLED_FUNCTION_SELECTOR resb 2
    .reserved1 resb 2
    .Instructions_QUEUE resb 4
    .QUEUE_descriptors_amount resb 4
endstruc

istruc VGAText_80_25_descriptor
    at .TextPage1_offset, dd TextPage1
    at .TextPage2_offset, dd TextPage2
    at .TextPage3_offset, dd TextPage3
    at .TextPage4_offset, dd TextPage4
    at .LDT_offset, dd LDT
    at .LDT_size, dd LDT_END - LDT
    at .String_Buffer_Offset, dd String_Buffer
    at .String_Buffer_Size, dd 80*25
    at .MAIN_CALLED_FUNCTION_OFFSET, dd Analyze_CallDescriptors_queue
    at .MAIN_CALLED_FUNCTION_SELECTOR, dw 0
    at .reserved1, dw 0
    at .Instructions_QUEUE, dd Instructions_QUEUE
    at .QUEUE_descriptors_amount, dd 256
iend




%assign Descriptor_used_space        ($-$$)
%assign Descriptor_empty_space_left  100h - Descriptor_used_space

times Descriptor_empty_space_left db 0




%define CALL_DESCRIPTOR_CODE_PUTCHAR 1
%define CALL_DESCRIPTOR_CODE_PUTCHAR_XY 1+ CALL_DESCRIPTOR_CODE_PUTCHAR;1
%define CALL_DESCRIPTOR_CODE_GET_CURSOR_POS 1+ CALL_DESCRIPTOR_CODE_PUTCHAR_XY;2
%define CALL_DESCRIPTOR_CODE_SET_CURSOR_POS 1+ CALL_DESCRIPTOR_CODE_GET_CURSOR_POS;3
%define CALL_DESCRIPTOR_CODE_GET_CURRENT_PAGE 1+ CALL_DESCRIPTOR_CODE_SET_CURSOR_POS;4
%define CALL_DESCRIPTOR_CODE_SET_CURRENT_PAGE 1+ CALL_DESCRIPTOR_CODE_GET_CURRENT_PAGE;5
%define CALL_DESCRIPTOR_CODE_CLEAN_CRNT_PAGE 1+ CALL_DESCRIPTOR_CODE_SET_CURRENT_PAGE;6
%define CALL_DESCRIPTOR_CODE_PRINT_STR 1+ CALL_DESCRIPTOR_CODE_CLEAN_CRNT_PAGE;7
%define CALL_DESCRIPTOR_CODE_PRINT_STR_XY 1+ CALL_DESCRIPTOR_CODE_PRINT_STR;8
%define CALL_DESCRIPTOR_CODE_CLEAN_PAGE_X 1+ CALL_DESCRIPTOR_CODE_PRINT_STR_XY;9
%define CALL_DESCRIPTOR_CODE_PUTCHAR_XY_PAGE_X 1+ CALL_DESCRIPTOR_CODE_CLEAN_PAGE_X;10
%define CALL_DESCRIPTOR_CODE_PRINT_STR_XY_PAGE_X 1+ CALL_DESCRIPTOR_CODE_PUTCHAR_XY_PAGE_X;11
%define CALL_DESCRIPTOR_CODE_PRINT_THE_PAGE 1+ CALL_DESCRIPTOR_CODE_PRINT_STR_XY_PAGE_X;12
%define CALL_DESCRIPTOR_CODE_PRINT_PAGE_X 1+ CALL_DESCRIPTOR_CODE_PRINT_THE_PAGE;13

%define CALL_DESCRIPTOR_CODE_LAST_OPCODE 1 + CALL_DESCRIPTOR_CODE_PRINT_PAGE_X
struc VGAText_80_25_call_descriptor
    .type resb 1
    .beeing_processed resb 1
    .ended resb 1
    .reserved resb 1
    .arg1 resb 2
    .arg2 resb 2
    .arg3 resb 2
    .arg4 resb 2
    .arg5 resb 2
    .arg6 resb 2
    .arg7 resb 2
    .arg8 resb 2
    .reserved2 resb 4
    .ret1 resb 2
    .ret2 resb 2
    .ret3 resb 2
    .ret4 resb 2
endstruc

%assign VGATEXT_CALL_DESCRIPTOR_SIZE VGAText_80_25_call_descriptor_size
%warning Size of call descriptor is VGATEXT_CALL_DESCRIPTOR_SIZE

%define MAX_X_CORD 79
%define MAX_Y_CORD 24
%define LINE_SIZE 80 
%define AMOUNT_OF_LINES 25

LDT:
    dq 0
.EGA_TEXT_VRAM:
DEFINE_GDT_286DATA__limit_base_writable_down_privilege 0xFFFF, 0xb_8000, 1, 0, 0

LDT_END:

struc VGA3h_character
    .code resb 1
    .attribute resb 1
endstruc


;MAIN FUNCTIONS
SP_save_space dw 0


;Compatability layer
Analyze_CallDescriptors_queue: 
;before calling save all segment regiters
;set LDTR to LDT 
;set code segment to 16 bit and its base address to where this is loaded
;   and limit to the size of this file or 65536
;Would be good if privelege were level 0
    %define LOOP_counter bp-2
    mov   [SP_save_space], sp
    mov   sp, stack_top
    enter 256, 0
    pusha

    mov   di, Instructions_QUEUE
    mov   word[LOOP_counter], 255
;Read opcode from di
;check if it's more than maximum opcode if so skip iteration
;get address from jump table and do call to procedure of calling
;get arguments from di
;pus the required argument to stack and call function ad clean stack
;return to main loop
;repeat until you find opcode 0 or counter reached 255
;return far


.lp1_analyze_start:
    dec   byte[LOOP_counter]
    jz    .lp1_end

    mov   bl, 1
    xchg  [di + VGAText_80_25_call_descriptor.beeing_processed], bl
    test  bl, 0xff
;        jz    .lp1_skip_iteration

    xor   bx, bx
    mov   bl, [di + VGAText_80_25_call_descriptor.type];Read Opcode from di
    test  bl, bl        
        jz    .lp1_end  ;Repeat until opcode is 0
    cmp   bl, CALL_DESCRIPTOR_CODE_LAST_OPCODE
        jae   .lp1_skip_iteration ;If above max opcode skip iteration

    shl   bx, 1
    add   bx, .Jump_table
    call  near [bx] ;get address from table and call
.lp1_next_iteration:
    mov   bl, 1
    xchg  [di + VGAText_80_25_call_descriptor.ended], bl
    xor   bl, bl
    xchg  [di + VGAText_80_25_call_descriptor.ended], bl
    add   di, VGAText_80_25_call_descriptor_size

    jmp   .lp1_analyze_start
.lp1_skip_iteration:
    add   di, VGAText_80_25_call_descriptor_size
    jmp   .lp1_analyze_start
.lp1_jmp_start:
    jmp   .lp1_analyze_start
.lp1_end:




    popa
    leave
    mov   sp, [SP_save_space]
    retf
.call_putchar:;(ASCII, ATRIBUTE)
    push  word[di + VGAText_80_25_call_descriptor.arg2]
    push  word[di + VGAText_80_25_call_descriptor.arg1]
    call  PutChar
    add   sp, 4
    ret
.call_putchar_XY:;void (ASCII, Atribute, X, Y)
    push  word[di + VGAText_80_25_call_descriptor.arg4]
    push  word[di + VGAText_80_25_call_descriptor.arg3]
    push  word[di + VGAText_80_25_call_descriptor.arg2]
    push  word[di + VGAText_80_25_call_descriptor.arg1]
    call  PutChar_XY
    add   sp, 8

    ret
.call_get_cursor_pos:
    mov   ax, GlobCursorPosition_X
    mov   dx, GlobCursorPosition_Y
    mov   [di + VGAText_80_25_call_descriptor.ret1], ax
    mov   [di + VGAText_80_25_call_descriptor.ret2], dx

    ret
.call_set_cursor_pos:;void (X, Y)
    mov   ax, [di + VGAText_80_25_call_descriptor.arg1]
    mov   dx, [di + VGAText_80_25_call_descriptor.arg2]
    mov   [GlobCursorPosition_X], ax
    mov   [GlobCursorPosition_Y], dx

    ret
.call_get_current_page:
    xor   ax, ax
    mov   al, [CurrentPageSelected_Index]
    and   al, 3
    mov   [VGAText_80_25_call_descriptor.ret1], ax

    ret
.call_set_current_page:
    mov   ax, [di + VGAText_80_25_call_descriptor.arg1]
    and   ax, 3
    mov   [CurrentPageSelected_Index], ax

    ret
.call_clean_crnt_page:
    mov   al, [CurrentPageSelected_Index]
    ;4000 = 16 * 250 = <<4 * 250
    mov   ah, 250
    and   al, 3
        mul   ah;*250
        shl   ax, 4;*16
    push  cx
    pushf
    push  di

        cld
        mov   cx, 25*80
        mov   di, ax
        xor   ax, ax
        add   di, TextPage1
        rep   stosw

    pop   di
    popf
    pop   cx
    ret
.call_print_str:
    ret
.call_print_str_XY:
    ret
.call_clean_page_X:
    ret
.call_putchar_XY_page_X:
    ret
.call_print_str_XY_page_X:
    ret
.call_print_page:
    ret
.call_print_page_X:
    ret

.bad_index:
    ret

.Jump_table:
dw   .bad_index
dw   .call_putchar
dw   .call_putchar_XY
dw   .call_get_cursor_pos
dw   .call_set_cursor_pos
dw   .call_get_current_page
dw   .call_set_current_page
dw   .call_clean_crnt_page
dw   .call_print_str
dw   .call_print_str_XY
dw   .call_clean_page_X
dw   .call_putchar_XY_page_X
dw   .call_print_str_XY_page_X
dw   .call_print_page
dw   .call_print_page_X

PutChar:;(ASCII, ATRIBUTE)
    %define ASCII_CODE ss:bp+4
    %define ATTRIBUTE_CODE ss:bp+6
    push bp
    mov  bp, sp
    push  bx
    push  cx

    mov   ax, [GlobCursorPosition_X]
        cmp   ax, MAX_X_CORD
        ja    .dont_cut_x_cord
        .cut_x_cord:
            mov   ax, MAX_X_CORD
        .dont_cut_x_cord:
    mov   dx, [GlobCursorPosition_Y] ;80Y = 64Y + 16Y
        cmp   ax, MAX_Y_CORD
        ja    .dont_cut_y_cord
        .cut_y_cord:
            mov   ax, MAX_Y_CORD
        .dont_cut_y_cord:
    mov   cx, dx
    ;Dx=Y CX=Y
    ;DX * 2^6
    ;CX * 2^4
    shl   dx, 6  ;64Y
    shl   cx, 4  ;16Y
    add   dx, cx ;add 64Y, 16Y
    add   dx, ax ;add Y, X
    mov   bx, dx ;BX = address

    mov   al, [ASCII_CODE]
    mov   ah, [ATTRIBUTE_CODE]
    mov   [bx], ax

    pop   cx
    pop   bx
    leave
    ret
%undef ASCII_CODE
%undef COLOUR_CODE

PutChar_XY: ;void (ASCII, Atribute, X, Y)
    %define ASCII_CODE ss:bp+4 
    %define ATTRIBUTE_CODE ss:bp+6
    %define X ss:bp+8
    %define Y ss:bp+10
    push  bp
    mov   bp, sp
    push  bx

    mov   ax, [X]
    mov   dx, [Y]
        push  dx ;push Y
        push  ax ;push X
        call  LEA_80_25_offset
        add   sp, 4
    mov   bx, ax
    mov   ax, CurrentPageSelected_Index
        and   ax, 3
        mov   dx, 25*80*2
        mul   dx
    add   bx, ax
    add   bx, TextPage1

    mov   al, [ASCII_CODE]
    mov   ah, [ATTRIBUTE_CODE]
    mov   [bx], ax

    pop   bx
    leave
    ret
    %undef  ASCII_CODE
    %undef  ATTRIBUTE_CODE
    %undef  X
    %undef  Y

PrintSTR_XY_page_x: ;void (length, offset in buffer, attribute, X, Y)
    %define  length ss:bp+4
    %define  STRBufferOffset ss:bp+6
    %define  AttributeByte ss:bp+8
    %define  X bp+10
    %define  Y bp+12
    push  bp
    mov   bp, sp
    push  di
    push  si
    push  cx
    push  bx
    pushf
    

    mov   si, [STRBufferOffset]
    add   si, String_Buffer ;LEA  StringAddress

    ;getting address of page
    mov   al, [CurrentPageSelected_Index]
        and   al, 3
    mov   ah, 250
    mul   ah
    shl   ax, 4
    add   ax, TextPage1
    mov   di, ax ;Got address of page

    push  word[Y]
    push  word[X]
    call  LEA_80_25_offset
        pop   dx
        mov   [X], dx
        pop   dx
        mov   [Y], dx
    ;got offset of X Y in pages
    add   di, ax ;loaded final address of XY in the page

    mov   ah, [AttributeByte]
    mov   cx, [length]
    cld
    ;SI = complete string address
    ;DI = complete XY address in page
    ;CX = It's length
    ;ah = attribute byte
    ;direction flag cleared
.lp1_print:
    lodsb
        test  al, al
        jz    .lp1_end
    push  ax
    push  dx
    push  cx ;saving registers
    
        push   word[Y]
        push   word[X]
            xor   bx, bx
            mov   bl, ah ;move attribute to bx
        push  bx ;push attribute
            mov   bl, al
        push  bx ;push  ascii
    call  PutChar_XY;void (ASCII, Atribute, X, Y)
        add   sp, 8
    call  Move_cursor_coordinates_forward

    pop   cx
    pop   dx
    pop   ax

    loop  .lp1_print
.lp1_end:



    popf
    pop   bx
    pop   cx
    pop   si
    pop   di
    leave
    ret
%undef length
%undef STRBufferOffset
%undef AttributeByte
%undef X
%undef Y

; PRIVATE FUNCTIONS
LEA_80_25_offset: ;(X, Y)
    %define X ss:bp+4
    %define Y ss:bp+6
    push  bp
    mov   bp, sp
    push  dx

    mov   ax, [X]
    mov   dx, [Y]

        cmp   ax, MAX_X_CORD
        jbe   .dont_trunc_X_cord
        .trunc_X_cord:
            mov   ax, MAX_X_CORD
        .dont_trunc_X_cord:

        cmp   dx, MAX_Y_CORD
        jbe   .dont_trunc_Y_cord
        .trunc_Y_cord:
            mov   dx, MAX_Y_CORD
        .dont_trunc_Y_cord:
    mov   [X], ax
    mov   [Y], dx

    mov   ax, dx
        shl   ax, 6 ;64Y
        shl   dx, 4 ;16Y
    add   ax, dx
    add   ax, [X]

    pop   dx
    leave
    ret
%undef X
%undef Y

Increase_cursor_X_cord:
    push  ax

    mov   ax, [ds:GlobCursorPosition_X]
        inc   ax
        cmp   ax, MAX_X_CORD
        jbe   .dont_trunc_X_cord
        .trunc_X_cord:
            xor   ax, ax
            call  Increase_cursor_Y_cord
        .dont_trunc_X_cord:
    mov   [ds:GlobCursorPosition_X], ax

    pop   ax
    ret


Increase_cursor_Y_cord:
    push  ax

    mov   ax, [ds:GlobCursorPosition_Y]
        inc   ax
        cmp   ax, MAX_Y_CORD
        jbe   .dont_trunc_Y_cord
        .trunc_Y_cord:
            mov   ax, MAX_Y_CORD
            call  Shift_all_chars_up
        .dont_trunc_Y_cord:
    mov   [ds:GlobCursorPosition_Y], ax

    pop   ax
    ret

Move_cursor_coordinates_forward:
    push  ax
    push  dx

    ;increase and verify X_cod
    mov   ax, [GlobCursorPosition_X]
        cmp   ax, MAX_X_CORD
        jb    .dont_trunc_X_cord
        .trunc_X_cord:
            xor   ax, ax
            inc   word[GlobCursorPosition_Y]
        .dont_trunc_X_cord:
    mov   [GlobCursorPosition_X], ax
    ;check Y cord and shift everything above if needed
    mov   ax, [GlobCursorPosition_Y]
        cmp   ax, MAX_Y_CORD
        jbe   .dont_trunc_Y_cord
        .trunc_Y_cord:
            mov   ax, MAX_Y_CORD
            call  Shift_all_chars_up
        .dont_trunc_Y_cord:
    mov   [GlobCursorPosition_Y], ax

    pop   dx
    pop   ax
    ret

Shift_all_chars_up:
    push  ax
    push  di
    push  cx
    push  si

    mov   al, [ds:CurrentPageSelected_Index]
    and   al, 3
    test  al, al
        jz   .select_page1
    cmp   al, 1
        jz   .select_page2
    cmp   al, 2
        jz   .select_page3
    jmp   .select_page4
.select_page1:
    mov   di, TextPage1
    jmp   .select_end
.select_page2:
    mov   di, TextPage2
    jmp   .select_end
.select_page3:
    mov   di, TextPage3
    jmp   .select_end
.select_page4:
    mov   di, TextPage4
.select_end:
    mov   si, di
    add   si, LINE_SIZE

    mov   cx, LINE_SIZE*AMOUNT_OF_LINES
.lp1_shift:
    mov   al, [ds:si]
    inc   si
    mov   [ds:di], al
    inc   di
    loop  .lp1_shift


    pop   si
    pop   cx
    pop   di
    pop   ax
    ret


String_Buffer times 80*26 db 0


GlobCursorPosition_X dw 0
GlobCursorPosition_Y dw 0

CurrentPageSelected_Index dw 0

TextPage1 times 80*25*2 db 0
TextPage2 times 80*25*2 db 0
TextPage3 times 80*25*2 db 0
TextPage4 times 80*25*2 db 0

stack_start:
times 4096 db 0
stack_top:

Instructions_QUEUE:
    times VGAText_80_25_call_descriptor_size*256 db 0


%assign FullProgramSize ($-$$)
%warning This program full size is FullProgramSize
bits 16
org 0
cpu 286

%define SEGMENT_286DATA_DESCRIPTOR(LIMIT, BASE, WRITABLE ,E_DOWN, PRIVLG, PRESENT) ( ((LIMIT)&0xFFFF) | (((BASE)&0xFF_FFFF) <<16) | (((WRITABLE)&1)<<(16+24+1)) | (((E_DOWN)&1)<<(16+24+2)) | (0<<(16+24+3)) | (1<<(16+24+4)) | (((PRIVLG)&3) << (16+24+5)) | (((PRESENT)&1) << (16+24+5+2) ) )
%define SEGMENT_286CODE_DESCRIPTOR(LIMIT, BASE, READABLE ,CONFOR, PRIVLG, PRESENT) ( ((LIMIT)&0xFFFF) | (((BASE)&0xFF_FFFF) <<16) | (((READABLE)&1)<<(16+24+1)) | (((CONFOR)&1)<<(16+24+2)) | (1<<(16+24+3)) | (1<<(16+24+4)) | (((PRIVLG)&3) << (16+24+5)) | (((PRESENT)&1) << (16+24+5+2) ) )
%define SEGMENT_286SELECTOR(INDEX, IS_LOCAL, PRIVLG) ((  (INDEX<<3) | (((IS_LOCAL)&1) << 2) | ((PRIVLG)&3)  )&0xffff )

struc PS_2_Keyboard_driver_descriptor
    .Keys_Queue1 resb 4
    .Keys_Queue_reserve resb 4
    .LDT_offset resb 4
    .LDT_size resb 4
    .MAIN_CALLED_FUNCTION_OFFSET resb 4
    .MAIN_CALLED_FUNCTION_SELECTOR resb 2
    .reserved1 resb 2
    .Keyboard_Interrupt resb 4
endstruc


%assign Descriptor_used_space        ($-$$)
%assign Descriptor_empty_space_left  100h - Descriptor_used_space

times Descriptor_empty_space_left db 0

struc Key_descriptor_packet
    .ascii resb 4
    .IsValid resb 1
    .keycodes_space resb 1
    .keycode resb 2
    .pressed resb 1
    .KeyEverPressed_counter_low resb 2
    .KeyEverPressed_counter_high resb 2
    .reserved1 resb 3
endstruc




Keyboard_Interrupt:
    pusha



    popa
    iret







struc Keys_queue_descriptor
    .Inserter_Index resb 1
    .Reader_Index resb 1
    .beeing_inserted resb 1
    .beeing_readed resb 1
    .queue_overflow resb 1
    .queue_used resb 1
    .reserved1 resb 2
endstruc

Keys_Queue1_start:
times 256*Key_descriptor_packet_size db 0
Keys_Queue1_end:

Keys_Queue1_descriptor:
istruc Keys_queue_descriptor
    at   .Inserter_Index, db 0
    at   .Reader_Index, db 0
    at   .beeing_inserted, db 0
    at   .beeing_readed, db 0
    at   .queue_overflow, db 0
    at   .queue_used, db 1
    at   .reserved1, db 0, 0
iend


Keys_Queue_reserve_start:
times 256*Key_descriptor_packet_size db 0
Keys_Queue_reserve_end:

Keys_Queue_reserve_descriptor:
istruc Keys_queue_descriptor
    at   .Inserter_Index, db 0
    at   .Reader_Index,   db 0
    at   .beeing_inserted,db 0
    at   .beeing_readed,  db 0
    at   .queue_overflow, db 0
    at   .queue_used,     db 0
iend


GlobKeysEverPressed_Counter dd 0

%define MAIN_QUEUE1_INDEX 0
%define RESERVED_QUEUE_INDEX 1

Global_used_queue_index db MAIN_QUEUE1_INDEX

%define SCANCODE_SET_UNDEFINED_INDEX 0
%define SCANCODE_SET1_INDEX 1
%define SCANCODE_SET2_INDEX 2
%define SCANCODE_SET3_INDEX 3

Global_used_ScanCodeSet_index db SCANCODE_SET_UNDEFINED_INDEX


LDT_start:
dq 0
LDT_end:

LDT_size dw LDT_end - LDT_start


TSS_save_space_start:
    times 256 db 0
TSS_save_space_end:


%assign FullProgramSize ($-$$)
%warning This program full size is FullProgramSize

times 0x7FFF - FullProgramSize db 0
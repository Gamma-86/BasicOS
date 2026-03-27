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



%define SEGMENT_ACCESS_BYTE_CODE__readable_conform_privlge(R, CONF, PRIVLGE) ( 0 | (((R)&1)<<1)    | (((CONF)&1)<<2) |   (1<<3) | (1<<4) | (((PRIVLGE)&3)<<5) | (1<<7) )
%define SEGMENT_ACCESS_BYTE_DATA__writable_GoDown_privlge(W, GoDown, PRIVLGE) (   0 | (((W)&1)<<1) | (((GoDown)&1)<<2) | (0<<3) | (1<<4) | (((PRIVLGE&3)<<5)) | (1<<7)  )
org 0
bits 16
CPU 286
;%include "NASM_default_macroses.nasm"
;cs ds es ss

struc call_descriptor
    .excuted resb 1
    .type resb 1
    .arg1 resw 1
    .arg2 resw 1
    .arg3 resw 1
    .arg4 resw 1
    .arg5 resw 1
    .arg6 resw 1
    .arg7 resw 1
endstruc

serve_queue: ;unsigned char (es32 = 0xA0000, ds32:ptr = queue structure)

    retf

%define put_pixel_type 1
%define draw_line_type 2
%define draw_rectangle_type 3
put_pixel: ;void (short X, short Y,unsigned short colour)
    %define X bp+4
    %define Y bp+6
    %define colour bp+8
    push  bp
    mov   bp,sp
    push  bx

    mov   ax, [colour]
    mov   bx, [X]
    mov   dx, [Y] ;We need to multiply dx*320 = 64*5dx=<<6(<<2dx + dx)
        shl   dx, 2
        add   dx, [Y]
        shl   dx,6
    add   bx, dx
    mov   [es:bx], al

    pop   bx
    leave
    ret
    %undef X
    %undef Y
    %undef colour
draw_line:

    ret
draw_rectangle:;void (short X1, short Y1, short X2, short Y2, unsigned short colour)
    %define X1 bp+4
    %define Y1 bp+6
    %define X2 bp+8
    %define Y2 bp+10
    %define colour bp+12
    push  bp
    mov   bp,sp
    push  bx

    

    pop   bx
    leave
    ret
    %undef X1
    %undef Y1
    %undef X2
    %undef Y2
    %undef colour
    ret
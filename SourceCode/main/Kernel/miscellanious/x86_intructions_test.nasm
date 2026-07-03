%IF 0
bits 32
;CPU 686
;CPU KATMAI
CPU WILLAMETTE
;CPU PRESCOTT
addpd xmm0, xmm1
movss xmm0, xmm1
;fisttp dword[1]
;haddpd xmm0, xmm1
paddq mm0,mm1
fild qword[1]
fistp qword[1]


Size_start:
    cmp   word[ebx+edx + ], 1
Size_end:
%assign Size_of_instruciton Size_end-Size_start
%warning Size_of_instruciton


%endif

%if 1
CPU 386
    idiv eax, ecx
%endif
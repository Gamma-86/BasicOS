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
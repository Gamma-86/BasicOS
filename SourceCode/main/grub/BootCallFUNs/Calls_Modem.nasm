bits 32
cpu 386




extern BootCalls_Rounter


BootCalls32_Modem:
;ebx = CallCode
;esi = arg1
;edi = arg2
;far_arg1 = arg3
;far_arg2 = arg4
;far_arg3 = arg5
    push  dword[STACK_ARG_ESP_FAR(3)]
    push  dword[STACK_ARG_ESP_FAR(2)]
    push  dword[STACK_ARG_ESP_FAR(1)]
    push  edi
    push  esi
    push  ebx

    call  BootCalls_Rounter

    add   esp, 6*SizeOfPTR

    retf
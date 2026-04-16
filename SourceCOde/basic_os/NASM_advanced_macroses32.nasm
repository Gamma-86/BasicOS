%IFNDEF NASM_ADVANCED_MACROSES32_NASM
%define NASM_ADVANCED_MACROSES32_NASM

struc VAR_TYPES_ENUM
    .U_Char  resb 0
    .uint8_t resb 0
    .uint8   resb 1
    
    .sint8   resb 0
    .sint8_t resb 0
    .S_Char  resb 1

    .uint16     resb 0    
    .U_ShortInt resb 0
    .uint16_t   resb 1

    .sint16     resb 0
    .sint16_t   resb 0
    .S_ShortInt resb 1

    .U_LongInt resb 0

    .U_int      resb 0
    .uint32     resb 0
    .uint32_t   resb 1


    .S_LongInt  resb 0

    .S_int      resb 0
    .sint32     resb 0
    .sint32_t   resb 1

    .U_LongLongInt resb 0
    .uint64        resb 0
    .uint64_t      resb 1

    .S_LongLongInt resb 0
    .sint64        resb 0
    .sint64_t      resb 1
endstruc

%assign DEBUG_VAR_TYPES_ENUM_TEST VAR_TYPES_ENUM.sint64
;%warning SHowing VAR_TYPES ENUM Index : DEBUG_VAR_TYPES_ENUM_TEST


%define What_Segment_Does_BP_use ss_segment
%define What_Segment_Does_SP_use ss_segment
%define What_Segment_Does_EAX_use ds_segment
%define What_Segment_Does_EBX_use ds_segment
%define What_Segment_Does_ECX_use ds_segment
%define What_Segment_Does_EDX_use ds_segment
%define What_Segment_Does_Just_ESI_use ds_segment
%define What_Segment_Does_Just_EDI_use ds_segment
%define What_Address_does_Stos_use ES_DI_address
%define What_Address_does_Lods_use DS_SI_address
%define What_Destination_segment_string_instructions_use es_segment
%define What_Source_segment_string_nstructions_use ds_segment




%macro IF_BOOL_START 1
    %push IF
    test  %1, -1
    jz    %$IF_NOT  
%endmacro


%macro ELSE 0
    %ifctx IF
        %repl %ELSE
        jmp   %$IF_END
        %$IF_NOT:
    %else
        %error there is supposed to be if before else
    %endif
%endmacro


%macro IF_BOOL_END 0
    %ifctx IF
        %$IF_NOT:
        %pop
    %ifctx ELSE
        %$IF_END:
        %pop
    %else
        %error expected something like IF or ELSE before IF_BOOL_END
    %endif
%endmacro


%macro FOR_LOOP_START 3

%push FOR_START

    %define Counter_VAR %1
    %define Start_NUM %2
    %define End_NUM %3

    mov   Counter_VAR, Start_NUM

    %$FOR_START:
    COMPARE Counter_VAR, End_NUM
    je    %$FOR_END

    %if Start_NUM>End_NUM
        dec   %Counter_VAR
    %else
        inc   %Counter_VAR
    %endif

%endmacro

%macro FOR_LOOP_END 0
    %ifnctx FOR_START
        %error Expected FOR_LOOP_START before FOR_LOOP_END
    %endif

    jmp   %$FOR_START
    %$FOR_END:

%pop

%endmacro




%endif
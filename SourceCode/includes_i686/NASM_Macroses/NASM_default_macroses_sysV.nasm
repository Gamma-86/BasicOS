		%define S_Char int8_t
		%define U_Char uint8_t

		%define S_Short int16_t
		%define S_Short_Int int16_t
		%define U_Short uint16_t
		%define U_Short_Int uint16_t

		%define S_int   int32_t
		%define U_int   uint32_t

		%define S_Long  int64_t
		%define S_Long_Int int64_t
		%define U_Long  uint64_t
		%define U_Long_Int uint64_t

		%define S_LongLong int64_t
		%define S_LongLong_Int int64_t
		%define U_LongLong uint64_t
		%define U_LongLong_Int uint64_t

		%define size_t uint64_t

		%define sizeOfInt 4
		%define BitnessOfInt sizeOfInt*8




	%define FREE_REG1_INTSIZE FREE_REG1_32
	%define FREE_REG2_INTSIZE FREE_REG2_32
	%define FREE_REG3_INTSIZE FREE_REG3_32
	%define VOLATILE_REG1_INTSIZE VOLATILE_REG1_32






;DEFINING FREE REGISTERS FOR CURRENT SIZE OF POINTER
;AND SOME OTHER POINTER SIZE SPECIFIC REGISTERS(like esp, ebp)
	%define FREE_REG1_PTRSIZE FREE_REG1_64
	%define FREE_REG2_PTRSIZE FREE_REG2_64
	%define FREE_REG3_PTRSIZE FREE_REG3_64
	%define VOLATIVE_REG1_PTRSIZE VOLATIVE_REG1_64

	%define AX_PTRSIZE rax
	%define BX_PTRSIZE rbx
	%define CX_PTRSIZE rcx
	%define DX_PTRSIZE rdx
	%define SI_PTRSIZE rsi
	%define DI_PTRSIZE rdi
	%define BP_PTRSIZE rbp
	%define SP_PTRSIZE rsp

	%define FREE_REG4_PTRSIZE R8
		%define FREE_REG4_64  R8
		%define FREE_REG4_32  R8D
		%define FREE_REG4_16  R8W 
		%define FREE_REG4_8LOW R8B
	%define FREE_REG5_PTRSIZE R9
		%define FREE_REG5_64 R9
		%define FREE_REG5_32 R9D
		%define FREE_REG5_16 R9W
		%define FREE_REG5_8LOW R9B
	%define FREE_REG6_PTRSIZE R10
		%define FREE_REG6_64 R10
		%define FREE_REG6_32 R10D
		%define FREE_REG6_16 R10W
		%define FREE_REG6_8LOW R10B
	%define FREE_REG7_PTRSIZE R11
		%define FREE_REG7_64 R11
		%define FREE_REG7_32 R11D
		%define FREE_REG7_16 R11W
		%define FREE_REG7_8LOW R11B

	%define FREE_REG4_INTSIZE FREE_REG4_32
	%define FREE_REG5_INTSIZE FREE_REG5_32
	%define FREE_REG6_INTSIZE FREE_REG6_32
	%define FREE_REG7_INTSIZE FREE_REG7_32











;DEFINING ARGUMENTS LOCATION FOR CURRENT POINTER SIZE
		%define STACK_ARG1_SP rdi
			%define STACK_ARG1_SP8 dil
			%define STACK_ARG1_SP16 di
			%define STACK_ARG1_SP32 edi
		%define STACK_ARG2_SP rsi
			%define STACK_ARG2_SP8 sil
			%define STACK_ARG2_SP16 si
			%define STACK_ARG2_SP32 esi   
		%define STACK_ARG3_SP rdx
			%define STACK_ARG3_SP8 dl 
			%define STACK_ARG3_SP16 dx
			%define STACK_ARG3_SP32 edx
		%DEFINE STACK_ARG4_SP rcx
			%define STACK_ARG4_SP8 cl 
			%define STACK_ARG4_SP16 cx
			%define STACK_ARG4_SP32 ecx
		%DEFINE STACK_ARG5_SP r8
			%define STACK_ARG5_SP8 r8b
			%define STACK_ARG5_SP16 r8w
			%define STACK_ARG5_SP32 r8d
		%DEFINE STACK_ARG6_SP r9
			%define STACK_ARG6_SP8 r9b
			%define STACK_ARG6_SP16 r9w
			%define STACK_ARG6_SP32 r9d
        %DEFINE STACK_ARG7_SP [STACK_ARGX_ESP(1)]
            %define STACK_ARG7_SP8 byte[STACK_ARGX_ESP(1)]
            %define STACK_ARG7_SP16 word[STACK_ARGX_ESP(1)]
            %define STACK_ARG7_SP32 dword[STACK_ARGX_ESP(1)]



		%DEFINE STACK_ARG1_BP rdi
			%define STACK_ARG1_BP8 dil
			%define STACK_ARG1_BP16 di
			%define STACK_ARG1_BP32 edi
		%DEFINE STACK_ARG2_BP rsi
			%define STACK_ARG2_BP8 sil
			%define STACK_ARG2_BP16 si
			%define STACK_ARG2_BP32 esi
		%DEFINE STACK_ARG3_BP rdx
			%define STACK_ARG3_BP8 dl
			%define STACK_ARG3_BP16 dx
			%define STACK_ARG3_BP32 edx
		%DEFINE STACK_ARG4_BP rcx
			%define STACK_ARG4_BP8 cl
			%define STACK_ARG4_BP16 cx
			%define STACK_ARG4_BP32 ecx
		%DEFINE STACK_ARG5_BP r8
			%define STACK_ARG5_BP8 r8b
			%define STACK_ARG5_BP16 r8w
			%define STACK_ARG5_BP32 r8d
		%DEFINE STACK_ARG6_BP r9
			%define STACK_ARG6_BP8 r9b
			%define STACK_ARG6_BP16 r9w
			%define STACK_ARG6_BP32 r9d
        %DEFINE STACK_ARG7_BP [STACK_ARGX_EBP(1)]
            %define STACK_ARG7_BP8 byte[STACK_ARGX_EBP(1)]
            %define STACK_ARG7_BP16 word[STACK_ARGX_EBP(1)]
            %define STACK_ARG7_BP32 dword[STACK_ARGX_EBP(1)]
 












;1-name
;2-index
;3-optional argument amount
%macro NASM_DEFAULT_MACROSES_INTERNAL_MACRO_DEFINE_INT_STACK_ARGUMENT_SP8 2-3
    %if %2 < 1
        %error cant define arguments of function for index less than 1
    %elif %2 <= 6
        %define %[%1] STACK_ARG%[%2]_SP8
    %else
        %define %[%1] byte[STACK_ARGX_ESP( ((%2)-6) )] 
    %endif
%endmacro
%macro NASM_DEFAULT_MACROSES_INTERNAL_MACRO_DEFINE_INT_STACK_ARGUMENT_SP16 2-3
    %if %2 < 1
        %error cant define arguments of function for index less than 1
    %elif %2 <= 6
        %define %[%1] STACK_ARG%[%2]_SP16
    %else
        %define %[%1] word[STACK_ARGX_ESP( ((%2)-6) )] 
    %endif
%endmacro
%macro NASM_DEFAULT_MACROSES_INTERNAL_MACRO_DEFINE_INT_STACK_ARGUMENT_SP32 2-3
    %if %2 < 1
        %error cant define arguments of function for index less than 1
    %elif %2 <= 6
        %define %[%1] STACK_ARG%[%2]_SP32
    %else
        %define %[%1] dword[STACK_ARGX_ESP( ((%2)-6) )] 
    %endif
%endmacro
%macro NASM_DEFAULT_MACROSES_INTERNAL_MACRO_DEFINE_INT_STACK_ARGUMENT_SP 2-3
    %if %2 < 1
        %error cant define arguments of function for index less than 1
    %elif %2 <= 6
        %define %[%1] STACK_ARG%[%2]_SP
    %else
        %define %[%1] [STACK_ARGX_ESP( ((%2)-6) )] 
    %endif
%endmacro

;1-name 
;2-index
;3-optional argument amount
%macro NASM_DEFAULT_MACROSES_INTERNAL_MACRO_DEFINE_INT_STACK_ARGUMENT_BP8 2-3
    %if %2 < 1
        %error cant define arguments of function for index less than 1
    %elif %2 <= 6
        %define %[%1] STACK_ARG%[%2]_BP8
    %else
        %define %[%1] byte[STACK_ARGX_EBP( ((%2)-6) )] 
    %endif
%endmacro
%macro NASM_DEFAULT_MACROSES_INTERNAL_MACRO_DEFINE_INT_STACK_ARGUMENT_BP16 2-3
    %if %2 < 1
        %error cant define arguments of function for index less than 1
    %elif %2 <= 6
        %define %[%1] STACK_ARG%[%2]_BP16
    %else
        %define %[%1] word[STACK_ARGX_EBP( ((%2)-6) )] 
    %endif
%endmacro
%macro NASM_DEFAULT_MACROSES_INTERNAL_MACRO_DEFINE_INT_STACK_ARGUMENT_BP32 2-3
    %if %2 < 1
        %error cant define arguments of function for index less than 1
    %elif %2 <= 6
        %define %[%1] STACK_ARG%[%2]_BP32
    %else
        %define %[%1] dword[STACK_ARGX_EBP( ((%2)-6) )] 
    %endif
%endmacro
%macro NASM_DEFAULT_MACROSES_INTERNAL_MACRO_DEFINE_INT_STACK_ARGUMENT_BP 2-3
    %if %2 < 1
        %error cant define arguments of function for index less than 1
    %elif %2 <= 6
        %define %[%1] STACK_ARG%[%2]_BP
    %else
        %define %[%1] [STACK_ARGX_EBP( ((%2)-6) )] 
    %endif
%endmacro











	%define LODS_INT lodsd
	%define STOS_INT stosd
	%define CMPS_INT cmpsd
	%define MOVS_INT movsd

%define AX_INTSIZE eax
%define BX_INTSIZE ebx
%define CX_INTSIZE ecx
%define DX_INTSIZE edx
%define DI_INTSIZE edi
%define SI_INTSIZE esi
%define BP_INTSIZE ebp
%define SP_INTSIZE esp
%define R8_INTSIZE r8d
%define R9_INTSIZE r9d
%define R10_INTISZE r10d
%define R11_INTSIZE r11d
%define R12_INTSIZE r12d 
%define R13_INTSIZE r13d
%define R14_INTSIZE r14d
%define R15_INTSIZE r15d
%ifndef NASM_DEFAULT_MACROS_NASM_SENTRY
%define NASM_DEFAULT_MACROS_NASM_SENTRY

			%define TRUE 1
			%define FALSE 0
			%define NULL 0

%define force_16_bit TRUE

%define SizeOfPTR 4
%define BitnessOfPTR SizeOfPTR*8
%define PTR_BITNESS BitnessOfPTR
		
		%if SizeOfPTR = 4
			bits 32
			%define PTR_word dword
		%elif SizeOfPTR = 8
			bits 64
			%define PTR_word qword
		%elif SizeOfPTR = 2
			%if force_16_bit
				bits 16
				%define NearPTR_word word
				%define FarPTR_word dword
			%else
				%error does not support other pointer sizes except 32 and 64
			%endif
		%else
			%error Bad pointer size
		%endif

		%define SYSTEM_V_ABI_CODE 1
		%define CDCEL_ABI_CODE 2
		%define MS64_ABI_CODE 3
		%define MS32_ABI_CODE 4
%define USED_ABI_CODE CDCEL_ABI_CODE

			%if   USED_ABI_CODE = SYSTEM_V_ABI_CODE
				%if SizeOfPTR = 8
				%else
					%error Bad pointer size when using SYSTEM V ABI, it should be 8
				%endif
			%elif USED_ABI_CODE = CDCEL_ABI_CODE
				%if SizeOfPTR = 4
				%else
					%error Bad pointer size when using CDCEL, it should be 4
				%endif
			%elif USED_ABI_CODE = MS32_ABI_CODE
				%if SizeOfPTR = 4
				%else
					%error Bad pointer size when using MS32 abi, it should be 4
				%endif
			%elif USED_ABI_CODE = MS64_ABI_CODE
				%if SizeOfPTR = 8
				%else
					%error Bad pointer size when using MS64 ABI, it should be 8
				%endif
			%endif

%define FREE_REG1_64 rax
%define FREE_REG1_32 eax
%define FREE_REG1_16 ax
%define FREE_REG1_8LOW al
%define FREE_REG1_8HIGH ah
%define FREE_REG1_INTSIZE FREE_REG1_32


%define FREE_REG2_64 rcx
%define FREE_REG2_32 ecx
%define FREE_REG2_16 cx
%define FREE_REG2_8LOW cl
%define FREE_REG2_8HIGH ch
%define FREE_REG2_INTSIZE FREE_REG2_32



%define FREE_REG3_64 rdx
%define FREE_REG3_32 edx
%define FREE_REG3_16 dx
%define FREE_REG3_8LOW dl
%define FREE_REG3_8HIGH dh
%define FREE_REG3_INTSIZE FREE_REG3_32


%define VOLATILE_REG1_64 rbx
%define VOLATILE_REG1_32 ebx
%define VOLATILE_REG1_16 bx
%define VOLATILE_REG1_8LOW bl
%define VOLATILE_REG1_8high bh
%define VOLATILE_REG1_INTSIZE VOLATILE_REG1_32


;DEFINING FREE REGISTERS FOR CURRENT SIZE OF POINTER

%if SizeOfPTR = 8
	%define BP_NATIVE RBP
	%define SP_NATIVE RSP
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
	%define FREE_REG5_PTRSIZE R10
		%define FREE_REG6_64 R10
		%define FREE_REG6_32 R10D
		%define FREE_REG6_16 R10W
		%define FREE_REG6_8LOW R10B
	%define FREE_REG5_PTRSIZE R11
		%define FREE_REG7_64 R11
		%define FREE_REG7_32 R11D
		%define FREE_REG7_16 R11W
		%define FREE_REG7_8LOW R11B

	%define FREE_REG4_INTSIZE FREE_REG4_32
	%define FREE_REG5_INTSIZE FREE_REG5_32
	%define FREE_REG6_INTSIZE FREE_REG4_32
	%define FREE_REG7_INTSIZE FREE_REG5_32

%elif SizeOfPTR = 4
	%define BP_NATIVE EBP
	%define SP_NATIVE ESP
	%define FREE_REG1_PTRSIZE FREE_REG1_32
	%define FREE_REG2_PTRSIZE FREE_REG2_32
	%define FREE_REG3_PTRSIZE FREE_REG3_32
	%define VOLATILE_REG1_PTRSIZE VOLATIVE_REG1_32

	%define AX_PTRSIZE eax
	%define BX_PTRSIZE ebx
	%define CX_PTRSIZE ecx
	%define DX_PTRSIZE edx
	%define SI_PTRSIZE esi
	%define DI_PTRSIZE edi
	%define BP_PTRSIZE ebp
	%define SP_PTRSIZE esp

%elif SizeOfPTR = 2
	%define BP_NATIVE BP
	%define SP_NATIVE SP
	%define FREE_REG1_PTRSIZE FREE_REG1_16
	%define FREE_REG2_PTRSIZE FREE_REG2_16
	%define FREE_REG3_PTRSIZE FREE_REG3_16
	%define VOLATILE_REG1_PTRSIZE VOLATIVE_REG1_16

	%define AX_PTRSIZE ax
	%define BX_PTRSIZE bx
	%define CX_PTRSIZE cx
	%define DX_PTRSIZE dx
	%define SI_PTRSIZE si
	%define DI_PTRSIZE di
	%define BP_PTRSIZE bp
	%define SP_PTRSIZE sp
%else
	%error Cound not define native REGs for current Pointer size in bytes
%endif

%define NATIVE_BP BP_NATIVE
%define NATIVE_SP SP_NATIVE

%if SizeOfPTR = 4
	%define DFINE_PTR dd
%elif SizeOfPTR = 8
	%define DFINE_PTR dq
%elif SizeOfPTR = 2
	%define DFINE_PTR dw
%else
	%error Bad pointer size
%endif


%define STACK_ARG_ESP(X) (SP_NATIVE +SizeOfPTR*(X))
%define STACK_ARG_EBP(X) (BP_NATIVE +SizeOfPTR+SizeOfPTR*(X))
%define LOCAL_VAR(X) (BP_NATIVE -SizeOfPTR*(X))

;DEFINING ATGUMENTS LOCATION FOR CURRENT POINTER SIZE

%if   SizeOfPTR = 4
	%define STACK_ARG1_SP [STACK_ARG_ESP(1)]
		%define STACK_ARG1_SP8 byte[STACK_ARG_ESP(1)]
		%define STACK_ARG1_SP16 word[STACK_ARG_ESP(1)]
		%define STACK_ARG1_SP32 dword[STACK_ARG_ESP(1)]   
	%define STACK_ARG2_SP [STACK_ARG_ESP(2)]
		%define STACK_ARG2_SP8 byte[STACK_ARG_ESP(2)]
		%define STACK_ARG2_SP16 word[STACK_ARG_ESP(2)]
		%define STACK_ARG2_SP32 dword[STACK_ARG_ESP(2)]
	%define STACK_ARG3_SP [STACK_ARG_ESP(3)]
		%define STACK_ARG3_SP8 byte[STACK_ARG_ESP(3)]
		%define STACK_ARG3_SP16 word[STACK_ARG_ESP(3)]
		%define STACK_ARG3_SP32 dword[STACK_ARG_ESP(3)]
	%DEFINE STACK_ARG4_SP [STACK_ARG_ESP(4)]
		%define STACK_ARG4_SP8 byte[STACK_ARG_ESP(4)]
		%define STACK_ARG4_SP16 word[STACK_ARG_ESP(4)]
		%define STACK_ARG4_SP32 dword[STACK_ARG_ESP(4)]
	%DEFINE STACK_ARG5_SP [STACK_ARG_ESP(5)]
		%define STACK_ARG5_SP8 byte[STACK_ARG_ESP(5)]
		%define STACK_ARG5_SP16 word[STACK_ARG_ESP(5)]
		%define STACK_ARG5_SP32 dword[STACK_ARG_ESP(5)]
	%DEFINE STACK_ARG6_SP [STACK_ARG_ESP(6)]
		%define STACK_ARG6_SP8 byte[STACK_ARG_ESP(6)]
		%define STACK_ARG6_SP16 word[STACK_ARG_ESP(6)]
		%define STACK_ARG6_SP32 dword[STACK_ARG_ESP(6)]



	%DEFINE STACK_ARG1_BP [STACK_ARG_EBP(1)]
		%define STACK_ARG1_BP8 byte[STACK_ARG_EBP(1)]
		%define STACK_ARG1_BP16 word[STACK_ARG_EBP(1)]
		%define STACK_ARG1_BP32 dword[STACK_ARG_EBP(1)]
	%DEFINE STACK_ARG2_BP [STACK_ARG_EBP(2)]
		%define STACK_ARG2_BP8 byte[STACK_ARG_EBP(2)]
		%define STACK_ARG2_BP16 word[STACK_ARG_EBP(2)]
		%define STACK_ARG2_BP32 dword[STACK_ARG_EBP(2)]
	%DEFINE STACK_ARG3_BP [STACK_ARG_EBP(3)]
		%define STACK_ARG3_BP8 byte[STACK_ARG_EBP(3)]
		%define STACK_ARG3_BP16 word[STACK_ARG_EBP(3)]
		%define STACK_ARG3_BP32 dword[STACK_ARG_EBP(3)]
	%DEFINE STACK_ARG4_BP [STACK_ARG_EBP(4)]
		%define STACK_ARG4_BP8 byte[STACK_ARG_EBP(4)]
		%define STACK_ARG4_BP16 word[STACK_ARG_EBP(4)]
		%define STACK_ARG4_BP32 dword[STACK_ARG_EBP(4)]
	%DEFINE STACK_ARG5_BP [STACK_ARG_EBP(5)]
		%define STACK_ARG5_BP8 byte[STACK_ARG_EBP(5)]
		%define STACK_ARG5_BP16 word[STACK_ARG_EBP(5)]
		%define STACK_ARG5_BP32 dword[STACK_ARG_EBP(5)]
	%DEFINE STACK_ARG6_BP [STACK_ARG_EBP(6)]
		%define STACK_ARG6_BP8 byte[STACK_ARG_EBP(6)]
		%define STACK_ARG6_BP16 word[STACK_ARG_EBP(6)]
		%define STACK_ARG6_BP32 dword[STACK_ARG_EBP(6)]
%elif SizeOfPTR = 8
	%if  USED_ABI_CODE = MS64_ABI_CODE
		%define STACK_ARG1_SP rcx
			%define STACK_ARG1_SP8 cl 
			%define STACK_ARG1_SP16 cx
			%define STACK_ARG1_SP32 ecx   
		%define STACK_ARG2_SP rdx
			%define STACK_ARG2_SP8 dl
			%define STACK_ARG2_SP16 dx
			%define STACK_ARG2_SP32 edx
		%define STACK_ARG3_SP r8
			%define STACK_ARG3_SP8 r8b 
			%define STACK_ARG3_SP16 r8w
			%define STACK_ARG3_SP32 r8d
		%DEFINE STACK_ARG4_SP r9
			%define STACK_ARG4_SP8 r9b
			%define STACK_ARG4_SP16 r9w
			%define STACK_ARG4_SP32 r9d
		%DEFINE STACK_ARG5_SP [STACK_ARG_ESP(1)]
			%define STACK_ARG5_SP8 byte[STACK_ARG_ESP(1)] 
			%define STACK_ARG5_SP16LOW word[STACK_ARG_ESP(1)]
			%define STACK_ARG5_SP32 dword[STACK_ARG_ESP(1)]
		%DEFINE STACK_ARG6_SP [STACK_ARG_ESP(2)]
			%define STACK_ARG6_SP8 byte[STACK_ARG_ESP(2)] 
			%define STACK_ARG6_SP16 word[STACK_ARG_ESP(2)]
			%define STACK_ARG6_SP32 dword[STACK_ARG_ESP(2)]

		%DEFINE STACK_ARG1_BP rcx
			%define STACK_ARG1_BP8 cl 
			%define STACK_ARG1_BP16 cx
			%define STACK_ARG1_BP32 ecx   
		%DEFINE STACK_ARG2_BP rdx
			%define STACK_ARG2_BP8 dl 
			%define STACK_ARG2_BP16 dx
			%define STACK_ARG2_BP32 edx
		%DEFINE STACK_ARG3_BP r8
			%define STACK_ARG3_BP8 dl 
			%define STACK_ARG3_BP16 dx
			%define STACK_ARG3_BP32 edx
		%DEFINE STACK_ARG4_BP r9
			%define STACK_ARG4_BP8 r9b 
			%define STACK_ARG4_BP16 r9w
			%define STACK_ARG4_BP32 r9d
		%DEFINE STACK_ARG5_BP [STACK_ARG_EBP(1)]
			%define STACK_ARG5_BP8 byte[STACK_ARG_EBP(1)]
			%define STACK_ARG5_BP16 word[STACK_ARG_EBP(1)]
			%define STACK_ARG5_BP32 dword[STACK_ARG_EBP(1)]
		%DEFINE STACK_ARG6_BP [STACK_ARG_EBP(2)]
			%define STACK_ARG6_BP8 byte[STACK_ARG_EBP(2)]
			%define STACK_ARG6_BP16 word[STACK_ARG_EBP(2)]
			%define STACK_ARG6_BP32 dword[STACK_ARG_EBP(2)]


	%elif USED_ABI_CODE = SYSTEM_V_ABI_CODE
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


		%DEFINE STACK_ARG1_BP rdi
			%define STACK_ARG1_SP8 dil
			%define STACK_ARG1_SP16 di
			%define STACK_ARG1_SP32 edi
		%DEFINE STACK_ARG2_BP rsi
			%define STACK_ARG2_SP8 sil
			%define STACK_ARG2_SP16 si
			%define STACK_ARG2_SP32 esi
		%DEFINE STACK_ARG3_BP rdx
			%define STACK_ARG3_SP8 dl
			%define STACK_ARG3_SP16 dx
			%define STACK_ARG3_SP32 edx
		%DEFINE STACK_ARG4_BP rcx
			%define STACK_ARG4_SP8 cl
			%define STACK_ARG4_SP16 cx
			%define STACK_ARG4_SP32 ecx
		%DEFINE STACK_ARG5_BP r8
			%define STACK_ARG5_SP8 r8b
			%define STACK_ARG5_SP16 r8w
			%define STACK_ARG5_SP32 r8d
		%DEFINE STACK_ARG6_BP r9
			%define STACK_ARG6_SP8 r9b
			%define STACK_ARG6_SP16 r9w
			%define STACK_ARG6_SP32 r9d

	%else
		%error Could not define Arguments location for current combination of ABI and pointer size
	%endif	
%else
	%error Cound not define Arguments location for current Pointer size in bytes
%endif


%macro MOV_LITL_OPTIMIZED 2
	%IFIDNI %1,%2
	%ELSE
	mov   %1,%2
	%ENDIF
%endmacro


%define UINT8_MIN 0
%define UINT8_MAX 255
%define SINT8_MIN 0x80
%define SINT8_MAX 0x7F

%define UINT16_MIN 0
%define UINT16_MAX 0xFFFF
%define SINT16_MIN 0x8000
%define SINT16_MAX 0x7FFF

%define UINT32_MIN 0
%define UINT32_MAX 0xFFFF_FFFF
%define SINT32_MIN 0x8000_0000
%define SINT32_MAX 0x7FFF_FFFF

%define UINT64_MIN 0
%define UINT64_MAX 0xFFFF_FFFF_FFFF_FFFF
%define SINT64_MIN 0x8000_0000_0000_0000
%define SINT64_MAX 0x7FFF_FFFF_FFFF_FFFF

%macro MACRO_ENTER16 2
	%if %2=0
		%if %1=0
			push  bp
			mov   bp,sp
		%else
			push  bp
			mov   bp,sp
			sub   sp,%1
		%endif
	%else
		enter %1,%2
	%endif
%endmacro


%macro MACRO_ENTER32 2
	%if %2=0
		%if %1=0
			push  ebp
			mov   ebp,esp
		%else
			push  ebp
			mov   ebp,esp
			sub   esp,%1
		%endif
	%else
		enter %1,%2
	%endif
%endmacro


%macro MACRO_ENTER64 2
	%if %2=0
		%if %1=0
			push  rbp
			mov   rbp,rsp
		%else
			push  rbp,rsp
			mov   rbp,rsp
			sub   rsp,%1
		%endif
	%else
		enter   %1,%2
	%endif
%endmacro

%macro MACRO_ENTER_NATIVE 2
	%if SizeOfPTR=8
		MACRO_ENTER64 %1,%2
	%elif SizeOfPTR=4
		MACRO_ENTER32 %1,%2
	%elif SizeOfPTR=2
		MACRO_ENTER16 %1,%2
	%else
		%error "Could not create native macor enter because of SizeOfPTR "
	%endif 
%endmacro


%macro ADD_MEM_MEM__mem_mem_FreeReg_bitness 3-4
	%if %3 = 0
		%if %4=32
			push  eax
						
			mov   eax,[%1]
			add   eax,[%2]
			mov   [%1],eax
						
			pop   eax
		%elif %4=16
			push  eax
				
			movzx eax,word [%1]
			add   ax,[%2]
			mov   [%1],ax
				
			pop   eax
		%elif %4=8
			push  eax
						
			movzx eax,byte [%1]
			add   al,[%2]
			mov   [%1],al
						
			pop   eax
		%elif %4=64
			push  rax

			mov   rax, [%1]
			add   rax, [%2]
			mov   [%1], rax

			pop   rax
		%else
			%error WRONG SIZE(fourth param) at ADD_MEM_MEM macro
		%endif
	%else
		mov  %3,[%2]
		add  [%1],%3
	%endif
%endmacro


%macro SUB_MEM_MEM__mem_mem_FreeReg_bitness 3-4
	%if %3 = 0
			%if %4=32
				push  eax
						
				mov   eax,[%1]
				sub   eax,[%2]
				mov   [%1],eax
						
				pop   eax
			%elif %4=16
				push  eax
				
				movzx eax,word [%1]
				sub   ax,[%2]
				mov   [%1],ax
				
				pop   eax
			%elif %4=8
				push  eax
					
				movzx eax,byte [%1]
				sub   al,[%2]
				mov   [%1],al
						
				pop   eax
			%elif %4=64
				push  rax

				mov   rax,[%1]
				sub   rax,[%2]
				mov   [%1],rax				
			%else
				%error WRONG SIZE(fourth param) at SUB_MEM_MEM macro
				%endif
	%else
		mov  %3,[%2]
		add  [%1],%3
	%endif
%endmacro


%macro TEST_REG_NULL_PTR 1
	test %1,%1
%endmacro


%macro TEST_REG_NULL 1
	TEST_REG_NULL_PTR %1
%endmacro


%macro MOV_REG_IMM 2
	%if %2=0
		xor   %1,%1
	%elif %2=-1
		xor   %1,%1
		not   %1
	%else
		mov   %1,%2
	%endif
%endmacro


%macro GET_REL_ADDRESS_TO_REG 2
	call  .get_eip%$
	.get_eip%$:
	pop   %2
	lea   %2, [%2-.get_eip%$ + %1]
%endmacro


%define BIT_MASK(X) (1<<(X))


%macro ALLOC_STACK__size_retReg 2
	sub   SP_NATIVE,%1
	mov   %2,SP_NATIVE
%endmacro


 %macro ALLOC_STACK_ALIGN16__size_retReg 2
	sub   SP_NATIVE, %1
	and   SP_NATIVE, ~(0xF)
	mov   %2, SP_NATIVE
%endmacro


%macro ALIGN16_CALL_STACK__ArgsAmount 1
	%assign ArgsSizeBytes %1*SizeOfPTR
	%assign SubAmount ArgsSizeBytes&0xF
	%assign SubAmount 16-SubAmount
	%assign SubAmount SubAmount&0xF

	sub   SP_NATIVE, SubAmount

	%undef ArgsSizeBytes
	%undef SubAmount
%endmacro


%macro CLEAN_CALL_STACK__ArgsAmount 1
	add   SP_NATIVE, %1*SizeOfPTR
%endmacro


%macro ALIGN16_STACK_FLOOR 0
	and   SP_NATIVE, ~(0xF)
%endmacro


%macro ALIGN16_STACK_ROOF__freeReg 1
mov %1, SP_NATIVE
	neg %1
	and %1, 0xF
add SP_NATIVE, %1
%endmacro


%endif

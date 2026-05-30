%ifndef NASM_DEFAULT_MACROS_NASM_SENTRY
%define NASM_DEFAULT_MACROS_NASM_SENTRY

			%define TRUE 1
			%define FALSE 0
			%define NULL 0

	struc ABI_ENUM
		.reserved resb 1
		.SYSTEM_V resb 1
		.CDCEL resb 1
		.MS64 resb 1
		.MS32 resb 1

		;.Pascall16
		;.STDCall16
		;.FastCall16
	endstruc
%define SizeOfPTR 4
%define BitnessOfPTR SizeOfPTR*8
%define PTR_BITNESS BitnessOfPTR
%define USED_ABI_CODE ABI_ENUM.CDCEL

		%if SizeOfPTR = 4
			bits 32
			%define PTR_word dword
			%define FarPTR_present
			%define SizeOfFarPTR 6
			%define BitnessOfFarPTR SizeOfFarPTR*8
		%elif SizeOfPTR = 8
			bits 64
			%define PTR_word qword
		%elif SizeOfPTR = 2
			bits 16
			%define NearPTR_word word
			%define FarPTR_word dword
			%define FarPTR_present
			%define SizeOfFarPTR 4
			%define BitnessOfFarPTR SizeOfFarPTR*8
		%else
			%error Bad pointer size
		%endif
;		%define ABI_ENUM.SYSTEM_V 1
;		%define ABI_ENUM.CDCEL 2
;		%define ABI_ENUM.MS64 3
;		%define ABI_ENUM.MS32 4

			%if   USED_ABI_CODE = ABI_ENUM.SYSTEM_V
				%if SizeOfPTR = 8
				%else
					%error Bad pointer size when using SYSTEM V ABI, it should be 8
				%endif
			%elif USED_ABI_CODE = ABI_ENUM.CDCEL
				%if SizeOfPTR = 4
				%else
					%error Bad pointer size when using CDCEL, it should be 4
				%endif
			%elif USED_ABI_CODE = ABI_ENUM.MS32
				%if SizeOfPTR = 4
				%else
					%error Bad pointer size when using MS32 abi, it should be 4
				%endif
			%elif USED_ABI_CODE = ABI_ENUM.MS64
				%if SizeOfPTR = 8
				%else
					%error Bad pointer size when using MS64 ABI, it should be 8
				%endif
			%endif












;DEFINING TYPES

;Those types that are taken from C or whatever
;It seems like people use insesnsitive, immediate define for some reason
%ixdefine int8_t     byte
%ixdefine uint8_t    byte
%ixdefine int16_t    word
%ixdefine uint16_t   word
%ixdefine int32_t    dword
%ixdefine uint32_t   dword
%ixdefine long32_t   dword
%ixdefine ulong32_t  dword
%ixdefine int64_t    qword
%ixdefine uint64_t   qword
%ixdefine int80_t    tword
%ixdefine uint80_t   tword
%ixdefine int128_t   oword
%ixdefine uint128_t  oword
%ixdefine long64_t   qword
%ixdefine ulong64_t  qword
%ixdefine long128_t  oword
%ixdefine ulong128_t oword
%ixdefine float      dword
%ixdefine double     qword
%ixdefine long_double tword

;Settign C types depending on used ABI
%IF USED_ABI_CODE = ABI_ENUM.SYSTEM_V
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


		%define sizeOfInt 4
		%define BitnessOfInt sizeOfInt*8
%ELIF USED_ABI_CODE=ABI_ENUM.CDCEL
		%define S_Char int8_t
		%define U_Char uint8_t

		%define S_Short int16_t
		%define S_Short_Int int16_t
		%define U_Short uint16_t
		%define U_Short_Int uint16_t

		%define S_int   int32_t
		%define U_int   uint32_t

		%define S_Long  int32_t
		%define S_Long_Int int32_t
		%define U_Long  uint32_t
		%define U_Long_Int uint32_t

		%define S_LongLong int64_t
		%define S_LongLong_Int int64_t
		%define U_LongLong uint64_t
		%define U_LongLong_Int uint64_t

		
		%define SizeOfInt 4
		%define BitnessOfInt SizeOfInt*8
%ELIF USED_ABI_CODE=ABI_ENUM.MS64
		%define S_Char int8_t
		%define U_Char uint8_t

		%define S_Short int16_t
		%define S_Short_Int int16_t
		%define U_Short uint16_t
		%define U_Short_Int uint16_t

		%define S_int   int32_t
		%define U_int   uint32_t

		%define S_Long  int32_t
		%define S_Long_Int int32_t
		%define U_Long  uint32_t
		%define U_Long_Int uint32_t

		%define S_LongLong int64_t
		%define S_LongLong_Int int64_t
		%define U_LongLong uint64_t
		%define U_LongLong_Int uint64_t

		
		%define SizeOfInt 4
		%define BitnessOfInt SizeOfInt*8
%ELIF USED_ABI_CODE=ABI_ENUM.MS32
		%define S_Char int8_t
		%define U_Char uint8_t

		%define S_Short int16_t
		%define S_Short_Int int16_t
		%define U_Short uint16_t
		%define U_Short_Int uint16_t

		%define S_int   int32_t
		%define U_int   uint32_t

		%define S_Long  int32_t
		%define S_Long_Int int32_t
		%define U_Long  uint32_t
		%define U_Long_Int uint32_t

		%define S_LongLong int64_t
		%define S_LongLong_Int int64_t
		%define U_LongLong uint64_t
		%define U_LongLong_Int uint64_t


		%define SizeOfInt 4
		%define BitnessOfInt SizeOfInt*8
%ELSE
	%warning I didnt understand what ABI you use(It Is:USED_ABI_CODE)
	%warning I will use type definition for Linux32/64 or MS DOS 16
	%if SizeOfPTR = 8
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


		%define SizeOfInt 4
		%define BitnessOfInt SizeOfInt*8
	%elif SizeOfPTR = 4
		%define S_Char int8_t
		%define U_Char uint8_t

		%define S_Short int16_t
		%define S_Short_Int int16_t
		%define U_Short uint16_t
		%define U_Short_Int uint16_t

		%define S_int   int32_t
		%define U_int   uint32_t

		%define S_Long  int32_t
		%define S_Long_Int int32_t
		%define U_Long  uint32_t
		%define U_Long_Int uint32_t

		%define S_LongLong int64_t
		%define S_LongLong_Int int64_t
		%define U_LongLong uint64_t
		%define U_LongLong_Int uint64_t


		%define SizeOfInt 4
		%define BitnessOfInt SizeOfInt*8
	%else ;It is 16 bit, so use MS DOS
		%define S_Char int8_t
		%define U_Char uint8_t

		%define S_Short int16_t
		%define S_Short_Int int16_t
		%define U_Short uint16_t
		%define U_Short_Int uint16_t

		%define S_int   int16_t
		%define U_int   uint16_t

		%define S_Long  int32_t
		%define S_Long_Int int32_t
		%define U_Long  uint32_t
		%define U_Long_Int uint32_t

;		I guess it will be fine if we still use these guys
		%define S_LongLong int64_t
		%define S_LongLong_Int int64_t
		%define U_LongLong uint64_t
		%define U_LongLong_Int uint64_t


		%define SizeOfInt 2
		%define BitnessOfInt SizeOfInt*8
	%endif
%endif
;Defining the most basic register aliases

%define FREE_REG1_64 rax
%define FREE_REG1_32 eax
%define FREE_REG1_16 ax
%define FREE_REG1_8LOW al
%define FREE_REG1_8HIGH ah
%IF BitnessOfInt = 64
	%define FREE_REG1_INTSIZE FREE_REG1_64
%ELIF BitnessOfInt=32
	%define FREE_REG1_INTSIZE FREE_REG1_32
%ELSE
	%define FREE_REG1_INTSIZE FREE_REG1_16
%endif

%define FREE_REG2_64 rcx
%define FREE_REG2_32 ecx
%define FREE_REG2_16 cx
%define FREE_REG2_8LOW cl
%define FREE_REG2_8HIGH ch
%IF BitnessOfInt = 64
	%define FREE_REG2_INTSIZE FREE_REG2_64
%ELIF BitnessOfInt=32
	%define FREE_REG2_INTSIZE FREE_REG2_32
%ELSE
	%define FREE_REG2_INTSIZE FREE_REG2_16
%endif



%define FREE_REG3_64 rdx
%define FREE_REG3_32 edx
%define FREE_REG3_16 dx
%define FREE_REG3_8LOW dl
%define FREE_REG3_8HIGH dh
%IF BitnessOfInt = 64
	%define FREE_REG3_INTSIZE FREE_REG3_64
%ELIF BitnessOfInt=32
	%define FREE_REG3_INTSIZE FREE_REG3_32
%ELSE
	%define FREE_REG3_INTSIZE FREE_REG3_16
%endif


%define VOLATILE_REG1_64 rbx
%define VOLATILE_REG1_32 ebx
%define VOLATILE_REG1_16 bx
%define VOLATILE_REG1_8LOW bl
%define VOLATILE_REG1_8high bh
%IF BitnessOfInt = 64
	%define VOLATILE_REG1_INTSIZE VOLATILE_REG1_64
%ELIF BitnessOfInt=32
	%define VOLATILE_REG1_INTSIZE VOLATILE_REG1_32
%ELSE
	%define VOLATILE_REG1_INTSIZE BOLATILE_REG1_16
%endif


;DEFINING FREE REGISTERS FOR CURRENT SIZE OF POINTER
;AND SOME OTHER POINTER SIZE SPECIFIC REGISTERS(like esp, ebp)
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
	%define DEFINE_PTR dd
%elif SizeOfPTR = 8
	%define DEFINE_PTR dq
%elif SizeOfPTR = 2
	%define DEFINE_PTR dw
	%define DEFINE_FAR_PTR(Segment, Offset) dw (Offset), (Segment)
%else
	%error Bad pointer size
%endif


%define STACK_ARG_ESP(X) (SP_NATIVE +SizeOfPTR*(X))
%define STACK_ARG_EBP(X) (BP_NATIVE +SizeOfPTR+SizeOfPTR*(X))
%define LOCAL_VAR(X) (BP_NATIVE -SizeOfPTR*(X))


%define STACK_ARG_ESP_FAR(X) (SP_NATIVE +SizeOfPTR*(X) +SizeOfPTR*1)
%define STACK_ARG_EBP_FAR(X) (BP_NATIVE +SizeOfPTR*(X) +SizeOfPTR*2)

%define STACK_ARG_ESP_INT(X) (SP_NATIVE +SizeOfPTR*(X) + SizeOfPTR*2)
%define STACK_ARG_EBP_INT(X) (BP_NATIVE +SizeOfPTR*(X) + SizeOfPTR*3)
;DEFINING ARGUMENTS LOCATION FOR CURRENT POINTER SIZE

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
	%if  USED_ABI_CODE = ABI_ENUM.MS64
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
			%define STACK_ARG5_SP16 word[STACK_ARG_ESP(1)]
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
			%define STACK_ARG3_BP8 r8b 
			%define STACK_ARG3_BP16 r8w
			%define STACK_ARG3_BP32 r8d
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


	%elif USED_ABI_CODE = ABI_ENUM.SYSTEM_V
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

	%else
		%error Could not define Arguments location for current combination of ABI and pointer size
	%endif
%elif SizeOfPTR = 2
	%if USED_ABI_CODE = ABI_ENUM.CDCEL

		%assign i 1
		%rep 10
			%define STACK_ARG%[i]_SP        [STACK_ARG_ESP(i)]
				%define STACK_ARG1_SP8  byte[STACK_ARG_ESP(i)]
				%define STACK_ARG1_SP16 word[STACK_ARG_ESP(i)]

			%define STACK_ARG1_SP_FAR       [STACK_ARG_ESP_FAR(i)]
				%define STACK_ARG1_SP_FAR8  byte[STACK_ARG_ESP_FAR(i)]
				%define STACK_ARG1_SP_FAT16 word[STACK_ARG_ESP_FAR(i)]

			%define STACK_ARG1_SP_INT           [STACK_ARG_ESP_INT(i)]
				%define STACK_ARG1_SP_INT8  byte[STACK_ARG_ESP_INT(i)]
				%define STACK_ARG1_SP_INT16 word[STACK_ARG_ESP_INT(i)]

			%define STACK_ARG1_BP           [STACK_ARG_EBP(i)]
				%define STACK_ARG1_BP8  byte[STACK_ARG_EBP(i)]
				%define STACK_ARG1_BP16 word[STACK_ARG_EBP(i)]

			%define STACK_ARG1_BP_FAR           [STACK_ARG_EBP_FAR(i)]
				%define STACK_ARG1_BP_FAR8  byte[STACK_ARG_EBP_FAR(i)]
				%define STACK_ARG1_BP_FAR16 word[STACK_ARG_EBP_FAR(i)]

			%define STACK_ARG1_BP_INT           [STACK_ARG_EBP_INT(i)]
				%define STACK_ARG1_BP_INT8  byte[STACK_ARG_EBP_INT(i)]
				%define STACK_ARG1_BP_INT16 word[STACK_ARG_EBP_INT(i)]
		%endrep
		%undef i
	%endif
%else
	%error Cound not define Arguments location for current Pointer size in bytes
%endif




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

;DEfining Native string instrucitons
%IF SizeOfInt = 2
	%ixdefine LODS_INT lodsw
	%ixdefine STOS_INT stosw
	%ixdefine CMPS_INT cmpsw
	%ixdefine MOVS_INT movsw
%ELIF SizeOfInt = 4
	%ixdefine LODS_INT lodsd
	%ixdefine STOS_INT stosd
	%ixdefine CMPS_INT cmpsd
	%ixdefine MOVS_INT movsd
%elif SizeOfInt = 8
	%ixdefine LODS_INT lodsq
	%ixdefine STOS_INT stosq
	%ixdefine CMPS_INT cmpsq
	%ixdefine MOVS_INT movsq
%endif

%IF SizeOfPTR = 2
	%ixdefine LODS_PTR lodsw
	%ixdefine STOS_PTR stosw
	%ixdefine CMPS_PTR cmpsw
	%ixdefine MOVS_PTR movsw
%ELIF SizeOfPTR = 4
	%ixdefine LODS_PTR lodsd
	%ixdefine STOS_PTR stosd
	%ixdefine CMPS_PTR cmpsd
	%ixdefine MOVS_PTR movsd
%elif SizeOfPTR = 8
	%ixdefine LODS_PTR lodsq
	%ixdefine STOS_PTR stosq
	%ixdefine CMPS_PTR cmpsq
	%ixdefine MOVS_PTR movsq
%endif




%macro MOV_LITL_OPTIMIZED 2
	%IFIDNI %1,%2
	%ELSE
	mov   %1,%2
	%ENDIF
%endmacro



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
	%IF SizeOfPTR = 8
	lea   %1, [rel %2]
	%ELSE
	call  .get_eip%$
	.get_eip%$:
	pop   %2
	lea   %2, [%2-.get_eip%$ + %1]
	%ENDIF
%endmacro


%define BIT_MASK(X) (1<<(X))
%define NOT_BIT_MASK(X) (~(1<<(X)))


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
	%push CONTEXT
	%assign ArgsSizeBytes (%1)*SizeOfPTR
	%assign SubAmount ArgsSizeBytes&0xF
	%assign SubAmount 16-SubAmount
	%assign SubAmount SubAmount&0xF

	sub   SP_NATIVE, SubAmount

	%undef ArgsSizeBytes
	%undef SubAmount
	%pop
%endmacro


%macro CLEAN_CALL_STACK__ArgsAmount 1
	add   SP_NATIVE, (%1)*SizeOfPTR
%endmacro


%macro ALIGN16_REG_FLOOR 1
	and   %1, ~(0xF)
%endmacro
%macro ALIGN16_REG_ROOF 1
add   %1, 15
and   %1, 0xF
%endmacro
%macro ALIGN_16_STACK_FLOOR 0
	ALIGN16_REG_FLOOR SP_NATIVE
%endmacro
%macro ALIGN16_STACK_ROOF 0
	ALIGN16_REG_ROOF SP_NATIVE
%endmacro


%macro ALIGN8_REG_FLOOR 1
	and   %1, 7
%endmacro
%macro ALIGN8_REG_ROOF 1
	add   %1, 7
	and   %1, 7
%endmacro
%macro ALIGN8_STACK_FLOOR 0
	ALIGN8_REG_FLOOR SP_NATIVE
%endmacro
%macro ALIGN8_STACK_ROOF 0
	ALIGN8_REG_ROOF SP_NATIVE
%endmacro

%macro COMPARE 2
	%if   %2=0
		test  %1, %1
	%else
		cmp   %1, %2
	%endif
%endmacro

%macro MOV_ALL_1s 1
	xor   %1, %1
	not   %1
%endmacro

%macro Is_It_General_Register64 1
	%IFIDNI %1, rax
		%define Is_It_General_Register64_BOOL 1
	%elifidni %1, rbx
		%define Is_It_General_Register64_BOOL 1
	%elifidni %1, rcx
		%define Is_It_General_Register64_BOOL 1
	%elifidni %1, rdx
		%define Is_It_General_Register64_BOOL 1
	%elifidni %1, rsi
		%define Is_It_General_Register64_BOOL 1
	%elifidni %1, rdi
		%define Is_It_General_Register64_BOOL 1
	%elifidni %1, rbp
		%define Is_It_General_Register64_BOOL 1
	%elifidni %1, rsp
		%define Is_It_General_Register64_BOOL 1
	%elifidni %1, r8
		%define Is_It_General_Register64_BOOL 1
	%elifidni %1, r9
		%define Is_It_General_Register64_BOOL 1
	%elifidni %1, r10
		%define Is_It_General_Register64_BOOL 1
	%elifidni %1, r11
		%define Is_It_General_Register64_BOOL 1
	%elifidni %1, r12
		%define Is_It_General_Register64_BOOL 1
	%elifidni %1, r13
		%define Is_It_General_Register64_BOOL 1
	%elifidni %1, r14
		%define Is_It_General_Register64_BOOL 1
	%elifidni %1, r15
		%define Is_It_General_Register64_BOOL 1
	%else
		%define Is_It_General_Register64_BOOL 0
	%endif
%endmacro

%macro Is_It_General_Register32 1
	%IFIDNI %1, eax
		%define Is_It_General_Register32_BOOL 1
	%elifidni %1, ebx
		%define Is_It_General_Register32_BOOL 1
	%elifidni %1, ecx
		%define Is_It_General_Register32_BOOL 1
	%elifidni %1, edx
		%define Is_It_General_Register32_BOOL 1
	%elifidni %1, esi
		%define Is_It_General_Register32_BOOL 1
	%elifidni %1, edi
		%define Is_It_General_Register32_BOOL 1
	%elifidni %1, ebp
		%define Is_It_General_Register32_BOOL 1
	%elifidni %1, esp
		%define Is_It_General_Register32_BOOL 1
	%elifidni %1, r8d
		%define Is_It_General_Register32_BOOL 1
	%elifidni %1, r9d
		%define Is_It_General_Register32_BOOL 1
	%elifidni %1, r10d
		%define Is_It_General_Register32_BOOL 1
	%elifidni %1, r11d
		%define Is_It_General_Register32_BOOL 1
	%elifidni %1, r12d
		%define Is_It_General_Register32_BOOL 1
	%elifidni %1, r13d
		%define Is_It_General_Register32_BOOL 1
	%elifidni %1, r14d
		%define Is_It_General_Register32_BOOL 1
	%elifidni %1, r15d
		%define Is_It_General_Register32_BOOL 1
	%else
		%define Is_It_General_Register32_BOOL 0
	%endif
%endmacro

%macro Is_It_General_Register16 1
	%IFIDNI %1, ax
		%define Is_It_General_Register16_BOOL 1
	%elifidni %1, bx
		%define Is_It_General_Register16_BOOL 1
	%elifidni %1, cx
		%define Is_It_General_Register16_BOOL 1
	%elifidni %1, dx
		%define Is_It_General_Register16_BOOL 1
	%elifidni %1, si
		%define Is_It_General_Register16_BOOL 1
	%elifidni %1, di
		%define Is_It_General_Register16_BOOL 1
	%elifidni %1, bp
		%define Is_It_General_Register16_BOOL 1
	%elifidni %1, sp
		%define Is_It_General_Register16_BOOL 1
	%elifidni %1, r8w
		%define Is_It_General_Register16_BOOL 1
	%elifidni %1, r9w
		%define Is_It_General_Register16_BOOL 1
	%elifidni %1, r10w
		%define Is_It_General_Register16_BOOL 1
	%elifidni %1, r11w
		%define Is_It_General_Register16_BOOL 1
	%elifidni %1, r12w
		%define Is_It_General_Register16_BOOL 1
	%elifidni %1, r13w
		%define Is_It_General_Register16_BOOL 1
	%elifidni %1, r14w
		%define Is_It_General_Register16_BOOL 1
	%elifidni %1, r15w
		%define Is_It_General_Register16_BOOL 1
	%else
		%define Is_It_General_Register16_BOOL 0
	%endif
	
%endmacro

%macro Is_It_General_Register8 1
	%IFIDNI %1, al
		%define Is_It_General_Register8_BOOL 1
	%elifidni %1, ah
		%define Is_It_General_Register8_BOOL 1
	%elifidni %1, bl
		%define Is_It_General_Register8_BOOL 1
	%elifidni %1, bh
		%define Is_It_General_Register8_BOOL 1
	%elifidni %1, cl
		%define Is_It_General_Register8_BOOL 1
	%elifidni %1, ch
		%define Is_It_General_Register8_BOOL 1
	%elifidni %1, dl
		%define Is_It_General_Register8_BOOL 1
	%elifidni %1, dh
		%define Is_It_General_Register8_BOOL 1
	%elifidni %1, sil
		%define Is_It_General_Register8_BOOL 1
	%elifidni %1, dil
		%define Is_It_General_Register8_BOOL 1
	%elifidni %1, bpl
		%define Is_It_General_Register8_BOOL 1
	%elifidni %1, spl
		%define Is_It_General_Register8_BOOL 1
	%elifidni %1, r8l
		%define Is_It_General_Register8_BOOL 1
	%elifidni %1, r9l
		%define Is_It_General_Register8_BOOL 1
	%elifidni %1, r10l
		%define Is_It_General_Register8_BOOL 1
	%elifidni %1, r11l
		%define Is_It_General_Register8_BOOL 1
	%elifidni %1, r12l
		%define Is_It_General_Register8_BOOL 1
	%elifidni %1, r13l
		%define Is_It_General_Register8_BOOL 1
	%elifidni %1, r14l
		%define Is_It_General_Register8_BOOL 1
	%elifidni %1, r15l
		%define Is_It_General_Register8_BOOL 1
	%else
		%define Is_It_General_Register8_BOOL 0
	%endif
%endmacro

%macro Is_It_General_Register 1
	Is_It_General_Register8 %1
	Is_It_General_Register16 %1
	Is_It_General_Register32 %1
	Is_It_General_Register64 %1

	%xdefine Is_It_General_Register (Is_It_General_Register8_BOOL || Is_It_General_Register16_BOOL || Is_It_General_Register32_BOOL || Is_It_General_Register64_BOOL)

	%undef Is_It_General_Register8_BOOL
	%undef Is_It_General_Register16_BOOL
	%undef Is_It_General_Register32_BOOL
	%undef Is_It_General_Register64_BOOL
%endmacro

%macro Is_It_MMX_Register 1
	%ifidni %1, mm0
		%define Is_It_MMX_Register_BOOL 1
	%elifidni %1, mm1
		%define Is_It_MMX_Register_BOOL 1
	%elifidni %1, mm2
		%define Is_It_MMX_Register_BOOL 1
	%elifidni %1, mm3
		%define Is_It_MMX_Register_BOOL 1
	%elifidni %1, mm4
		%define Is_It_MMX_Register_BOOL 1
	%elifidni %1, mm5
		%define Is_It_MMX_Register_BOOL 1
	%elifidni %1, mm6
		%define Is_It_MMX_Register_BOOL 1
	%elifidni %1, mm7
		%define Is_It_MMX_Register_BOOL 1
	%else
		%define Is_It_MMX_Register_BOOL 0
	%endif
%endmacro

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
%define HOW_Is_Far_Pointer_Stored_in_RAM Offset_IsFirst_In_LowerAddresses_Then_Segment
%define HOW_ToPush_FarPointer_ToRAM First_Push_Segment_Then_Offset

;%include "NASM_advanced_macroses32.nasm"


%endif

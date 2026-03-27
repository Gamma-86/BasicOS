%include "NASM_default_macroses.nasm"


%ifdef NASM_PREASSEMBLING_CHECK_SILENCER
%include "OS_return_codes.nasm"
%endif


CPU KATMAI

section .bss
align 4096
%define ARENA_BASE_SIZE 4096
Arena1_Start:
    resb ARENA_BASE_SIZE
Arena1_End:

Arena2_Start:
    resb ARENA_BASE_SIZE
Arena2_End:

Arena3_Start:
    resb ARENA_BASE_SIZE
Arena3_End:

Arena4_Start:
    resb ARENA_BASE_SIZE
Arena4_End:

section .data
align 64

Arena1_IsFree dd 1
Arena2IsFree dd 1
Arena3IsFree dd 1
Arena4IsFree dd 1

Arena1_BasePTR dd Arena1_Start
Arena1_SpaceLeft dd ARENA_BASE_SIZE

Arena2_BasePTR dd Arena2_Start
Arena2_SpaceLeft dd ARENA_BASE_SIZE

Arena3_BasePTR dd Arena3_Start
Arena3_SpaceLeft dd ARENA_BASE_SIZE

Arena4_BasePTR dd Arena4_Start
Arena4_SpaceLeft dd ARENA_BASE_SIZE

align 64
Arena1_IsBeeingAllocated dd 0
Arena2_IsBeeingAllocated dd 0
Arena3_IsBeeingAllocated dd 0
Arena4_IsBeeingAllocated dd 0

section .text

%macro MACRO_DEFAULT_INITIAL_MALLOC_ARENA__ArenaBP_ArenaXIsAllocated_ArenaSpaceLeft_ArenaIsFree 4
    ;enum GeneralOsErrorCodes (&PTR, size)
    ;1 : Check if we can afford to store this and if arguments are correct

    %define ArenaX_BasePointer %1
    %define ArenaX_IsAllocating %2
    %define ArenaX_SpaceLeft %3
    %define ArenaX_IsFree %4

    
    mov   edx, STACK_ARG2_SP
        mov   eax, LOW8_GeneralOSErrorSpace

    cmp   edx, ARENA_BASE_SIZE
        seta  cl
        movzx ecx, cl
        shl   ecx, HIGH_AllocationImpossibleBitIndex
        or    eax, ecx
    mov   cx, 65535

.test_arena:
        lock bts  dword[ArenaX_IsAllocating], 0
        jc    .arena_occupied
        nop
        jmp   .arena_free
.arena_occupied: ;wait until arena is free from allocation but only 65536 times and allocate anyways
        dec   cx
            jz    .watchdog_end
        pause
        jmp   .test_arena
            .watchdog_end:
            or    eax, HIGH_SpinlockWatchdogSetBit
.arena_free:
    mov   ecx, STACK_ARG1_SP
        TEST_REG_NULL_PTR   ecx
        setz  cl
        movzx ecx, cl
        shl   ecx, HIGH_NULLptrErrorBitIndex
        or    eax, ecx
    cmp   edx, [ArenaX_SpaceLeft]
        seta  cl
        movzx ecx, cl
        shl   ecx, HIGH_AllocationFailedBitIndex
        or    eax, ecx
    test   eax, HIGH_AllocationFailedBit | HIGH_AllocationImpossibleBit | HIGH_NULLptrErrorBit
        jnz   .critical_error

;ALLOCATING RAM
;   Decrease Available Space
;   Increase Base Pointer by size
;   Return Base Pointer

    ;mov   edx, STACK_ARG2_SP
    mov   ecx, STACK_ARG1_SP
    sub   [ArenaX_SpaceLeft], edx;      Decrease Available Space
    xadd  [ArenaX_BasePointer], edx ;     xchg edx, A1 / add edx, A1 ;Increase Base Pointer
    mov   [ecx], edx;     mov PTR to PTR* = BasePointer

    mov   word[ArenaX_IsFree], 0
    test  eax, ~(0xFF)
        setnz cl
        movzx ecx, cl
        shl   ecx, HIGH_TaskFulfilWithErrorBitIndex
        or    eax, ecx
.critical_error:
.absolute_end:
    mov   word[ArenaX_IsAllocating], 0
    ret

    %undef ArenaX_BasePointer 
    %undef ArenaX_IsAllocating 
    %undef ArenaX_SpaceLeft 
    %undef ArenaX_IsFree 

%endmacro


%macro MACRO_DEFAULT_INITIAL_FREE_ARENA__ArenaBP_ArenaXIsAllocated_ArenaSpaceLeft_ArenaIsFree_ArenaStart 5
    ;enum GeneralOsErrorCodes (void)
    ;%1 = Arena Base Pointer
    ;%2 = Arena Is allocating
    ;%3 = Arena Free space
    ;%4 = Arena Is not used at all
    ;%5 = ArenaX_start
    %define ARENA_BP %1
    %define ARENA_IS_ALLOCATED %2
    %define ARENA_LEFT %3
    %define ARENA_IS_NOT_USED %4
    %define ARENAX_start %5
    mov   eax, LOW8_GeneralOSErrorSpace
    mov   cx, 65535
    jmp   .test_arena

.wait_spinlock:;checking [Arena is beeing allocated]
    dec   cx
    jz    .watchdog_end
    pause
.test_arena:
    lock  bts   dword[ARENA_IS_ALLOCATED], 0
    jc    .wait_spinlock
    nop
    jmp   .allocating_ready
.watchdog_end:
    or    eax, HIGH_SpinlockWatchdogSetBit
.allocating_ready:
    ;MOV arena start to base pointer
    ;mov ARENA_SIZE to [Space Left]
    ;mov 1 to ArenaFree
    ;mov 0 to Arena is beeing allocated at the end
    mov   PTR_word[ARENA_BP], ARENAX_start
    mov   dword[ARENA_LEFT], ARENA_BASE_SIZE
    mov   dword[ARENA_IS_NOT_USED], 1
    mov   dword[ARENA_IS_ALLOCATED], 0

    test  eax, ~(0xFF)
        setnz cl
        movzx ecx, cl
        shl   ecx, HIGH_TaskFulfilWithErrorBitIndex
        or    eax, ecx
    ret
    %undef ARENA_BP
    %undef ARENA_IS_ALLOCATED
    %undef ARENA_LEFT
    %undef ARENA_IS_NOT_USED
    %undef ARENAX_start 
%endmacro

%macro MACRO_DEFAULT_INITIAL_CALLOC_ARENA__ArenaBP_ArenaXIsAllocated_ArenaSpaceLeft_ArenaIsFree 4

;enum GeneralOsErrorCodes (&PTR_to_area, Size)
    %define ArenaX_BP %1
    %define ArenaX_IsAllocated %2
    %define ArenaX_SpaceLeft %3
    %define ArenaX_IsFree %4
    ;Allocation:
    ;1 check null pointer, set appropriate bit
    ;2 check if it's bigger that area MAX size set bit aproprietly
    ;3 compare with free space left, set bit approprietly
    ;4 If some critical error bits were set, jump to error exit and free Arena
    ;       From allocation
    ;5 wait until Arena is free from other allocators
    ;       While also having watchdog and set the bit if watchdog was activated
    ;6 Book allocation youself
    ;7 Subtract SIZE from ArenaX_SpaceLeft
    ;8 Initialize RAM with zeroes with stosb SIZE times
    ;9 MAYBE I GUESS mov EDI to Arena Base Pointer as new Allocation start
    ;10 Get OLD ArenaX_BP it should be returned as pointer to allocated arena 
    ;11 Set Arena Is Free = FALSE
    ;12 UnBook Arena so others can allocate
    ;13 If Some HIGH Error bits were set, set Sign bit to say that Operation was still completed
    ; Return
    %define TEMP_RETURN_BITMAP_VALUE LOCAL_VAR(1)

    mov   edx, STACK_ARG2_BP
    mov   eax, LOW8_GeneralOSErrorSpace
    mov   ecx, STACK_ARG1_BP

    TEST_REG_NULL_PTR   ecx  ; 1 Checking Argument1 for NULL pointer
        setz  cl
        movzx ecx, cl
        shl   ecx, HIGH_NULLptrErrorBitIndex
        or    eax, ecx    ;1.1 Setting bit depending on the result
    cmp   edx, ARENA_BASE_SIZE ; 2 checking if It's bigger than MAX SIZE
        seta  cl
        movzx ecx, cl
        shl   ecx, HIGH_AllocationImpossibleBitIndex
        or    eax, ecx    ;2.1 Setting bit depending on result
    cmp   edx, [ArenaX_SpaceLeft] ;3 COmparing with free space left
        seta  cl
        movzx ecx, cl
        shl   ecx, HIGH_AllocationFailedBitIndex
        or    eax, ecx   ;3.1 Setting bit according to the result
    
    ;Testing some critical bits and jumping to the error exit if they are not zero
    test   eax, HIGH_NULLptrErrorBit | HIGH_AllocationFailedBit | HIGH_AllocationImpossibleBit
        jnz   .error_exit

    ;Notice that Enter happens after any possible jump after .error_exit

    MACRO_ENTER_NATIVE   16,0
    push  edi ;Saving EDI for future stosb

    xor   cx, cx
    not   cx
.allocation_test:
    lock bts dword[ArenaX_IsAllocated], 0
    jc    .allocation_spinlock_wait ;5 Wait until Arena is free from other allocators
    nop
    jmp   .allocation_wait_end
.allocation_spinlock_wait:;5.1 While also having watchdog
    dec   cx
    jz    .allocation_watchdog_set 
    pause
    jmp   .allocation_test
.allocation_watchdog_set:;5.1 and setting bit if watchdog ended
    or    eax, HIGH_SpinlockWatchdogSetBit
.allocation_wait_end:
    ;6 lock bts books allocation for us automatically

    mov   [TEMP_RETURN_BITMAP_VALUE], eax ;saving our return value temporarily



    ;7 Subtract SIZE from ArenaX_SpaceLeft
    ;Looking above, edx still has size (ARGUment2) preserved
    sub   dword[ArenaX_SpaceLeft], edx

    ;8 Initialize RAM with zeroes with stosb SIZE times
    pushf
    mov   edi, [ArenaX_BP]
    mov   ecx, STACK_ARG2_BP
    xor   al,al
    cld
    rep   stosb
    popf

    ;
    ;9 MAYBE I GUESS mov EDI to Arena Base Pointer as new Allocation start
    ;10 Get OLD ArenaX_BP it should be returned as pointer to allocated arena 
    xchg  edi, [ArenaX_BP] ;Mov EDI to ArenaX_BP As New start / Get Old ArenaX_BP
    mov   ecx, STACK_ARG1_BP
    mov   [ecx], edi ;Return as a pointer

    ;11 Set Arena Is Free = FALSE
    mov   dword[ArenaX_IsFree], FALSE
    ;12 UnBook Arena so others can allocate
    mov   byte[ArenaX_IsAllocated], FALSE
    ;13 If Some HIGH Error bits were set, set Sign bit to say that Operation was still completed
    mov   eax, [TEMP_RETURN_BITMAP_VALUE]
    test  eax, (~0xFF)
        setnz cl
        movzx ecx, cl
        shl   ecx, HIGH_TaskFulfilWithErrorBitIndex
        or    eax, ecx

.normal_return:

    pop   edi
    leave
    ret

.error_exit:
    ret
    %undef TEMP_RETURN_BITMAP_VALUE

    %undef ArenaX_BP
    %undef ArenaX_IsAllocated
    %undef ArenaXSpaceLeft
    %undef ArenaXIsFree
%endmacro

global globASM_Initial_calloc_arena1
global globASM_Initial_malloc_arena1
global globASM_Initial_reset_arena1
global globASM_Initial_IsArena1Free





globASM_Initial_malloc_arena1: ;enum GeneralOsErrorCodes (&PTR, size)
MACRO_DEFAULT_INITIAL_MALLOC_ARENA__ArenaBP_ArenaXIsAllocated_ArenaSpaceLeft_ArenaIsFree    Arena1_BasePTR, Arena1_IsBeeingAllocated, Arena1_SpaceLeft, Arena1_IsFree
globASM_Initial_reset_arena1:  ;void ()
MACRO_DEFAULT_INITIAL_FREE_ARENA__ArenaBP_ArenaXIsAllocated_ArenaSpaceLeft_ArenaIsFree_ArenaStart   Arena1_BasePTR, Arena1_IsBeeingAllocated, Arena1_SpaceLeft, Arena1_IsFree, Arena1_Start
globASM_Initial_calloc_arena1: ;enum GeneralOsErrorCodes (&PTR, size)
MACRO_DEFAULT_INITIAL_CALLOC_ARENA__ArenaBP_ArenaXIsAllocated_ArenaSpaceLeft_ArenaIsFree    Arena1_BasePTR, Arena1_IsBeeingAllocated, Arena1_SpaceLeft, Arena1_IsFree
globASM_Initial_IsArena1Free: ;char ()
    movzx eax, byte[Arena1_IsFree]
    ret







;############3333333333###############
;BITFIELD MEMORY ALLOCATOR
;######################################
section .data
%assign HEAP_BITFIELD_SIZE 256 
%assign ALLOCATION_BLOCK_SIZE 16
%assign HEAP_SIZE    HEAP_BITFIELD_SIZE * 8 * ALLOCATION_BLOCK_SIZE


struc Heap_info_struct
    .blocks_left resb 2
    .bytes_left resb 2
endstruc

struc Heap_AllocatedBLockMeatadata_struct
    .Size_in_blocks resb 4
endstruc

Heap_info:
istruc Heap_info_struct
    at .blocks_left, dw HEAP_BITFIELD_SIZE
    at .bytes_left, dw HEAP_BITFIELD_SIZE*ALLOCATION_BLOCK_SIZE    
iend



Heap_Bitfield times HEAP_BITFIELD_SIZE db 0
Heap_itself times HEAP_BITFIELD_SIZE * ALLOCATION_BLOCK_SIZE * 8 db 0
Heap_metadata_array times HEAP_BITFIELD_SIZE * Heap_AllocatedBLockMeatadata_struct_size db 0

section .text


globASM_InitialHeap_malloc:

    ret
globASM_InitialHeap_calloc:

    ret
globASM_InitialHeap_free:

    ret
globASM_InitialHeap_getBlocksLeft:
    movzx eax, word[Heap_info + Heap_info_struct.blocks_left]
    ret

globASM_InitialHeap_getBlocksSize:
    mov   eax, ALLOCATION_BLOCK_SIZE
    ret



;LOCAL FUNCTIONS

ScanForFreeBlock:;void (void* POinter to where to start from)
;Scan for the non -1 value starting from the pointer and return PTR to non -1
;But only do it 256 times, if could not find return 0
;
    MACRO_ENTER_NATIVE 0, 0
    push  edi
    push  ecx
    push  edx
    pushf

    cld
    MOV_REG_IMM eax, -1
    MOV_LITL_OPTIMIZED edi, STACK_ARG1_BP
    mov   ecx, 64

    repe  scasd
    jecxz .could_not_find
    mov   eax, edi

.could_not_find:
    xor   eax, eax
.absolute_end:
    popf
    pop   edx
    pop   ecx
    pop   edi
    leave
    ret



ZeroBitScanForward_InterByte:

    ret
SetBitScanForward_InterByte:

    ret
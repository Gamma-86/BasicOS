bits 32
CPU WILLAMETTE

%include "NASM_default_macroses.nasm"
%include "IA32Macroses.nasm"
%include "multiboot_structures.nasm"
%include "./PortDebugOutput/PortDebugOutput_NASMmacro.nasm"
%include "Pos_Indep_Code.nasm"
%include "./panic/multiboot_panic.nasm"
struc HeaderTagGeneral
    .type resb 2
    .flags resb 2
    .size resb 4
endstruc


%IF 0
This is the FIRST thing that get executed ever in this OS
Our goal is to parse MB2(multiboot 2 specification) info and usually get it
to the determined location
    For that reason, there are a lot of functions, but we also have some very
low level debug printint functions because we might not have text console set
for example LPT port character sending and maybe RS232 thing in the future
    Also there is structure that give multiboot loader requests of info and
gives it information that we should be loaded with MB2 specificatin
    By default it sets 80x25 text mode

DO NOT USE STACK ALLOCATIONS USE LIKE C STATIC LOCAL VARIABLES
MMX IS USED BY A LOT OF FUNCTIONS, SO DO NOT USE X87

1 - CPU declaration, includes
20 - All The info we give bootloader
30 -  Macros for Initial 80x25 console print
40 - Stack reserved bytes
50 - The _start, first ever code to get executed
60 - Initialize_SSE_FPU
61 - 
70 - PrintStringInitial (to 80x25 text console)
71 - PrintInt32HEXIntial (to 80x25 console)
80 - Sort_multiboot_struct -- OLD FUNCTION DO NOT USE
90 - Initial_Sort_multiboot_struct2 and all its data
%endif

;#############################################################################
;20
;20
;20
;#############################################################################
%define Tagtype_PageAlign 7
%define Tagtype_VideoMode 5
    %define VMODEwidth 1024
    %define VMODEheight 768
    %define VMODEdepth 32

%define MB2_MAGIC 0xE85250D6
%define MB2_ARCH 0
%define MB2_LENGTH header_end-header_start
%define MB2_CHECKSUM -(MB2_MAGIC + MB2_ARCH + MB2_LENGTH)

section .multiboot
header_start:
    dd MB2_MAGIC
    dd MB2_ARCH
    dd MB2_LENGTH
    dd MB2_CHECKSUM

%if 0
align 8
    istruc HeaderTagGeneral
        at .type, dw Tagtype_VideoMode
        at .flags,dw 0
        at .size, dd 20
    iend
    dd   VMODEwidth
    dd   VMODEheight
    dd   VMODEdepth
%endif

align 8
    dw 0
    dw 0
    dd 8

header_end:



;#############################################################################
;30
;30
;30
;#############################################################################
%macro PRINT_STR_WITH_INITIALPTRINT 1
%push Intial_STR_Print
section .data
    %$STRING: db %1
    db 0
section .text
    push   %$STRING
    call   PrintStringInitial
    add    esp, 4
%pop 
%endmacro

;#############################################################################
;40
;40
;40
;#############################################################################
section .bss
    %define INITIAL_STACK_SIZE 65536+4096
    stack_end:
    resb  INITIAL_STACK_SIZE
    stack_top:
section .data
    Initial_stack_size_VAR dd INITIAL_STACK_SIZE

;#############################################################################
;50
;50
;50
;#############################################################################

MultibootInfoPTR dd 0
MB2_WholeTagStruct_TotalSize dd 0
section .text
extern   kernel_main ;(unsigned int EAX_magic, void* EBX_structure)
global _start
_start:
    CLI
    mov   byte[0xb8000], 'A'
    mov   byte[0xb8001], 0x1F
    mov   esp, stack_top
        cmp   eax, 0x36D76289 ;Check them magic tag given by multiboot
        jne   .not_multiboot

        test  ebx, 0x7 ;check if the address is aligned(it should always be aligned)
        jnz   .not_aligned
    mov   [MultibootInfoPTR], ebx
    mov   eax, [ebx + MB2Info_MainHead.Total_size]
        mov   [MB2_WholeTagStruct_TotalSize], eax

    mov   eax, cr0
        btr   eax, 1
        btr   eax, 2
        btr   eax, 3
    mov   cr0, eax
    call  Sort_multiboot_struct ;Sort things that multiboot given in EBX*
    emms
    fninit

    cli
    hlt
    jmp $

.not_multiboot:
    I_AM_MULTIBOOT_IDK_WAHTTODO_PANIC MB2panic_EnumCodes.Unsupported_Loader
.not_aligned:
    I_AM_MULTIBOOT_IDK_WAHTTODO_PANIC MB2panic_EnumCodes.Multiboot_UnalignedPTR
;#############################################################################
;60
;60
;60
;#############################################################################

Initialize_SSE_FPU:
    mov   eax, cr0
        btr   eax, cr0_indexes.MP_FPU_monitored
        btr   eax, cr0_indexes.EM_FPU_emulated
        btr   eax, cr0_indexes.TS_Task_Was_Switched
    mov   cr0, eax

    mov   eax, cr4
        bts   eax, cr4_indexes.OSFXSR_SaveSSE_When_fxsave
        bts   eax, cr4_indexes.OSXMMEXCPT_Enble_SSE_XF_INT
    mov   cr4, eax
    ret
;#############################################################################
;61
;61
;61
;#############################################################################



;#############################################################################
;70
;70
;70
;#############################################################################
section .data
    Curnt_Y_cord db 0
section .text

global PrintStringInitial
PrintStringInitial:; void (string ptr)
    MACRO_ENTER_NATIVE 0, 0
    push  esi
    push  edi

    mov   esi, [ebp + 8]
        movzx ecx, byte[Curnt_Y_cord]
        inc   byte[Curnt_Y_cord]

    ;*80 = *5*16
    lea   ecx, [ecx + ecx*4];*5
        shl   ecx, 4 ;*16
        lea   edi, [ecx + 0xb8000]
    cld
    mov   ah, 0xF
.lp1:
    lodsb
    test   al, al
    jz    .lp1_end
    stosw
    jmp   .lp1
.lp1_end:

    pop   edi
    pop   esi
    leave
    ret

;#############################################################################
;71
;71
;71
;#############################################################################
section .data
    HEX_CharactersTable db '0123456789ABCDEF'
    Int32_Nibble_Bitmasks
    dq 0xF
    dq 0xF0
    dq 0xF00
    dq 0xF000
    dq 0xF_0000
    dq 0xF0_0000
    dq 0xF00_0000
    dq 0xF000_0000
section .text
PrintInt32HEXIntial:;void (int32)
    %push context
    MACRO_ENTER_NATIVE 0, 0
    push  ebx
    push  edi

    pxor  mm0, mm0
    movd  mm0, STACK_ARG1_BP32
        movq  mm1, mm0
        movq  mm2, mm0
        movq  mm3, mm0
        movq  mm4, mm0
        movq  mm5, mm0
        movq  mm6, mm0
        movq  mm7, mm0
    pand   mm0, [Int32_Nibble_Bitmasks+0]
    %assign i 0
    %rep 7
        %assign i i+1
        pand mm%+i, [Int32_Nibble_Bitmasks+i*8]
            psrld mm%+i, 4*i
    %endrep
    
    movzx edi, byte[Curnt_Y_cord]
        lea   edi, [edi + edi*4]
        shl   edi, 4
        add   edi, 0xb8000
        inc   byte[Curnt_Y_cord]
    mov   ebx, HEX_CharactersTable
    cld
    %assign i 7
    %rep 7
        movd   eax, mm%+i
        xlatb
        mov   ah, 0xF
        stosw
        %assign i i-1
    %endrep

    pop   edi
    pop   ebx
    leave
    ret
    %pop
;#############################################################################
;80
;80
;80
;#############################################################################
struc RAMMapInfo_DLinkedList_entry
    .next resb 4
    .prev resb 4
    .Address4Low resb 4
    .Address4High resb 4
    .Length4Low resb 4
    .Length4High resb 4
    .Type resb 4
endstruc

Sort_multiboot_struct: ;void (ebx=*multiboot structure) Sort them to different arrays
    %push Sorting

    %define multi_struct ebp-4
    %define multi_struct_fullSize ebp-8
    %define CurrentTagPointerReg ebx ;already have pointer to struct
    %define MaxIteration ebp-12
    %define ReturnAddress ebp-16
    %define EBX_save      mm5
    %define ESI_save      mm6
    %define EDI_save      mm7
    mov   eax, [esp]
    emms

    enter 48,0
        movd   EBX_save, ebx
        movd   ESI_save, esi
        movd   EDI_save, edi

    mov   [ReturnAddress], eax
    mov   eax, [ebx + MB2Info_MainHead.Total_size]
        mov   [multi_struct_fullSize], eax
    mov   [multi_struct], ebx
    add   CurrentTagPointerReg, MB2Info_MainHead_size;Exited Main head
    ;      Entered multiboot tags

    ;while tag type !=0 analyze it
    ;but try repeating it only 8192 times

    FOR_LOOP_START word[MaxIteration], 8192, 0
        ;what to do here:
        ;1-Look at the current multiboot tag and check its type
        ; 1.1 If Tag is 0, it means end, end the loop
        ;2-If it's type is Multiboot Memory map(not sure about UEFI)
        ;2.1-CHeck if it fits in stack and leaves like 4kb of space
        ;  2.1.1 Set flag that not enough memory
        ;  2.1.2 still create not full linked list
        ;2.2 Create linked list out of map descriptors by allocating on stack
        ;3 If it is not the memory type, give it C parser
        ;4 If loop ended, do something IDK

        ;1
        mov   eax, [CurrentTagPointerReg + MB2Info_TagHead.Type]
            test  eax, eax
            FOR_LOOP_BREAK_COND_JMP z
        cmp   eax, MB2Info_RAMmap_type
            sete  dl

        IF_BOOL_START dl
            %define First_list_entry_PTR ebp-20
            %define MB2_AddressEntriesEnd ebp-24
            %define Previous_List_entry_PTR ebp -28
            %define One_MB2RAMMapEntry_size ebp -32
            mov   eax, [CurrentTagPointerReg + MB2Info_RAMMap.One_Entry_size]
            mov   [One_MB2RAMMapEntry_size], eax
            ;2 IF dl=1 This is RAM MAP thing
            ;2.1
            mov   eax, [CurrentTagPointerReg + MB2Info_RAMMap.Size]
            cmp   eax, INITIAL_STACK_SIZE-4096-256
                setae al ;if eax is above or equal the max size, set al
                mov   [MB2Error_Not_Enough_Stack_for_RamMap], al
            ;Since we have to still make list partially or not,
            ;And I dont know how many additional size will add when making
            ;list, We have constantly check for stack space left

            ;How to add List thing to stack:
            ;get current esp as the base pointer
            ; First, subtract 4 from esp, cause esp can point to something
            ;Allocate some space on stack with subtract
            ;Let's initialize with first entry
            sub   esp, RAMMapInfo_DLinkedList_entry_size
            mov   [First_list_entry_PTR], esp    ;Here is our first entry
            mov   [RAMMap_Description_LinkedList_FirstPTR], esp
            mov   edi, esp ;just a temporary register to initialize list
                mov   dword[edi + RAMMapInfo_DLinkedList_entry.next], 0
                mov   dword[edi + RAMMapInfo_DLinkedList_entry.prev], 0
                mov   dword[Previous_List_entry_PTR], 0
                pxor  mm0, mm0
                movq  [edi + RAMMapInfo_DLinkedList_entry.Address4Low], mm0
                movq  [edi + RAMMapInfo_DLinkedList_entry.Length4Low], mm0
                movq  [edi + RAMMapInfo_DLinkedList_entry.LastAddress4Low], mm0
                ;We initialized it
            ;Now let's calculate where our MB2 entries start and end
            mov   edx, [CurrentTagPointerReg + MB2Info_RAMMap.Size]
                add   edx, CurrentTagPointerReg ;Tagsize + TagPTR = TagEnd  
                mov   [MB2_AddressEntriesEnd], edx 
            %define LinkedList_entryRegPTR edi
            %define MB2Info_RAMentryRegPTR esi
            lea   eax, [CurrentTagPointerReg + MB2Info_RAMMap.Entries_start]
            mov   MB2Info_RAMentryRegPTR, eax
            mov   LinkedList_entryRegPTR, [First_list_entry_PTR] ;The list entry expected to be already allocated
            .Analyzing_MB2_Address_entries_start:
                ;Plan:
                ;Used Variables: MB2_AddressEntriesEnd, MB2Info_RAMentryRegPTR
                ;  LinkedList_entryRegPTR, Previous_List_entry_PTR,
                ;
                ;  get everything from MB2 info entry to CPU
                ;  allocate linked list entry
                ;  move everything needed to list from CPU
                ;  Update all variables: 
                ;  

                ;Space for first linked list is expected to be allcoated
                ;LinkedList entry Reg PTR, MB2Entry reg pointer 
                ;   Are expected to be here

                ;1 If we reach the end, stop
                ;2 Copy MB2 RAM entries to our linked list

                ;1
                cmp   MB2Info_RAMentryRegPTR, [MB2_AddressEntriesEnd]
                    jae   .Analyzing_MB2_Address_entries_end
                ;2
                movq  mm0, [MB2Info_RAMentryRegPTR + MB2_RAMMap_entry.Address4Low]
                movq  mm1, [MB2Info_RAMentryRegPTR + MB2_RAMMap_entry.Length4Low]
                    movq mm3, mm0
                    paddq mm3, mm1 ;ALso we need to sub 1
                    pcmpeqb mm4, mm4 ;-1
                    paddq mm3, mm4   ;mm3 + (-1)
                movd  mm2, [MB2Info_RAMentryRegPTR + MB2_RAMMap_entry.Type]

                ;2 part 2, initializing linked list
                movq [LinkedList_entryRegPTR + RAMMapInfo_DLinkedList_entry.Address4Low], mm0
                movq [LinkedList_entryRegPTR + RAMMapInfo_DLinkedList_entry.Length4Low],  mm1
                movq [LinkedList_entryRegPTR + RAMMapInfo_DLinkedList_entry.LastAddress4Low], mm3
                movd [LinkedList_entryRegPTR + RAMMapInfo_DLinkedList_entry.Type], mm2
                ;Next things to do:
                ; 1 Initialize prev PTR in list with PREV entry PTR
                ; 2 Allocate place for new entry (NEXT entry) and save NEXT in list
                ; 3 Also we need to update local NEXT/PREV entry pointers
                ;    for next list entry,update DLinkedlistReg, MB2EntryReg

                ;1
                mov   eax, [Previous_List_entry_PTR]
                mov   [LinkedList_entryRegPTR + RAMMapInfo_DLinkedList_entry.prev], eax
                ;2
                sub   esp, RAMMapInfo_DLinkedList_entry_size
                    mov   edx, esp
                    mov   [LinkedList_entryRegPTR + RAMMapInfo_DLinkedList_entry.next], edx
                ;3
                mov   [Previous_List_entry_PTR], LinkedList_entryRegPTR
                mov   LinkedList_entryRegPTR, edx 
                ;Current List entry = next 

                add   MB2Info_RAMentryRegPTR, [One_MB2RAMMapEntry_size]

                jmp   .Analyzing_MB2_Address_entries_start
            .Analyzing_MB2_Address_entries_end: 
            ;After the end, the last entry is bad
            ;and previous one has next NEXT pointer not nulled.
            add   esp, RAMMapInfo_DLinkedList_entry_size
            mov   dword[esp + RAMMapInfo_DLinkedList_entry.next], 0

            ;after that, we have to go to the next tag:
            mov   CurrentTagPointerReg, [MB2_AddressEntriesEnd]
            ALIGNREG_ROOF8 CurrentTagPointerReg
        ELSE
            push  CurrentTagPointerReg
            call  Multiboot2_info_main_parser
            add   esp, 4
            add   CurrentTagPointerReg, eax
            ALIGNREG_ROOF8 CurrentTagPointerReg
        IF_BOOL_END
    FOR_LOOP_END

    test word[MaxIteration], 0xFFFF
        setz  al
        mov   [MB2Error_MaxIteration_Passed], al

    movd  edi, EDI_save
    movd  esi, ESI_save
    movd  ebx, EBX_save

    ;now we need to save the allocated stack space
    sub   esp, 16
    and   esp, ~(0xF)
    sub   esp, 4
        mov   eax, [ReturnAddress]
        mov   [esp], eax
    mov   ebp, [ebp]
    ret
%undef MaxIteration
%undef CurrentTagPointerReg
%undef multi_struct
%undef multi_struct_fullSize
%undef EBX_save
%undef ESI_save
%undef EDI_save
%pop







;#############################################################################
;90
;90
;90
;#############################################################################

extern Multiboot2_info_main_sorter


%macro MB2_SORT_STACK_MALLOC 1
    mov   esp, %1
    sub   esp, eax
    and   esp, ~0xF
    mov   eax, esp
%endmacro

section .data
    Local_Sort_Multiboot_struct2_MB2structPTR dd 0
    Local_Sort_Multiboot_struct2_ReturnAddress dd 0


global MB2Info_absolute_start_PTR
global MB2Info_absolute_total_size
global MB2Error_Not_Enough_Stack
global MB2Error_MaxIteration_Passed
global MB2Info_absolute_LastByte_PTR
    MB2Info_absolute_start_PTR dd 0
    MB2Info_absolute_total_size dd 0
    
    MB2Error_Not_Enough_Stack db 0
    MB2Error_MaxIteration_Passed db 0

    
    MB2Info_absolute_LastByte_PTR dd 0

section .text
%macro Initial_Sort_multiboot_struct2_Get_MB2RAMEntries_Amount__RAMmapTagReg 1
;Goal - find amount of MB2 ram entries %1 - pointer reg to RAMmap Tag
;Of cource return in eax, can use eax,edx,ecx ; preserve ebx,edi,esi,ebp
    push  %1
    pop   ecx
    mov   eax, ecx
    mov   edx, ecx
;plan - get difference between RAM entries start end tag end
;       then divide
;ecx - start, eax - end, then ecx-divisor
    add   eax, [eax + MB2Info_RAMMap.Size]
    add   ecx, MB2Info_RAMmap.Entries_start
    sub   eax, ecx

    mov   ecx, [edx + MB2Info_RAMMap.One_Entry_size]
        xor   edx, edx
        div   ecx
%endmacro
%macro Initial_Sort_multiboot_struct2_Get_UEFIRAMEntries_Amount__RAMmapTagReg 1

%endmacro
Initial_Sort_multiboot_struct2:;void (ebx=*multiboot structure) Sort them to different arrays
    %define EBX_SAVE mm7
    %define ESI_SAVE mm6
    %define EDI_SAVE mm5
    %define EDX_SAVE mm4
    %define ECX_SAVE mm3
    %define EAX_SAVE mm2

    %define MB2struct_pointer_register ebx
    movd  EBX_SAVE, ebx
    movd  EDI_SAVE, edi
    movd  ESI_SAVE, esi
    ;first, initialize local variables and set global ones
    ;These are: 
    ;  MB2Info_Size - now
    ;  MB2Error_Not enough stack - now
    ;  MB2 absolute end PTR - now
    mov   [Local_Sort_Multiboot_struct2_MB2structPTR], MB2struct_pointer_register
    
    ;MB2Info_size, Error not enough stack
    mov   eax, [MB2struct_pointer_register + MB2Info_MainHead.Total_size]
        mov   [MB2Info_absolute_total_size], eax
    cmp   eax, INITIAL_STACK_SIZE
        setae al
        mov   [MB2Error_Not_Enough_Stack], al

    mov   eax, [esp]
        mov   [Local_Sort_Multiboot_struct2_ReturnAddress], eax
    ;MB2 absolute end PTR
    mov   eax, MB2struct_pointer_register
        add   eax, [MB2struct_pointer_register + MB2Info_MainHead.Total_size]
        mov   [MB2Info_absolute_LastByte_PTR], eax

    ;secondly, allocate stack; copy All mb2 tags and head
    ;set MB2Info absolute pointer
    ;1 - Allocate space on stack(the size give in MB2 boot info)
    ;   1.1 - set this memory as global MB2BootInfo pointer
    ;2 - copy MB2 boot info to stack
    ;3 MAJOR - find the MB2 Boot info or UEFI RAM map
    ;   3.1 find how many descriptors are there, get the size of this structure
    ;   3.2 Allocate the Size of Amount of descriptors * Size of OS RAM descriptors space on stack
    ;             Add another 512 bytes just in case
    ;   Overall - Allocate size on stack, return: Entries amount 
    ;4 - move stack pointer and return address
    ;5 - call main MB2 boot info sorter( it needs FirstTag pointer, Space for OS RAM descriptors, MB2 RAMmap entries amount)
    ;return

    ;1
    MB2_SORT_STACK_MALLOC dword[MB2Info_absolute_total_size]
    ;1.1
        mov   [MB2Info_absolute_start_PTR], eax
    ;2
    mov   edi, eax
    mov   esi, MB2struct_pointer_register
    mov   ecx, MB2Info_absolute_total_size
        shr   ecx, 2
    cld
    rep movsd
    
    mov   ecx, MB2Info_absolute_total_size
        and   ecx, 3
    rep   movsb

    ;3
    mov   edx, MB2struct_pointer_register
        add   edx, MB2Info_MainHead_size
    xor   ecx, ecx
        not   cl
.loop_find_MB2_RAMMap_start:
    cmp   dword[edx + MB2Info_TagHead.Type], MB2Info_RAMmap_type
        sete  al
    cmp   dword[edx + MB2Info_TagHead.Type], MB2Info_UEFI_RAM_MAP_type
        sete  ah
        or    al, ah
        jnz   .loop_find_MB2_RAMMap_end

    add   edx, [edx + MB2Info_TagHead.Size]
    ALIGN8_REG_ROOF edx

    loop  .loop_find_MB2_RAMMap_start    
.loop_find_MB2_RAMMap_end:
    test   ecx, ecx
        setz  cl
    ;3.1
    movd  EDX_SAVE, edx
    movd  ECX_SAVE, ecx
        Initial_Sort_multiboot_struct2_Get_MB2RAMEntries_Amount__RAMmapTagReg edx
    movd  ECX_SAVE, ecx
    movd  EDX_SAVE, edx


    mov   MB2struct_pointer_register, MB2Info_absolute_start_PTR
    ;4
    sub   esp, 0xF
        and   esp, 0xF        
    mov   eax, Local_Sort_Multiboot_struct2_ReturnAddress
    mov   [esp], eax



    ;5 void Multiboot2_info_main_sorter(struct MB2Info_TagHead* Boot Info Tags PTR)
    mov   eax, MB2struct_pointer_register
        add   eax, MB2Info_MainHead_size
        push  eax
    call Multiboot2_info_main_sorter
        add   esp, 4

    movd  esi, ESI_SAVE
    movd  edi, EDI_SAVE
    movd  ebx, EBX_SAVE
    ret
    %undef EDX_SAVE
    %undef ECX_SAVE
    %undef EAX_SAVE
    %undef EBX_SAVE
    %undef ESI_SAVE
    %undef EDI_SAVE
    %undef MB2struct_pointer_register












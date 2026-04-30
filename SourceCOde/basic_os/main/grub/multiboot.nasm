%include "NASM_default_macroses.nasm"
%include "IA32Macroses.nasm"
%include "multiboot_structures.nasm"

bits 32
CPU WILLAMETTE

struc HeaderTagGeneral
    .type resb 2
    .flags resb 2
    .size resb 4
endstruc

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




section .data







section .bss
    %define INITIAL_STACK_SIZE 65536+4096
    stack_end:
    resb  INITIAL_STACK_SIZE
    stack_top:
section .data
    Initial_stack_size_VAR dd INITIAL_STACK_SIZE


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

    call  Sort_multiboot_struct ;Sort things that multiboot given in EBX*



.not_multiboot:
    mov   eax, 'E' | (0xF<<8) | ('1'<<16) | (0xF<<24)
    mov   [0xb8000], eax

    cli
    hlt
    jmp $
.not_aligned:
    mov   eax, 'E' | (0xF<<8) | ('2'<<16) | (0xF<<24)
    mov   [0xb8000], eax

    cli
    hlt
    jmp $



section .text
Get_next_eip:
    mov   eax, [esp]
    ret




extern Multiboot2_info_main_parser
struc RAMMapInfo_DLinkedList_entry
    .next resb 4
    .prev resb 4
    .Address4Low resb 4
    .Address4High resb 4
    .Length4Low resb 4
    .Length4High resb 4
    .EndAddress4Low resb 4
    .EndAddress4High resb 4
    .Type resb 4
endstruc 
%macro Roof_to_align8__reg_FreeReg  2
    mov   %2, %1
    and   %2, 0x7
    ;to align first 3 bit to 8, we should
    ;   sub 3 bits from 8
    ;   and add  result to 3 bit
    ;   (8 - 3bit) + 3bit
    sub  %2, 8 ; 3 bit - 8
    neg  %2    ; 8 - 3bit
    add  %1, %2; Aligned
%endmacro
section .data
    MB2Error_Not_Enough_Stack_for_RamMap db 0
    MB2Error_MaxIteration_Passed db 0
    RAMMap_Description_LinkedList_FirstPTR dd 0
section .text
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
            ;FOR_LOOP_BREAK_COND_JMP z
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
            mov   edi, esp
                mov   dword[edi + RAMMapInfo_DLinkedList_entry.next], 0
                mov   dword[edi + RAMMapInfo_DLinkedList_entry.prev], 0
                mov   dword[Previous_List_entry_PTR], 0
                pxor  mm0, mm0
                movq  [edi + RAMMapInfo_DLinkedList_entry.Address4Low], mm0
                movq  [edi + RAMMapInfo_DLinkedList_entry.Length4Low], mm0
                movq  [edi + RAMMapInfo_DLinkedList_entry.EndAddress4Low], mm0
                ;HEre we initialized it
            ;Now let's calculate where our MB2 entries start and end
            lea   eax, [CurrentTagPointerReg + MB2Info_RAMMap.Entries_start]
            mov   edx, [CurrentTagPointerReg + MB2Info_RAMMap.Size]
                add   edx, CurrentTagPointerReg

            %define LinkedList_entryRegPTR esi
            %define MB2Info_RAMentryRegPTR edi
            mov   MB2Info_RAMentryRegPTR, eax
            mov   [MB2_AddressEntriesEnd], edx
            mov   LinkedList_entryRegPTR, [First_list_entry_PTR] ;The list entry expected to be already allocated
            .Analyzing_MB2_Address_entries_start:
                ;Plan:
                ;Used Bariables: MB2_AddressEntriesEnd, MB2Info_RAMentryRegPTR
                ;  LinkedList_entryRegPTR, Previous_List_entry_PTR,
                ;
                ;  get everything from MB2 info entry to CPU
                ;  allocate linked list entry
                ;  move everything needed to list from CPU
                ;  Update all variables: 
                ;  

                ;Space for linked list is expected to be allcoated
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
                    paddq mm3, mm1
                movd  mm2, [MB2Info_RAMentryRegPTR + MB2_RAMMap_entry.Type]

                ;2 part 2, initializing linked list
                movq [LinkedList_entryRegPTR + RAMMapInfo_DLinkedList_entry.Address4Low], mm0
                movq [LinkedList_entryRegPTR + RAMMapInfo_DLinkedList_entry.Length4Low],  mm1
                movq [LinkedList_entryRegPTR + RAMMapInfo_DLinkedList_entry.EndAddress4Low], mm3
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

                add   MB2Info_RAMentryRegPTR, [One_MB2RAMMapEntry_size]

                jmp   .Analyzing_MB2_Address_entries_start
            .Analyzing_MB2_Address_entries_end:
                ;after that, we have to go to the next tag:
                add   CurrentTagPointerReg, [CurrentTagPointerReg + MB2Info_RAMMap.Size]
        ELSE
            push  CurrentTagPointerReg
            call  Multiboot2_info_main_parser
            add   esp, 4
        IF_BOOL_END
    FOR_LOOP_END
.For_immediate_end:
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

%pop
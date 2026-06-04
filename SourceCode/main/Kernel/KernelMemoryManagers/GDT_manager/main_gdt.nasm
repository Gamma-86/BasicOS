CPU WILLAMETTE
bits 32
%include "NASM_default_macroses.nasm"
%include "NASM_advanced_macroses32.nasm"
%include "IA32Macros.nasm"
%include "OS_return_codes.nasm"
%include "Pos_Indep_Code.nasm"
section .data
global MainGDT_start
global MainGDT_end
global MainGDT_Descriptor

Align 8
MainGDT_start:
    ;1
dq 0
.code32Flat: ;2
DEFINE_GDT_FLATCODE386
.data32Flat: ;3
DEFINE_GDT_FLATDATA386
Initial_GDT_end:
times 8192-(($-MainGDT_start)/8) dq 0 ;| BIT_MASK(DataSegment_Descriptor_Bits.Available)

MainGDT_end:
Align 8
times 6 db 0
MainGDT_Descriptor:
    dw   Initial_GDT_end-MainGDT_start-1
    dd   MainGDT_start



global GDT_Stack_Pointer
global globASM_FUN_GDT_pushDescriptor
GDT_Stack_Pointer dw Initial_GDT_end - MainGDT_start - 8
globASM_FUN_GDT_pushDescriptor: ;offset (long long Descriptor)
    %push Saved_Context
    MACRO_ENTER_NATIVE 0, 0
    %define  DESCRIPTOR_LOW STACK_ARG1_BP
    %define  DESCRIPTOR_HIGH STACK_ARG2_BP
    %define  GDT_Descriptor_PTR LOCAL_VAR(1)
    %define  GDT_PTR LOCAL_VAR(2)
    %define  GDT_Stack_Pointer_PTR LOCAL_VAR(3)    
    GET_LABEL_FLAT_ADDRESS_POS_INDEP  MainGDT_Descriptor
    mov   [GDT_Descriptor_PTR], AX_PTRSIZE
    GET_LABEL_FLAT_ADDRESS_POS_INDEP  MainGDT_start
    mov   [GDT_PTR], AX_PTRSIZE
    GET_LABEL_FLAT_ADDRESS_POS_INDEP  GDT_Stack_Pointer
    mov   [GDT_Stack_Pointer_PTR], AX_PTRSIZE
;plan:
;    push works like that: add to SP write on sp
;    1 add Descriptor size to SP and update it
;    2 generate address of descriptor in GDT
;    3 copy argument descriptor to the stack pointer
;    4 update and conditionaly load GDT descriptor(depends if limit is below)

;1  right now eax = Stack_PTR_PTR
    add   word[AX_PTRSIZE], SegmentDescriptorSize
;2   DX = pointer to copy
    mov   DX_PTRSIZE, [AX_PTRSIZE]
    add   DX_PTRSIZE, [GDT_PTR]
;3
        mov   eax, DESCRIPTOR_LOW
        mov   ecx, DESCRIPTOR_HIGH
        mov   [DX_PTRSIZE], eax
        mov   [DX_PTRSIZE+4],ecx
;4
    mov   AX_PTRSIZE, [GDT_Descriptor_PTR]
    mov   DX_PTRSIZE, [GDT_Stack_Pointer_PTR]

        movzx DX_PTRSIZE, word[DX_PTRSIZE]
        add   DX_PTRSIZE, SegmentDescriptorSize-1
        ;adding 8 cause stack pointer is pointing to the Descriptor
        ;   and the descriptor is growing to the upper addresses
        ;   so the limit should be atleast after SP
        ;   -1 cause it is limit, and +8 is next descriptor
        cmp   [AX_PTRSIZE + GDT_Descriptor.limit], dx
        IF_COND_START Below
;           if the limit is below stack pointer, you should update descriptor
            mov   [AX_PTRSIZE + GDT_Descriptor.limit], dx
            %ifndef debug_high_level
            lgdt [AX_PTRSIZE]
            %endif
        IF_COND_END
; return offset
    mov   AX_PTRSIZE, [GDT_Stack_Pointer_PTR]
    movzx AX_PTRSIZE, word[AX_PTRSIZE]
    leave
    ret
    %pop

globASM_FUN_lgdt:;void (Pointer from where to load)
    mov   AX_PTRSIZE, STACK_ARG1_SP
        lgdt  [AX_PTRSIZE]
    ret
globASM_FUN_sgdt:;void (Pointer where to store)
    mov   AX_PTRSIZE, STACK_ARG1_SP
        sgdt [AX_PTRSIZE]
    ret
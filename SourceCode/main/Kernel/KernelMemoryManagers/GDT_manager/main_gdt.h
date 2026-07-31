#ifndef MAIN_GDT_H_SENTRY
#define MAIN_GDT_H_SENTRY
#include <stdint.h>

struct GDT_descriptor{
    uint16_t  Limit;
    uint64_t* GDT_PTR;
};


enum GDT_System_Types_enum{
    GDTSystemType_Invalid0 = 0,
    GDTSystemType_TSS16_Available = 1,
    GDTSystemType_LDT = 2,
    GDTSystemType_TSS16_Busy = 0x3,
    GDTSystemType_CallGate16 = 0x4,
    GDTSystemType_TSS32_Available = 0x9,
    GDTSystemType_TSS32_Busy = 0xB,
    GDTSystemType_CallGate32 = 0xC,
};




struct Segment_Request_r
{
    void* Base;
    uint32_t Limit;

    unsigned char Is_Accessed;

    unsigned char Is_EXE;
    unsigned char EXE_is_readable;
    unsigned char EXE_is_conforming;

    unsigned char Data_is_writable;
    unsigned char Data_is_E_Down;

    unsigned char Privelege;
    unsigned char IsNot_System;
    unsigned char Is_Present;

    unsigned char Is_Available;
    unsigned char Is_64;
    unsigned char Is_32;
    unsigned char Is_Granular;

    unsigned char Call_Gate_Selector;
    unsigned char Arg_Copy_Amount;
    unsigned char System_Type;

    unsigned char Request_done;

    unsigned char Padding[6];
};




uint32_t main_GDT_Init_Kernel_GDT_ForC(
    struct Segment_Request_r* Requests_Array_PTR,
    struct GDT_Descriptor*    GDT_Descriptor_PTR
);
uint32_t main_GDT_Init_Kernel_LDT_ForC(
    struct Segment_Request_r* Requests_Array_PTR,
    uint64_t* LDT_Table_PTR
);


void globASM_FUN_lgdt(uint16_t Segment_Selector);
void globASM_FUN_sgdt(struct GDT_Descriptor* Storage_PTR);

void globASM_FUN_lldt(uint16_t Segment_selector);
uint16_t globASM_FUN_sldt();



extern uint64_t MainGDT_start[8191];
extern uint64_t* MainGDT_end;
extern struct GDT_descriptor MainGDT_Descriptor;


struct Code_Descriptor_Unpacked{
    uint32_t Limit;
    void* Base;

    unsigned char Is_Accessed;
    unsigned char Is_Readable;
    unsigned char Is_Conforming;
    unsigned char Privelege_LVL;
    unsigned char Is_Present;

    unsigned char Available_Bit;
    unsigned char Is_32;
    unsigned char Is_Granular;
};


uint32_t main_GDT_Unpack_CodeDescriptor_ForC
    (
        uint64_t* Descriptor_PTR,\
        struct Code_Descriptor_Unpacked* Unpacked_PTR
    );





struct Data_Descriptor_Unpacked{
    uint32_t Limit;
    void*    Base;

    unsigned char Is_Accessed;
    unsigned char Is_Writable;
    unsigned char Is_E_Down;
    unsigned char Privelege_LVL;
    unsigned char Is_Present;

    unsigned char Available_Bit;
    unsigned char Is_32;
    unsigned char Is_Granular;
};
uint32_t main_GDT_Unpack_DataDescriptor_ForC(
    uint64_t* Decriptor_PTR,\
    struct Data_Descriptor_Unpacked* Unpacked_PTR
);

struct TSS32_Decriptor_Unpacked{
    uint32_t Limit;
    void* Base;

    unsigned char Is_Busy;
    unsigned char Privelege_LVL;
    unsigned char Available_Bit;
    unsigned char Is_Present;
    unsigned char Is_Granular;
    uint8_t      Padding1[3];
};
uint32_t main_GDT_Unpack_TSS32Descriptor_ForC(
    uint64_t* Descriptor_PTR,
    struct TSS32_Descriptor_Unpacked* Unpacked_PTR
);



struct LDT_Descriptor_Unpacked{
    uint32_t Limit;
    void* Base;

    unsigned char Privelege_LVL;
    unsigned char Is_Present;
    unsigned char Available_Bit;
    unsigned char Is_Granular;

    uint32_t Padding;
};

uint32_t main_GDT_Unpack_LDTDescriptor_ForC(
    uint64_t* Descriptor_PTR,
    struct LDT_Descriptor_Unpacked* Unpacked_PTR
);








#endif
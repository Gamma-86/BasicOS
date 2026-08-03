#ifndef X86_SEGMENTS_H_SENTRY
#define X86_SEGMENTS_H_SENTRY

#include <stdint.h>

typedef uint64_t GDT_Segment_Raw;
typedef uint16_t Descriptor_Limit_low;
typedef uint8_t  Descriptor_Limit_high;
typedef uint16_t Descriptor_Segment_Selector;


typedef void* Descriptor_BaseAddress_Separated;

enum SystemTypes_t{
Invalid0 = 0,
TSS16_Available = 1,
LDT     = 2,
TSS16_Busy      = 3,
CallGate16     = 4,
Task_Gate       = 5,
Interrupt16     = 6,
Trap16          = 7,
Reserved8       = 8,
TSS32_Available = 9,
Reserved10      = 0xA,
TSS32_Busy      = 0xB,
CallGate32     = 0xC,
Reserved13      = 0xD,
Interrupt32     = 0xE,
Trap32          = 0xF
};

    enum GDTSysTypes_t{
    Invalid0,
    TSS16_Available,
    LDT,
    TSS16_Busy,
    CallGate16,
    Task_Gate,
//  Interrupt16,
//  Trap16,
    Reserved8,
    TSS32_Available,
    Reserved10,
    TSS32_Busy,
    CallGate32,
    Reserved13
//  Interrupt32,
//  Trap32
   };


struct Segment_Descriptor_Raw{
    uint16_t Word1;
    uint16_t Word2;
    uint8_t  Byte5;
    uint8_t AccessByte;
    uint16_t Word4;
};



struct GDT_Descriptor_r{
    uint16_t Limit;
    struct Segment_Descriptor_Raw* The_GDT;
};

#endif
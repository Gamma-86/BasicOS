#include <stdint.h>
#include "OSInspected_Types.h"

uint32_t MB2BootCalls32_Router(uint32_t Call_Index,\
    uint32_t Arg1,\
    uint32_t Arg2,\
    uint32_t Arg3,\
    uint32_t Arg4,\
    uint32_t Arg5
){

    uint32_t EndPoint_Return;

    switch (Call_Index)
    {
    case CallCode_Test:
        break;
    case EnvironmenPrint:
        break;
    case Typed_Panic:
        break;
    case Custom_Panic:
        break;
    case BootMalloc:
        break;
    case BootCalloc:
        break;
    case BootRealloc:
        break;
    case BootFree:
        break;
    case Get_RAMMap_Size:
        break;
    case Get_RAMMap:
        break;
    case Get_Above1MB_RamEntry:
        break;
    case Get_BasicRamInfo:
        break;
    case Get_BootErrors:
        break;
    case Get_Boot_ISA_info:
        break;
    case Get_BootEntryName:
        break;
    case Get_VRAM_info:
        break;
    default:
        break;
    }

    return EndPoint_Return;
}







/*
##############################################################################
##############################################################################

Memory allocator

##############################################################################
##############################################################################
*/


#include "MemAllocs.c"



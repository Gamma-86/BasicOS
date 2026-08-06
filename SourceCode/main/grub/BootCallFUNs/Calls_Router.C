#include <stdint.h>
#include "Inspected_Types.h"

uint32_t MB2BootCalls32_Router(uint32_t Call_Index,\
    uint32_t Arg1,\
    uint32_t Arg2,\
    uint32_t Arg3,\
    uint32_t Arg4,\
    uint32_t Arg5
){
    enum CallsCodes{
        Reserved = 0,
        Write_Envrionment = 1,
        Typed_Panic = 2,
        Panic_Custom_STR = 3,
        Initial_Malloc = 4,
        Initial_Calloc = 5,
        Initial_Realloc = 6,
        Initial_Free   = 7,
        Get_FreeRAM_Above_1MB=8,
    };
    uint32_t EndPoint_Return;

    switch (Call_Index)
    {
    case Write_Envrionment:
        break;
    case Typed_Panic:
        break;
    case Panic_Custom_STR:
        break;
    case Initial_Malloc:
        break;
    case Initial_Calloc:
        break;
    case Initial_Realloc:
        break;
    case Initial_Free:
        break;
    default:
        break;
    }

    return EndPoint_Return;
}
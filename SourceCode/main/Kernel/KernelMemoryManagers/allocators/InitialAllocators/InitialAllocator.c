#include "AtomicOperations.h"
#include "OS_return_codes.h"
#include <stdint.h>

#define ARENA1_SIZE 4096


struct Arena_metadata{
    unsigned short Bytes_left;
    unsigned short Stack_pointer;
    unsigned char  Locking_bool;
    unsigned char  Is_free;
};

static unsigned char Arena1_pool[ARENA1_SIZE];
static struct Arena_metadata Arena1_data ={
    .Bytes_left = ARENA1_SIZE,
    .Is_free = 1,
    .Locking_bool = 0,
    .Stack_pointer = 0
};

uint32_t Arena1_initial_malloc(void** PTR, unsigned int size){
    /*Plan :
    1- lock mutex of Arena1
    2- check for differnt kind of error and set bits correspondibly
    2.1- check for null pointer
    2.2- check if size is bigger that all possible space 
    2.3- check if size is bigger than bytes left
    
    3- if 1 of the above is met, this is critical error
        3.1 - if critrical error happened check for mutex watchdog status
        1 = watchdog set, 0=everything went fine
        set watchdog bit in return bitfield according to return status
        3.2 unlock mutex
        3.3 return bitfied
    4- else set bit in return bitfield according to watchdong status
    5- allocate memory
        5.1 - set returned pointer to current stackPointer+Array Address
        5.2 - add size to stack pointer
        5.3 - subtract size from available bytes
    6 - set bit Fulfiled with error in bitfield according to status
    7 - return bitfield and return from function*/
    uint32_t returned_bitfield = 0;
    unsigned char Lock_result;
    enum{WatchdogTick = 0xFFFFF};

    Lock_result = Mutex_Lock_Watchdog(&Arena1_data.Locking_bool, WatchdogTick);
    Lock_result = Lock_result == 1 ? Lock_result : 0;

    if(PTR == NULL){
        returned_bitfield = returned_bitfield | LOW8_GeneralOS;
        returned_bitfield = returned_bitfield | (1<<GeneralOS_Nullptr);
    };
    if(size > ARENA1_SIZE){
        returned_bitfield = returned_bitfield | LOW8_GeneralOS;
        returned_bitfield = returned_bitfield | (1<<GeneralOS_AllocationImpossible);
    };
    if(size > Arena1_data.Bytes_left){
        returned_bitfield = returned_bitfield | LOW8_GeneralOS;
        returned_bitfield = returned_bitfield | (1<<GeneralOS_AllocationFailed);
    };
    if(returned_bitfield != 0){
        returned_bitfield = returned_bitfield | (((uint32_t) Lock_result)<<GeneralOS_WatchdogSet);
        Mutex_Unlock(&Arena1_data.Locking_bool);
        return returned_bitfield;
    }

    returned_bitfield = returned_bitfield | (((uint32_t) Lock_result)<<GeneralOS_WatchdogSet);
    //starting main allocation

    *PTR = &(Arena1_pool[Arena1_data.Stack_pointer]);
    Arena1_data.Stack_pointer = Arena1_data.Stack_pointer + (unsigned short)size;
    Arena1_data.Bytes_left = Arena1_data.Bytes_left - (unsigned short)size;

    return returned_bitfield;
};

uint32_t Arena1_initial_calloc(void** PTR, unsigned int size){
    uint32_t returned_bitfield = 0;

    return returned_bitfield;
};


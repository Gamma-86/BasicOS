#include <stdint.h>
#include "Bitwise_Arithmetic.h"


struct MemAllocs_head{
    unsigned char next;
    unsigned char prev;
    unsigned char IsAllocated;
    unsigned char Reserved2;//4b

    uint16_t PoolSize;//6b
    uint16_t IndexAddress;//8b
};






enum MemAllocs_OBJIndexes{
    MemAllocs_CheckListIntegrity_Indx = 0,
    MemAllocs_UpdateCache_Indx,
    Reverse_RAMHeadIndex_Indx,
    MemAllocs_FindFreeHead_Indx,
    MemAllocs_HeadXCHG_Indx,
    MemAllocs_SortHeads_Indx,

    BootMalloc_FUN_Indx,
    BootCalloc_FUN_Indx,
    MemAllocs_MergeHeads_Indx,
    BootFree_FUN_Indx,
    BootRealloc_FUN_Indx,

    MemAlloc_FUNAmount,
};

struct MemAllocs_FUNLever{
    uint32_t CheckListIntegrity : 1;
    uint32_t UpdateCache : 1;
    uint32_t Reverse_RAMHeadIndex : 1;
    uint32_t FindFreeHead : 1;
    uint32_t HeadXCHG : 1;
    uint32_t SortHeads: 1;
    uint32_t BootMalloc : 1;
    uint32_t BootCalloc : 1;
    uint32_t MemAllocs  : 1;
    uint32_t BootFree   : 1;
    uint32_t BootRealloc: 1;
};

#define MEMALLOCS_JTAG_CALLS_SIZE 4
struct MemAllocs_JTAG{
    unsigned char Reserved[32];

    struct MemAllocs_FUNLever FUN_is_on;
    struct MemAllocs_FUNLever StartCall_is_on;
    struct MemAllocs_FUNLever EndCall_is_on;


    void(*CheckListIntegrityStart_Calls[MEMALLOCS_JTAG_CALLS_SIZE])();
    void(*CheckListIntegrityEnd_Calls[MEMALLOCS_JTAG_CALLS_SIZE])(\
        struct MemAllocs_Head* Last,\
        struct MemAllocs_head* First,\
        unsigned char* ResultStatus);


    void(*UpdateCache_StartCalls[MEMALLOCS_JTAG_CALLS_SIZE])(\
        unsigned char* HeadIndex,\
        void** The_PTR\
    );
    void(*UpdateCache_EndCalls[MEMALLOCS_JTAG_CALLS_SIZE])(\
        unsigned char* HeadIndex,\
        void** The_PTR\
    );


    void(*Reverse_RAMHeadIndex_StartCalls[MEMALLOCS_JTAG_CALLS_SIZE])(void** The_PTR);
    void(*Reverse_RAMHeadIndex_EndCalls[MEMALLOCS_JTAG_CALLS_SIZE])(\
        void** The_PTR,\
        unsigned char** UsedPTR,\
        uint16_t* BytePoolIndex,\
        unsigned char* HeadIndex\
    );

    void(*HeadXCHG_Indx_StartCalls[MEMALLOCS_JTAG_CALLS_SIZE])(\
        unsigned char* Index1,\
        unsigned char Index2\
    );
    void(*HeadXCHG_Indx_EndCalls[MEMALLOCS_JTAG_CALLS_SIZE])(\
        unsigned char* Index1,\
        unsigned char* Index2,\
        unsigned char* TMP1_IsAllocated,\
        unsigned char* TMP1_Reserved,\
        uint16_t* TMP1_PoolSize,\
        uint16_t* TMP1_AddressIndex\
    );


    void(*FindFreeHead_StartCalls[MEMALLOCS_JTAG_CALLS_SIZE])(unsigned char** Found);
    void(*FindFreeHead_EndCalls[MEMALLOCS_JTAG_CALLS_SIZE])(\
        unsigned char** Found,\
        unsigned char* FreeIndex,\
        uint32_t* FreeBit_int\
    );


    void(*BootMalloc_FUN_StartCalls[MEMALLOCS_JTAG_CALLS_SIZE])(uint32_t* Size);
    void(*BootMalloc_FUN_EndCalls[MEMALLOCS_JTAG_CALLS_SIZE])(uint32_t* Size, unsigned char* FoundFreeHead, uint16_t* Used_Size, unsigned char* BestHeadPTR, unsigned char* NewHeadPTR, struct MemAllocs_head* BestHead, struct MemAllocs_head* NewHead);

};

struct MemAllocs_JTAG MemAlloc_JTAG = {
    .FUN_is_on = {1},
    .StartCall_is_on = {0},
    .EndCall_is_on = {0},
    
    .CheckListIntegrityStart_Calls={NULL},
    .CheckListIntegrityEnd_Calls = {NULL},
    
    .UpdateCache_StartCalls = {NULL},
    .UpdateCache_EndCalls = {NULL},
};



#define BYTES_POOL_SIZE UINT16_MAX+1
#define RAMHEADERS_POOL_SIZE 256
#define RAMHEADERS_FREE_BITFIELD32_SIZE RAMHEADERS_POOL_SIZE/(4*8)
#define RAMHEADERS_INIT_FIRST_ENTRY_INDEX 1
#define RAMHEAD_NULL_INDEX 0

static uint32_t FreeHeaders_Bitmap[RAMHEADERS_FREE_BITFIELD32_SIZE]={UINT32_MAX};

static struct MemAllocs_head RAM_HeadersPool[RAMHEADERS_POOL_SIZE] = {
    [RAMHEADERS_INIT_FIRST_ENTRY_INDEX]={\
        .IndexAddress = 0,\
        .IsAllocated = 0,\
        .next = RAMHEADERS_INIT_FIRST_ENTRY_INDEX,\
        .prev = RAMHEADERS_INIT_FIRST_ENTRY_INDEX,\
        .PoolSize = UINT16_MAX\
    },
};
static unsigned char RAM_BytesPool[BYTES_POOL_SIZE];


struct MemAlloc_Data{
    unsigned char HeadsMergePeriod;
    unsigned char FreesTillMerge;
    unsigned char Entry1;
    unsigned char EntryLast;
    unsigned char EntryXORsum;
    unsigned char AlignmentMask;

    unsigned char reserved[12];
};
static struct MemAlloc_Data MemAlloc_Data = {\
    .FreesTillMerge = 8,\
    .HeadsMergePeriod = 8,\
    .Entry1 = RAMHEADERS_INIT_FIRST_ENTRY_INDEX,\
    .EntryLast = RAMHEADERS_INIT_FIRST_ENTRY_INDEX,\
    .AlignmentMask = 0xF,\
};

struct MemAllocs_Cache{
    unsigned char HeadPTRs[4];//4b
    void* PTRs[4];//20b

    uint16_t RAM_left;//22b
    unsigned char CachePTR;
    unsigned char Reserved[9];//32b
};



struct MemAllocs_Cache MemAllocs_Cache={\
    .HeadPTRs = {0},\
    .PTRs = {NULL},\
    .RAM_left= UINT16_MAX,\
    .Reserved = {0}\
};




enum MemAllocs_ListIntegrityStatus{
    List_IntegrityGood = 0,
    List_LastPTRBad = 1,
    List_FirstPTRBad = 2,
    List_BothPTRBad = 3,
    List_PTRsXORsumBad = 4,
};







#define MEMALLOCS_CALL_FUNCTIONS_CALLS(THE_FUN_ARRAY, FUN_HEAD, FUN_CALLS_STATUS)\
    if(FUN_CALLS_STATUS){\
    for (int i = 0; i < MEMALLOCS_JTAG_CALLS_SIZE; i++){\
        if( THE_FUN_ARRAY[i] ){\
            THE_FUN_ARRAY[i] FUN_HEAD;\
        }\
    }\
}



static inline void MemAllocs_UpdateEndEntries(\
    unsigned char Entry1,\
    unsigned char EntryLast\
){
    MemAlloc_Data.Entry1 = Entry1;
    MemAlloc_Data.EntryLast = EntryLast;
    MemAlloc_Data.EntryXORsum = Entry1 ^ EntryLast;
    return;
}

static unsigned char MemAllocs_CheckListIntegrity(){
    if(!MemAlloc_JTAG.FUN_is_on.CheckListIntegrity){
        return List_BothPTRBad | List_PTRsXORsumBad;
    }
    MEMALLOCS_CALL_FUNCTIONS_CALLS(\
        MemAlloc_JTAG.CheckListIntegrityStart_Calls,\
        (),\
        MemAlloc_JTAG.StartCall_is_on.CheckListIntegrity\
    )

    struct MemAllocs_head Last;
    struct MemAllocs_head First;
    unsigned char ResultStatus = List_IntegrityGood;
    Last = RAM_HeadersPool[MemAlloc_Data.EntryLast];
    First = RAM_HeadersPool[MemAlloc_Data.Entry1];

    if(Last.next != MemAlloc_Data.Entry1){
        ResultStatus = List_LastPTRBad;
    }
    if(First.prev != MemAlloc_Data.EntryLast){
        ResultStatus |= List_FirstPTRBad;
    }
    if(MemAlloc_Data.Entry1 ^ MemAlloc_Data.EntryLast != MemAlloc_Data.EntryXORsum)
    {
        ResultStatus |= List_PTRsXORsumBad;
    }
    MEMALLOCS_CALL_FUNCTIONS_CALLS(\
        MemAlloc_JTAG.CheckListIntegrityEnd_Calls,\
        (&Last, &First, &ResultStatus),\
        MemAlloc_JTAG.EndCall_is_on.CheckListIntegrity\
    )
    return ResultStatus;
};



static void MemAllocs_UpdateCache(unsigned char HeadIndex, void* The_PTR){
    if( !(MemAlloc_JTAG.FUN_is_on.UpdateCache) )return;
    MEMALLOCS_CALL_FUNCTIONS_CALLS(\
        MemAlloc_JTAG.UpdateCache_StartCalls,\
        (&HeadIndex, &The_PTR),\
        MemAlloc_JTAG.StartCall_is_on.UpdateCache\
    )

    MemAllocs_Cache.HeadPTRs[MemAllocs_Cache.CachePTR] = HeadIndex;
    MemAllocs_Cache.PTRs[MemAllocs_Cache.CachePTR] = The_PTR;
    MemAllocs_Cache.CachePTR++;

    MemAllocs_Cache.CachePTR %=\
        sizeof(MemAllocs_Cache.HeadPTRs)\
        / \
        sizeof(MemAllocs_Cache.HeadPTRs[0])\
    ;

    MEMALLOCS_CALL_FUNCTIONS_CALLS(\
        MemAlloc_JTAG.UpdateCache_EndCalls,\
        (&HeadIndex, &The_PTR),\
        MemAlloc_JTAG.EndCall_is_on.UpdateCache\
    )
    return;
}

static unsigned char Reverse_RAMHeadIndex(void* The_PTR){
    if( !(MemAlloc_JTAG.FUN_is_on.Reverse_RAMHeadIndex) ){
        return RAMHEAD_NULL_INDEX;
    }
    MEMALLOCS_CALL_FUNCTIONS_CALLS(\
        MemAlloc_JTAG.Reverse_RAMHeadIndex_StartCalls,\
        (&The_PTR),\
        MemAlloc_JTAG.StartCall_is_on.Reverse_RAMHeadIndex\
    )



    unsigned char* UsedPTR = The_PTR;
    uint16_t BytePoolIndex;
    unsigned char HeadIndex = RAMHEAD_NULL_INDEX;
    if(UsedPTR < RAM_BytesPool || UsedPTR > &RAM_BytesPool[BYTES_POOL_SIZE-1]){
        MEMALLOCS_CALL_FUNCTIONS_CALLS(MemAlloc_JTAG.Reverse_RAMHeadIndex_EndCalls,\
            (&The_PTR, &UsedPTR, &BytePoolIndex, &HeadIndex),\
            MemAlloc_JTAG.EndCall_is_on.Reverse_RAMHeadIndex\
        )
        return RAMHEAD_NULL_INDEX;
    }
    for(int i=0; i< sizeof(MemAllocs_Cache.PTRs)/sizeof(MemAllocs_Cache.PTRs[0]);i++){
        if(MemAllocs_Cache.PTRs[i]==The_PTR)return MemAllocs_Cache.HeadPTRs[i];
    }
    BytePoolIndex = UsedPTR - RAM_BytesPool;

    if(RAM_HeadersPool[MemAlloc_Data.Entry1].next == MemAlloc_Data.Entry1)\
        MEMALLOCS_CALL_FUNCTIONS_CALLS(MemAlloc_JTAG.Reverse_RAMHeadIndex_EndCalls,\
            (&The_PTR, &UsedPTR, &BytePoolIndex, &HeadIndex),\
            MemAlloc_JTAG.EndCall_is_on.Reverse_RAMHeadIndex\
        )
        return MemAlloc_Data.Entry1;

    for(\
        unsigned char CurrentHeadPTR = MemAlloc_Data.Entry1;\
        RAM_HeadersPool[CurrentHeadPTR].next != MemAlloc_Data.Entry1;\
        CurrentHeadPTR = RAM_HeadersPool[CurrentHeadPTR].next\
    ){
        uint16_t BoundLow;
        uint16_t BoundHigh;
    
        if( !(RAM_HeadersPool[CurrentHeadPTR].IsAllocated) )continue;
    
        BoundLow = RAM_HeadersPool[CurrentHeadPTR].IndexAddress;
        BoundHigh = BoundLow+RAM_HeadersPool[CurrentHeadPTR].PoolSize;
        if(BoundLow < BytePoolIndex && BytePoolIndex < BoundHigh){
            HeadIndex = CurrentHeadPTR;
        }
    }





    MEMALLOCS_CALL_FUNCTIONS_CALLS(MemAlloc_JTAG.Reverse_RAMHeadIndex_EndCalls,\
        (&The_PTR, &UsedPTR, &BytePoolIndex, &HeadIndex),\
        MemAlloc_JTAG.EndCall_is_on.Reverse_RAMHeadIndex\
    )
    return HeadIndex;
};






static unsigned char MemAllocs_FindFreeHead(unsigned char* Found){
    if(!MemAlloc_JTAG.FUN_is_on.FindFreeHead){
        *Found = 0;
        return 0;
    }
    MEMALLOCS_CALL_FUNCTIONS_CALLS(\
        MemAlloc_JTAG.FindFreeHead_StartCalls,\
        (&Found),\
        MemAlloc_JTAG.StartCall_is_on.FindFreeHead\
    )





    unsigned char FreeIndex = 0;
    uint32_t FreeBit_int;
    *Found = 0;

    for (unsigned char i = 0; i < RAMHEADERS_FREE_BITFIELD32_SIZE/2; i+=2)
    {
        uint32_t Checked1 = FreeHeaders_Bitmap[i];
        uint32_t Checked2 = FreeHeaders_Bitmap[i+1];

        if(Checked1 | Checked2){
            /*if we found the non 0 bit, we have to do:
            1-set Found to 1,
            2-Initially set FreeIndex to i<<5 
                because 1 uint32_t is 32 entries
            3- set the final inspected bitfield to the first non 0 Checked
                if checked1 is 0, set it to Checked1, else Checked2 has to
                be non 0, so set inspected value to it
            4- if Checked1 = 0, add 32 to FreeIndex, because this mean that
                free entry is in Checked2, which is 32 bit entries away 
                from checked 1
            5- Finally, bit scan forward the FreeBit_int
            6- add set bit index to FreeIndex*/
            
            *Found = 1;//1
            FreeIndex = i*32;//2
            FreeBit_int = Checked1!=0 ? Checked1 : Checked2;//3
            FreeIndex += (Checked1 == 0)*32;//4
            FreeIndex += BitScanForward32(FreeBit_int);//5,6
        }

    }

    if(FreeIndex == 0){
        *Found=0;
    }
    MEMALLOCS_CALL_FUNCTIONS_CALLS(\
        MemAlloc_JTAG.FindFreeHead_EndCalls,\
        (&Found, &FreeIndex, &FreeBit_int),\
        MemAlloc_JTAG.EndCall_is_on.FindFreeHead\
    )

    return FreeIndex;
};

static void MemAllocs_HeadXCHG(unsigned char Index1, unsigned char Index2){
    if(!MemAlloc_JTAG.FUN_is_on.HeadXCHG)return;
    MEMALLOCS_CALL_FUNCTIONS_CALLS(\
        MemAlloc_JTAG.HeadXCHG_Indx_StartCalls,\
        (&Index1, &Index2),\
        MemAlloc_JTAG.StartCall_is_on.HeadXCHG\
    )
    
    
    
    unsigned char TMP1_IsAllocated = RAM_HeadersPool[Index1].IsAllocated;
    unsigned char TMP1_Reserved = RAM_HeadersPool[Index1].Reserved2;
    uint16_t TMP1_PoolSize = RAM_HeadersPool[Index1].PoolSize;
    uint16_t TMP1_AddressIndex = RAM_HeadersPool[Index1].IndexAddress;

    RAM_HeadersPool[Index1].IsAllocated = RAM_HeadersPool[Index2].IsAllocated;
    RAM_HeadersPool[Index1].Reserved2 = RAM_HeadersPool[Index2].Reserved2;
    RAM_HeadersPool[Index1].PoolSize = RAM_HeadersPool[Index2].PoolSize;
    RAM_HeadersPool[Index1].IndexAddress=RAM_HeadersPool[Index2].IndexAddress;

    RAM_HeadersPool[Index2].IsAllocated = TMP1_IsAllocated;
    RAM_HeadersPool[Index2].Reserved2 = TMP1_Reserved;
    RAM_HeadersPool[Index2].PoolSize  = TMP1_PoolSize;
    RAM_HeadersPool[Index2].IndexAddress = TMP1_AddressIndex;

    MEMALLOCS_CALL_FUNCTIONS_CALLS(\
        MemAlloc_JTAG.HeadXCHG_Indx_EndCalls,\
        (&Index1, &Index2, &TMP1_IsAllocated, &TMP1_Reserved, &TMP1_PoolSize,\
            &TMP1_AddressIndex),\
        MemAlloc_JTAG.EndCall_is_on.HeadXCHG\
    )
    return;
}



static void MemAllocs_SortHeads(){
    unsigned char ForwardPTR = MemAlloc_Data.Entry1;
    for(ForwardPTR=MemAlloc_Data.Entry1;\
        RAM_HeadersPool[ForwardPTR].next != MemAlloc_Data.Entry1;\
        ForwardPTR = RAM_HeadersPool[ForwardPTR].next\
    ){
        unsigned char NextPTR=RAM_HeadersPool[ForwardPTR].next;
        
        if(RAM_HeadersPool[ForwardPTR].IndexAddress > RAM_HeadersPool[NextPTR].IndexAddress){
            unsigned char BestIndex=ForwardPTR;
            uint16_t BestAddress = RAM_HeadersPool[ForwardPTR].IndexAddress;

            for(unsigned char BackwardPTR=ForwardPTR;\
                RAM_HeadersPool[BackwardPTR].prev != MemAlloc_Data.EntryLast;\
                BackwardPTR = RAM_HeadersPool[BackwardPTR].prev
            ){
                unsigned char PrevIndex=RAM_HeadersPool[BackwardPTR].prev;
                uint16_t PrevAddress=RAM_HeadersPool[BackwardPTR].IndexAddress;
                if(RAM_HeadersPool[NextPTR].IndexAddress<PrevAddress && PrevAddress<BestAddress){
                    BestAddress=PrevAddress;
                    BestIndex=PrevIndex;
                }
                MemAllocs_HeadXCHG(NextPTR, BestIndex);
            }



        }


    }


}

static void* BootMalloc_FUN(uint32_t Size){
    if(MemAlloc_JTAG.FUN_is_on.BootMalloc){
        return NULL;
    }
    MEMALLOCS_CALL_FUNCTIONS_CALLS(\
        MemAlloc_JTAG.BootMalloc_FUN_StartCalls,\
        (&Size),\
        MemAlloc_JTAG.StartCall_is_on.BootMalloc\
    )



    unsigned char FoundFreeHead;
    uint16_t Used_Size = (uint16_t)Size;
    unsigned char BestHeadPTR = MemAlloc_Data.Entry1;
    unsigned char NewHeadPTR = RAMHEAD_NULL_INDEX;
    struct MemAllocs_head BestHead, NewHead;


    if(Size > UINT16_MAX){
        MEMALLOCS_CALL_FUNCTIONS_CALLS(\
            MemAlloc_JTAG.BootMalloc_FUN_EndCalls,\
            (\
                &Size,\
                &FoundFreeHead,\
                &Used_Size,\
                &BestHeadPTR,\
                &NewHeadPTR,\
                &BestHead,\
                &NewHeadPTR\
            ),\
            MemAlloc_JTAG.EndCall_is_on.BootMalloc\
        )


        return NULL;
    }

    do{
        unsigned char Fits;
        uint32_t BestFitSize = UINT16_MAX+1;
        struct MemAllocs_head CurrentHeadPTR = RAM_HeadersPool[BestHeadPTR];

        Fits=CurrentHeadPTR.PoolSize>=Used_Size && !(CurrentHeadPTR.IsAllocated);
        if(!Fits) continue;

        if(CurrentHeadPTR.PoolSize<=BestFitSize){
            BestFitSize = CurrentHeadPTR.PoolSize;
            BestHeadPTR = BestHeadPTR;
        }

    } while (RAM_HeadersPool[BestHeadPTR].next != MemAlloc_Data.Entry1);

    NewHeadPTR = MemAllocs_FindFreeHead(&FoundFreeHead);
    if(!FoundFreeHead || NewHeadPTR==RAMHEAD_NULL_INDEX) return NULL;

    BestHead = RAM_HeadersPool[BestHeadPTR];
    /*
    Creating New head:
    1-New head Size = The given to allocate size
    2-GIving New head index address
        2.1-Subtracting Allocating size from size best head
        2.2-New index address=Index of Best head plus its size
    3-Writing that new head is allocated RAM
    4-Rewriting(Inserting) linked list pointers
        4.1 : New head next = next of the best head
        4.2 : New head prev = Best head
        4.3 : Best Head next = New Head
    */
    //1
    NewHead.PoolSize = Used_Size;
    //2
    BestHead.PoolSize -= Used_Size;//2.1
    NewHead.IndexAddress = BestHead.IndexAddress + BestHead.PoolSize;//2.2
    //3
    NewHead.IsAllocated = 1;
    //4
    NewHead.next = BestHead.next;//4.1
    NewHead.prev = BestHeadPTR;//4.2
    BestHead.next = NewHeadPTR;//4.3

    if(NewHead.next == MemAlloc_Data.Entry1)
        MemAllocs_UpdateEndEntries(MemAlloc_Data.Entry1 ,NewHeadPTR);


    RAM_HeadersPool[BestHeadPTR] = BestHead;
    RAM_HeadersPool[NewHeadPTR] = NewHead;




    MEMALLOCS_CALL_FUNCTIONS_CALLS(\
        MemAlloc_JTAG.BootMalloc_FUN_EndCalls,\
        (\
            &Size,\
            &FoundFreeHead,\
            &Used_Size,\
            &BestHeadPTR,\
            &NewHeadPTR,\
            &BestHead,\
            &NewHeadPTR\
        ),\
        MemAlloc_JTAG.EndCall_is_on.BootMalloc\
    )
    return &(RAM_BytesPool[NewHead.IndexAddress]);
};

static void* BootCalloc_FUN(uint32_t Size){
    void* Returned_PTR = BootCalloc_FUN(Size);
    unsigned char HeadIndex = Reverse_RAMHeadIndex(Returned_PTR);
    uint16_t PoolSize = RAM_HeadersPool[HeadIndex].PoolSize;
    uint16_t PoolBase = RAM_HeadersPool[HeadIndex].IndexAddress;
    for(uint16_t i=0;i<PoolSize;i++){
        RAM_BytesPool[PoolBase+i]=0;
    }
    return Returned_PTR;
};



static void  MemAllocs_MergeHeads(){

}

static void* BootFree_FUN(void* PTR){

};



static void* BootRealloc_FUN(uint32_t Size){

};
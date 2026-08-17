#include <stdint.h>

#include "multiboot_structures.h"
#include "./panic/multiboot2_panic.h"

#include "MB2_Parsed_Types.h"
#include "OSInspected_Types.h"

/*
##############################################################################
10
10
10
##############################################################################
*/
static inline void* Align_PTR_Floor8(void* PTR){
    return (void*)( (uintptr_t)PTR & ~7 );
}
static inline void* Align_PTR_Roof8(void* PTR){
    PTR = (void*)( (uintptr_t)PTR + 8 );
    return (void*) ( (uintptr_t)PTR & ~7 );
}
static inline void* Add_Xbytes_ToPTR(void* PTR, uintptr_t X){
    return (void*)((uintptr_t)PTR + X);
}

/*
##############################################################################



##############################################################################
*/



/*
##############################################################################



##############################################################################
*/
static void MB2BootInfo_Tags_sorter(\
    struct MB2Info_TagHead* MB2BootInfo_Tags_Head,\
    unsigned char*  LastByte_PTR,\
    unsigned char*  FirstByteAfterTags_PTR,\
    uint32_t Tags_TotalSize\
){
    uint32_t Current_MB2Tag_size = 0;
    struct MB2Info_TagHead* Current_MB2Tag_PTR = NULL;

    if(MB2BootInfo_Tags_Head->Size != Tags_TotalSize){
        multiboot2_LoadPanic_customSTR("THE SIZE GIVEN TO\
            MB2BootInfo_Tags_sorter is not equal to one accessed through\
            head pointer");
    }

    Current_MB2Tag_PTR = Add_Xbytes_ToPTR(\
        (void*)MB2BootInfo_Tags_Head,
        sizeof(struct MB2Info_TagHead)
    );

    for(int WatchDog = 0xFFFF; WatchDog>0 ; WatchDog--){
        if(WatchDog == 0){
            MB2_ErrorsReg.Parse_WatchDog_Set=1;
        }
        if( Current_MB2Tag_PTR >= (struct MB2Info_TagHead*)LastByte_PTR )break;

        Current_MB2Tag_size = MB2BootInfo_TagsRouter(Current_MB2Tag_PTR);
        Current_MB2Tag_PTR = Add_Xbytes_ToPTR(\
            (void*)Current_MB2Tag_PTR,\
            (uintptr_t)Current_MB2Tag_size
        );

        Align_PTR_Roof8((void*)Current_MB2Tag_PTR);

    }
    return;
}
/*
##############################################################################
31
31
31
##############################################################################
*/

static void MB2info_RAMmap_translator(\
    struct MB2Info_RAMMap* MB2_RAMMap_Tag_PTR,\
    struct RAMMap_DescriptorEntry* OS_RAMmap_array,\
    uint32_t RAMMap_entries_amount\
){
    /*Goal: translate the ram map of MB2 to OS rammap
    andwrite it to the pre-allocated array OS_RAMmap_array
    most fields are compatible with MB2, fo example types
    How to do it:
    0.1 - check if RAMMap_entries_amount is the same as we can calculate
    1-get the MB2 entry from array(given to the function)
    2-copy to the MB2 entry to the temporary translation entry
    3-push translated entry to the OS RAm entries array
    4-do it RAMMap_entries_amount times*/

    struct MB2_RAMMap_entry* MB2_RAMMap_Entries_Array = &(MB2_RAMMap_Tag_PTR->Entries_start);
    struct RAMMap_DescriptorEntry TranslatedEntry;
    uint32_t CurrentEntry_Translation_PTR = 0;
    unsigned char Amounts_Are_Not_Equal;
    //0.1
    Amounts_Are_Not_Equal = ( (MB2_RAMMap_Tag_PTR->Size-sizeof(struct MB2Info_RAMMap)) / MB2_RAMMap_Tag_PTR->Entry_size ) \
    != \
    MB2_RAMMap_Entries_Array;
    if(Amounts_Are_Not_Equal){
        multiboot2_LoadPanic_customSTR("Multiboot2_info_RAMmap_translator, The given Entries amount is not the equal to the calculated one");
    }
//4
    for(uint32_t i=RAMMap_entries_amount; 0 != i; i--){
//3
    }

    return;
}


/*
##############################################################################
##############################################################################

40

##############################################################################
##############################################################################
*/

static struct BasicRamInfo MB2_BasicRamInfo = {0};
static void* OurBaseAddress;
static struct MB2_ParseErrorFlags MB2_ErrorsReg;
static uint32_t LowRam_size;
static uint32_t HighRam_size;

static struct String_Args MB2OS_CMDArgs = {0};

static struct LegacyBoot_Info MB2OS_LegacyInfo={
    .BIOS_Booted = 0,
    
    .LPT1_State = IDK,
    .LPT2_State = IDK,
    .LPT3_State = IDK,

    .COM1_State = IDK,
    .COM2_State = IDK,
    .COM3_State = IDK,
    .COM4_State = IDK,

    .LPT1_Address = 0,
    .LPT2_Address = 0,
    .LPT3_Address = 0,
    .VGA_Reg_Base = 0x300,

    .COM1_Address = 0,
    .COM2_Address = 0,
    .COM3_Address = 0,
    .COM4_Address = 0,

    .HDDInfo_state = IDK,
    .BootHDD_ID = 0,
    .HDD_amount = 0,

    .Reserved = {0},
};

static struct BootVarName MB2OS_BootName={0};


/*return size of structure*/
static uint32_t MB2BootInfo_TagsRouter(struct MB2Info_TagHead* MB2_structure){
    uint32_t MB2_type = MB2_structure->Type;
    if( (uintptr_t)MB2_structure & 7 ){
        MB2_ErrorsReg.WrongAlignment = 1;
//        multiboot2_LoadPanic(MB2panic_code_Multiboot_UnalignedPTR);
    }

    switch(MB2_type){
        case MB2Info_CMDline_type:
            struct MB2Info_CMDline* CMDLine_TagPTR = (struct MB2Info_CMDline*)MB2_structure;

            MB2OS_CMDArgs.Encoding_type = ASCII;
            MB2OS_CMDArgs.Size = CMDLine_TagPTR->Size;
            MB2OS_CMDArgs.StringPTR = &(CMDLine_TagPTR->Argument_string);

            return CMDLine_TagPTR->Size;
            break;
        case MB2Info_LoaderName_type:
            struct MB2Info_LoaderName* LoaderName_TagPTR = (struct MB2Info_LoaderName*)MB2_structure;

            MB2OS_BootName.Size = LoaderName_TagPTR->Size;
            MB2OS_BootName.Encoding_type = ASCII;
            MB2OS_BootName.StringPTR = &(LoaderName_TagPTR->Name_string);

            return LoaderName_TagPTR->Size;
            break;
        case MB2Info_Module_type:
            struct MB2Info_Module* Module_TagPTR = (struct MB2Info_Module*)MB2_structure;

            return Module_TagPTR->Size;
            break;
        case MB2Info_BasicRam_type:
            struct MB2Info_BasicRAMInfo* BasicRAMInfo_TagPTR = (struct MB2Info_BasicRAMInfo*)MB2_structure;
            if (BasicRAMInfo_TagPTR->Size != MB2Info_BasicRam_size){
                MB2_ErrorsReg.WrongTagSize = 1;
            }
            LowRam_size = BasicRAMInfo_TagPTR->RAMlow_size;
            HighRam_size= BasicRAMInfo_TagPTR->RAMhigh_size;
            return BasicRAMInfo_TagPTR->Size;
            break;
        case MB2Info_BIOSBootDevice_type:
            struct MB2Info_BIOSBootDevice* BIOSBootDevice_TagPTR = (struct MB2Info_BIOSBootDevice*)MB2_structure;
            if(BIOSBootDevice_TagPTR->Size != MB2Info_BIOSBootDevice_size){
                MB2_ErrorsReg.WrongTagSize = 1;
            }
            return BIOSBootDevice_TagPTR->Size;
            break;
        case MB2Info_RAMmap_type:
            struct MB2Info_RAMMap* RAMMap_TagPTR = (struct MB2Info_RAMMap*)MB2_structure;

            struct MB2_RAMMap_entry* Entries_PTR = &(RAMMap_TagPTR->Entries_start);

            return RAMMap_TagPTR->Size;
            break;
        case MB2Info_APM_type:
            struct MB2Info_APM* APMtype_TagPTR = (struct MB2Info_APM*)MB2_structure;
            if(APMtype_TagPTR->Size != MB2Info_APM_size){
                MB2_ErrorsReg.WrongTagSize = 1;
            }
            return APMtype_TagPTR->Size;
            break;
        case MB2Info_VBE_type:
            struct MB2Info_VBIOS* VBIOS_TagPTR = (struct MB2Info_VBIOS*)MB2_structure;
            if(VBIOS_TagPTR->Size != MB2Info_VBE_size)MB2_ErrorsReg.WrongTagSize=1;
            return VBIOS_TagPTR->Size;
            break;
        case MB2Info_VRAM_type:
            struct MB2Info_VRAM* VRAM_TagPTR = (struct MB2Info_VRAM*)MB2_structure;
            return VRAM_TagPTR->Size;
            break;
        case MB2Info_ElfSymbols_type:
            struct MB2Info_ElfSymbols* ElfSymbols_TagPTR = (struct MB2Info_ElfSymbols*)MB2_structure;
            return ElfSymbols_TagPTR->size;
            break;
        case MB2Info_UEFI32table_type:
            struct MB2Info_UEFI32table* UEFI32_TagPTR = (struct MB2Info_UEFI32table*)MB2_structure;
            return UEFI32_TagPTR->Size;
            break;
        case MB2Info_UEFI64table_type:
            struct MB2Info_UEFI64table* UEFI64_TagPTR = (struct MB2Info_UEFI64table*)MB2_structure;
            return UEFI64_TagPTR->Size;
            break;
        case MB2Info_SMBIOS_type:
            struct MB2Info_SMBIOS* SMBIOS_TagPTR = (struct MB2Info_SMBIOS*)MB2_structure;
            return SMBIOS_TagPTR->Size;
            break;
        case MB2Info_ACPIv1_type:
            struct MB2Info_ACPIv1* ACPIv1_TagPTR = (struct MB2Info_ACPIv1*)MB2_structure;
            return ACPIv1_TagPTR->Size;
            break;
        case MB2Info_ACPIv2_type:
            struct MB2Info_ACPIv2* ACPIv2_TagPTR = (struct MB2Info_ACPIv2*)MB2_structure;
            return ACPIv2_TagPTR->Size;
            break;
        case MB2Info_DHCP_ACK_type:
            struct MB2Info_DHCP_ACK_network* DHCP_ACK_TagPTR = (struct MB2Info_DHCP_ACK_network*)MB2_structure;
            return DHCP_ACK_TagPTR->Size;
            break;
        case MB2Info_UEFI_RAM_MAP_type:
            struct MB2Info_UEFI_RAM_MAP* UEFI_RAM_MAP_TagPTR = (struct MB2Info_UEFI_RAM_MAP*)MB2_structure;
            return UEFI_RAM_MAP_TagPTR->Size;
            break;
        case MB2Info_UEFIBootActive_type:
            struct MB2Info_UEFIBootActive* UEFI_BootIsActive_TagPTR = (struct MB2Info_UEFIBootActive*)MB2_structure;
            return UEFI_BootIsActive_TagPTR->Size;
            break;
        case MB2Info_UEFI32handle_type:
            struct MB2Info_UEFI32handle* UEFI32handle_TagPTR = (struct MB2Info_UEFI32handle*)MB2_structure;
            return UEFI32handle_TagPTR->Size;
            break;
        case MB2Info_UEFI64handle_type:
            struct MB2Info_UEFI64handle* UEFI64handle_TagPTR = (struct MB2Info_UEFI64handle*)MB2_structure;
            return UEFI64handle_TagPTR->Size;
            break;

        case MB2Info_BaseAddress_type:
            struct MB2Info_BaseAddress* ThisStructure = \
                (struct MB2Info_BaseAddress*)MB2_structure;
            OurBaseAddress = (void*) ThisStructure->address;
            return ThisStructure->size;
            break;
        default:
            MB2_ErrorsReg.Unknown_Tag_Type = 1;
            return 0;
            break;
    }

    return 0;
}

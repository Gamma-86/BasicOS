#include <stdint.h>

#include "OS_return_codes.h"
#include "multiboot_structures.h"
#include "./PortDebugOutput/PortDebugOutput.h"
#include "./panic/multiboot2_panic.h"



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
20
20
20
##############################################################################
*/
void PrintStringInitial(char* string);
void PrintInt32HEXIntial(uint32_t);


/*
##############################################################################
30
30
30
##############################################################################
*/
extern struct MB2Info_MainHead* MB2Info_absolute_start_PTR;
extern uint32_t MB2Info_absolute_total_size;
    
extern unsigned char MB2Error_Not_Enough_Stack;
extern unsigned char MB2Error_MaxIteration_Passed;
    
extern void* MB2Info_absolute_LastByte_PTR;

enum RAMMap_MemoryType{
    Available_RAM = 1,
    ReservedBySomething_RAM = 2,
    ACPI_RAM = 3,
    RAM_ForHibernation = 4,
    Bad_RAM_type = 5,

    EFI_Loader_Code = 6,
    EFI_Loader_Data = 7,
    
    EFI_Boot_Code = 8,
    EFI_Boot_Data = 9,

    EFI_Runtime_Code = 10,
    EFI_Runtime_Data = 11,

    ACPI_Reclaim_RAM = 12,
    ACPI_NVS = 13,

    MMIO_RAM_Type = 14,
    PMIO_Port_Type = 15,

    MotherBoard_Code = 16,
    EEPROM_RAM = 17,

    Normal_RAM_END = 18
};
struct RAMMap_DescriptorEntry
{
    uint64_t Physical_Address;
    uint64_t Virtual_Address;
    uint64_t Size;
    enum RAMMap_MemoryType Type;
    uint32_t Flag_atributes;
};
struct RAMMap_DescriptorEntry* RAMMap_DescriptorsArray;

void Multiboot2_info_main_sorter(\
    struct MB2Info_TagHead* MB2_BootInfoTags_Pointer,\
    struct RAMMap_DescriptorEntry* DescriptorsArray,\
    uint32_t MB2BootInfo_RAMmapEntries_Amount\
)
{
    uint32_t Current_MB2Tag_size;
    struct MB2Info_TagHead* Current_MB2Tag_PTR = MB2_BootInfoTags_Pointer;
    for(int i = 4096; i>0 ; i--){
        if( Current_MB2Tag_PTR >= (struct MB2Info_TagHead*)MB2Info_absolute_LastByte_PTR )break;

        if(Current_MB2Tag_PTR->Type == MB2Info_RAMmap_type){
            Multiboot2_info_RAMmap_translator(\
            (struct MB2Info_RAMMap*)Current_MB2Tag_PTR,\
            DescriptorsArray);
        }

        Current_MB2Tag_size = Multiboot2_info_main_parser(MB2_BootInfoTags_Pointer);
        Current_MB2Tag_PTR = Add_Xbytes_ToPTR((void*)Current_MB2Tag_PTR, Current_MB2Tag_size);

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

void Multiboot2_info_RAMmap_translator(\
    struct MB2Info_RAMMap* MB2_RAMMap_Tag_PTR,\
    struct RAMMap_DescriptorEntry* OS_RAMmap_array\
){
    struct MB2_RAMMap_entry* MB2_RAMMap_Entries_Array = &(MB2_RAMMap_Tag_PTR->Entries_start);

    return;
}
/*
##############################################################################
32
32
32
##############################################################################
*/

void Multiboot2_info_UEFI_RAMmap_translator(\
    struct MB2Info_UEFI_RAM_MAP,\
    struct RAMMap_DescriptorEntry* OS_RAMMap_array\
){

    return;
}



/*
##############################################################################
40
40
40
##############################################################################
*/

void* OurBaseAddress;
unsigned char MB2ParseErrorFlag_RAMMap_IN_C_FUN = 0;
unsigned char MB2ParseErrorFlag_Unknown_Tag_Type = 0;
unsigned char MB2ParseErrorFlag_WrongAlignment = 0;
unsigned char MB2ParseErrorFlag_WrongTagSize = 0;
/*return size of structure*/
uint32_t Multiboot2_info_main_parser(struct MB2Info_TagHead* MB2_structure){
    uint32_t MB2_type = MB2_structure->Type;
    if( (uintptr_t)MB2_structure & 7 ){
        MB2ParseErrorFlag_WrongAlignment = 1;
        Print_str_lpt("The alignment of given pointer is wrong");
        PrintStringInitial("The alignment of given pointer is wrong");
    }

    switch(MB2_type){
        case MB2Info_CMDline_type:
            struct MB2Info_CMDline* CMDLine_TagPTR = (struct MB2Info_CMDline*)MB2_structure;
            return CMDLine_TagPTR->Size;
            break;
        case MB2Info_LoaderName_type:
            struct MB2Info_LoaderName* LoaderName_TagPTR = (struct MB2Info_LoaderName*)MB2_structure;
            return LoaderName_TagPTR->Size;
            break;
        case MB2Info_Module_type:
            struct MB2Info_Module* Module_TagPTR = (struct MB2Info_Module*)MB2_structure;
            return Module_TagPTR->Size;
            break;
        case MB2Info_BasicRam_type:
            struct MB2Info_BasicRAMInfo* BasicRAMInfo_TagPTR = (struct MB2Info_BasicRAMInfo*)MB2_structure;
            if (BasicRAMInfo_TagPTR->Size != MB2Info_BasicRam_size){
                MB2ParseErrorFlag_WrongTagSize = 1;
                Print_str_lpt("The size of given tag(Basic RAM info)\
                    is wrong \0");
            }
            return BasicRAMInfo_TagPTR->Size;
            break;
        case MB2Info_BIOSBootDevice_type:
            struct MB2Info_BIOSBootDevice* BIOSBootDevice_TagPTR = (struct MB2Info_BIOSBootDevice*)MB2_structure;
            if(BIOSBootDevice_TagPTR->Size != MB2Info_BIOSBootDevice_size){
                MB2ParseErrorFlag_WrongTagSize = 1;
                Print_str_lpt("The size of given multiboot2 tag\
                    (BIOS boot device information)multiboot tag is wrong\0");
            }
            return BIOSBootDevice_TagPTR->Size;
            break;
        case MB2Info_RAMmap_type:
            struct MB2Info_RAMMap* RAMMap_TagPTR = (struct MB2Info_RAMMap*)MB2_structure;
            MB2ParseErrorFlag_RAMMap_IN_C_FUN = 1;
            Print_str_lpt("The RAM map multiboot tag, \
                somehow got to C function \0");
            return RAMMap_TagPTR->Size;
            break;
        case MB2Info_APM_type:
            struct MB2Info_APM* APMtype_TagPTR = (struct MB2Info_APM*)MB2_structure;
            return APMtype_TagPTR->Size;
            break;
        case MB2Info_VBE_type:
            struct MB2Info_VBIOS* VBIOS_TagPTR = (struct MB2Info_VBIOS*)MB2_structure;
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
            MB2ParseErrorFlag_Unknown_Tag_Type = 1;
            return 0;
            break;
    }

    return 0;
}

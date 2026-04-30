#include <stdint.h>

#include "OS_return_codes.h"
#include "multiboot_structures.h"






void* OurBaseAddress;
unsigned char MB2ParseErrorFlag_RAMMap_IN_C_FUN = 0;
unsigned char MB2ParseErrorFlag_Unknown_Tag_Type = 0;
/*return size of structure*/
int Multiboot2_info_main_parser(struct MB2Info_TagHead* MB2_structure){
    uint32_t MB2_type = MB2_structure->Type;

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
        case MB2Info_RAMmap_type:
            struct MB2Info_RAMMap* RAMMap_TagPTR = (struct MB2Info_RAMMap*)MB2_structure;
            MB2ParseErrorFlag_RAMMap_IN_C_FUN = 1;
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
            return -1;
            break;
    }

    return 0;
}
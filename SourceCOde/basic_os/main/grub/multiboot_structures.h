#ifndef MULTRIBOOT_STRUCTURES_NASM_SENTRY
#define MULTRIBOOT_STRUCTURES_NASM_SENTRY

#include <stdint.h>

enum MB2Info_types{


    MB2Info_CMDline_type = 1,

    MB2Info_LoaderName_type = 2,

    MB2Info_Module_type = 3,

    MB2Info_BasicRam_type = 4,
    MB2Info_BasicRam_size = 16,
    
    MB2Info_BIOSBootDevice_type = 5,
    MB2Info_BIOSBootDevice_size = 20,

    MB2Info_RAMmap_type = 6,
    RAMmap_type_FreeRAM = 1,
    RAMmap_type_ACPI = 3,
    RAMmap_type_Hibernation = 4,



    MB2Info_APM_type = 10,
    MB2Info_APMI_size = 28,

    MB2Info_VBE_type = 7,
    MB2Info_VBE_size = 784,

    MB2Info_VRAM_type = 8,

        VRAM_IndexedMode = 0,
        VRAM_RGBMode = 1,
        VRAM_EGAMode = 2,

    MB2Info_ElfSymbols_type = 9,

    MB2Info_UEFI32table_type = 11,
    MB2Info_UEFI32table_fullsize = 12,

    MB2Info_UEFI64table_type = 12,
    MB2Info_UEFI64table_fullsize = 16,

    MB2Info_SMBIOS_type = 13,

    MB2Info_ACPIv1_type = 14,

    MB2Info_ACPIv2_type = 15,

    MB2Info_DHCP_ACK_type = 16,

    MB2Info_UEFI_RAM_MAP_type = 17,

    MB2Info_UEFIBootActive_type = 18,

    MB2Info_UEFI32handle_type = 19,

    MB2Info_UEFI64handle_type = 20,

    MB2Info_BaseAddress_type = 21,

};

struct MB2Info_MainHead{
    uint32_t Total_size;
    uint32_t Reserved;
};

struct MB2Info_TagHead{
    uint32_t Type;
    uint32_t Size;
};


struct MB2Info_BasicRAMInfo{
    uint32_t Type;
    uint32_t Size;
    uint32_t RAMlow_size;
    uint32_t RAMhigh_size;
};


struct MB2Info_CMDline{
    uint32_t Type;
    uint32_t Size;
    char Argument_string[];
};


struct MB2Info_Module{
    uint32_t Type;
    uint32_t Size;
    uint32_t Start;    /*This*/
    uint32_t End;      /*and this are physical addresses*/
    char* Name_string; /*the string*/
};


struct MB2Info_BIOSBootDevice{
    uint32_t Type;
    uint32_t Size;
    uint32_t BIOSDriveNumber;
    uint32_t Partition;
    uint32_t Sub_partition;
};

struct MB2Info_RAMMap{
    uint32_t Type;
    uint32_t Size;
    uint32_t Entry_size;
    uint32_t Entry_version;
    uint32_t Entries_start;
};
struct RAMMap_entry{
    uint64_t Address;
    uint64_t Length;
    uint64_t Type;
    uint64_t Reserved;
};




struct MB2Info_LoaderName{
    uint32_t Type;
    uint32_t Size;
    char* Name_string; /*string*/
};



struct MB2Info_APM{
    uint32_t Type;
    uint32_t Size;
    uint16_t Version;
    uint16_t Cseg;
    uint32_t Offset;
    uint16_t Cseg16;
    uint16_t Dseg;
    uint16_t Flags;
    uint16_t Cseg_len;
    uint16_t Cseg16_len;
    uint16_t Dseg_len;
};



struct   MB2Info_VBIOS{
    uint32_t Type;
    uint32_t Size;
    uint16_t VBEMode;
    uint16_t VBEBIOS_386Interface_segment;
    uint16_t VBEBIOS_386Interface_offset;
    uint16_t VBEBIOS_386Interface_length;
    char VBE_control_info[512];
    char VBE_mode_info[256];
};





struct MB2Info_VRAM{
    uint32_t Type;
    uint32_t Size;
    uint64_t Address;
    uint32_t Pitch;
    uint32_t Width;
    uint32_t Height;
    char BitsPerPixel;
    char VRAM_type;
    char Reserved;
    char ColourInfo_start;
};

    struct palette_colour_RGB;
        struct palette_colour_RGB{
            char Red;
            char Green;
            char Blue;
        };
    struct VRAM_palette_info{
        uint32_t Amount_of_colours;
        struct palette_colour_RGB Colours_array[];/*Basically this array for indexed colour pallette
        that explains what is rgb encodement of every index in pallettes*/
    };

    struct RGBInfo{
        char Red_position;
        char Red_bitness;
        char Green_position;
        char Green_bitness;
        char Blue_position;
        char Blue_bitness; 
    };



struct MB2Info_ElfSymbols{
    uint32_t type;
    uint32_t size;
    uint16_t num;
    uint16_t entsize;
    uint16_t shndx;
    uint16_t reserved;
    char*    Section_Headers;
};

struct MB2Info_UEFI32table{
    uint32_t Type;
    uint32_t Size;
    uint32_t Pointer;
};



struct MB2Info_UEFI64table{
    uint32_t Type;
    uint32_t Size;
    uint64_t Pointer;
};



struct MB2Info_SMBIOS{
    uint32_t Type;
    uint32_t Size;
    char Major;
    char minor;
    char Reserved[6];
    char Tables[];
};



struct MB2Info_ACPIv1{
    uint32_t Type;
    uint32_t Size;
    char* RSDPcopy;/*I guess this is some kind of dynamic sized array*/
};



struct MB2Info_ACPIv2{
    uint32_t Type;
    uint32_t Size;
    char* RSDPcopy;/*I guess this is some kind of dynamic sized array*/
};


struct MB2Info_DHCP_ACK_network{
    uint32_t Type;
    uint32_t Size;
    char* DHCP_ACK;/*I guess this is some kind of dynamic sized array too*/
};


struct MB2Info_UEFI_RAM_MAP{
    uint32_t Type;
    uint32_t Size;
    uint32_t DescriptorSize;
    uint32_t DescriptorVersion;
    char* Map; /*This is an array of RAM map descriptors*/
};




struct MB2Info_UEFIBootActive{
    uint32_t Type;
    uint32_t Size;
};



struct MB2Info_UEFI32handle{
    uint32_t Type;
    uint32_t Size;
    uint32_t pointer;
};



struct MB2Info_UEFI64handle{
    uint32_t Type;
    uint32_t Size;
    uint64_t Pointer;
};



struct MB2Info_BaseAddress{
    uint32_t type;
    uint32_t size;
    uint32_t address;
};




#endif
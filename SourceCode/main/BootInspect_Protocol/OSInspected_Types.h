#ifndef OSINSPECTED_TYPES_H_SENTRY
#define OSINSPECTED_TYPES_H_SENTRY
#include <stdint.h>

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

    Real_RAM_END = 18,
    OtherStrange_RAM = 19
};
struct RAMMap_DescriptorEntry
{
    uint64_t Physical_Address;
    uint64_t Size;
    enum RAMMap_MemoryType Type;
    uint16_t reserved1;
    uint16_t available_bits;
    uint32_t Flag_atributes;
    uint32_t Reserved2;
};



struct BootErrorFlags{
    unsigned char flag0;
    unsigned char flag1;
    unsigned char flag2;
    unsigned char flag3;
    unsigned char flag4;
    unsigned char flag5;
    unsigned char flag6;
    unsigned char flag7;
    unsigned char flag8;
    unsigned char flag9;
    unsigned char flag10;
    unsigned char flag11;
    unsigned char flag12;
    unsigned char flag13;
    unsigned char flag14;
    unsigned char flag15;
    unsigned char flag16;
    unsigned char flag17;
    unsigned char flag18;
    unsigned char flag19;
    unsigned char flag20;
    unsigned char flag21;
    unsigned char flag22;
    unsigned char flag23;
    unsigned char flag24;
    unsigned char flag25;
    unsigned char flag26;
    unsigned char flag27;
    unsigned char flag28;
    unsigned char flag29;
    unsigned char MB2Tag_Unknown;
    unsigned char MB2Tag_Size;
};






struct BasicRamInfo{
    uint32_t LowRam_Amount;
    uint32_t HighRam_Amount;

    uint64_t Last_Address;
    uint64_t FreeRam_Amount;
    uint64_t FreeRam_Above_1MB;
    
    uint32_t MMIO_size;
    uint32_t Reserved_size;
    
    uint32_t UEFI_size;
    uint32_t BadRam_Size;

    uint32_t Other_Types_size;
    uint32_t Reserved1;

    uint64_t Reserved2;
};


enum StringBootArg_EncodingType{
    Empty_String = 0,
    ASCII = 1,
    UTF8  = 2,
    UTF16 = 3,
    UTF32 = 4,
};
struct String_Args{
    uint32_t Size;
    enum StringBootArg_EncodingType Encoding_type; 
    unsigned char* StringPTR;
};


enum LegacyBootInfo_State{
    Not_Present = 0,
    Present = 1,
    IDK = 2,
};
struct LegacyBoot_Info{
    unsigned char BIOS_Booted;

    unsigned char LPT1_State;
    unsigned char LPT2_State;
    unsigned char LPT3_State;
    
    unsigned char COM1_State;
    unsigned char COM2_State;
    unsigned char COM3_State;
    unsigned char COM4_State;//uint64_1

    uint16_t   LPT1_Address;
    uint16_t   LPT2_Address;
    uint16_t   LPT3_Address;
    uint16_t   VGA_Reg_Base;//uin64_2

    uint16_t   COM1_Address;
    uint16_t   COM2_Address;
    uint16_t   COM3_Address;
    uint16_t   COM4_Address;//uint64_3

    unsigned char HDDInfo_state;
    unsigned char BootHDD_ID;
    uint16_t HDD_amount;

    unsigned char Reserved[4];//uint64_4
};






struct BootVarName{
    uint32_t Size;
    enum StringBootArg_EncodingType Encoding_type; 
    unsigned char* StringPTR;
};



enum VRAM_Draw_Type{
    VRAM_IndexedPalette = 0,
    VRAM_TextMode = 1,
    VRAM_RGBbytes = 2,
    VRAM_VGAMode  = 3,
    VRAM_PlanarMode = 4,
};

struct VRAM_RGB_Info{
    unsigned char RGB_R_BitIndex;
    unsigned char RGB_G_BitIndex;
    unsigned char RGB_B_BitIndex;
    uint32_t RGB_R_Bitmask;

    uint32_t RGB_G_Bitmask;
    uint32_t RGB_B_Bitmask;

};



struct VRAM_Info{
    uint64_t Address;
    
    uint32_t Pitch;
    uint32_t Height;

    uint32_t Width;
    enum VRAM_Draw_Type VRAM_Type;

    unsigned char Bytes_P_Pixel;
    unsigned char Reserved1;
    uint16_t   VGA_Mode;
    struct VRAM_RGB_Info* RGB_Info;

};

#endif
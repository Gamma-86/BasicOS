#ifndef OSINSPECTED_TYPES_H_SENTRY
#define OSINSPECTED_TYPES_H_SENTRY
#include <stdint.h>


enum OsInspect_CallCodes{
    CallCode_Test = 0,
    Typed_Panic = 1,
    Custom_Panic =2,
    TestCPUID = 3,
    Get_CPUIDInfo = 4,
    Get_BooterID = 5,
    Custom_AVL6 = 6,
    Custom_AVL7 = 7,

    Get_RAMMap_Size = 8,
    Get_RAMMap = 9,
    Get_Above1MB_RamEntry = 10,
    Get_BasicRamInfo = 11,

    Reserved12 = 12,
    Reserved13 = 13,
    Reserved14 = 14,
    Reserved15 = 15,

    Get_BootErrors = 16,
    Get_BootISAinfo = 17,
    Get_BootEntryName = 18,
    Get_VRAM_info = 19,

    Get_VESA_info = 20,
    Get_PCIBIOS_info = 21,
    Get_BIOS32_info = 22,
    Reserved23 = 23,
    EnvironmentSTRPrint = 24,
    EnvironmentINTPrint = 25,
    Reserved26 = 26,
    Reserved27 = 27,
    Reserved28 = 28,
    EnvPrint_TestVGASupport = 29,
    EnvPrint_TestVRAMSupport = 30,
    Reserved31 = 31,



    Custom_AVL240 = 0xF0,
    Custom_AVL241 = 0xF1,
    Custom_AVL242 = 0xF2,
    Custom_AVL243 = 0xF3,
    Custom_AVL244 = 0xF4,
    Custom_AVL245 = 0xF5,
    Custom_AVL246 = 0xF6,
    Custom_AVL247 = 0xF7,
    Custom_AVL248 = 0xF8,
    Custom_AVL249 = 0xF9,
    Custom_AVL250 = 0xFA,
    Custom_AVL251 = 0xFB,
    Custom_AVL252 = 0xFC,
    Custom_AVL253 = 0xFD,
    Custom_AVL254 = 0xFE,
    Reserved255 = 0xFF,
    End_Boot_Inspection = 0x100
};

int32_t OsBootCall(\
    enum OsInspect_CallCodes CallCode,\
    uint32_t* RetPTR,\
    uint32_t Arg1,\
    uint32_t Arg2,\
    uint32_t Arg3,\
    uint32_t Arg4,\
    uint32_t Arg5,\
    uint32_t Arg6\
);

static inline int32_t Test_CallPresence(\
    enum OsInspect_CallCodes Tested_code,\
    uint32_t RetArg_PTR
    ){
        return OsBootCall(
            CallCode_Test,\
            Tested_code,\
            (uint32_t)&RetArg_PTR,
            0,0,0,0,0\
        );
}


static inline int32_t Full_SelfTest(uint32_t* RetArg_PTR){
    return Test_CallPresence(CallCode_Test, (uint32_t)RetArg_PTR);
}






enum BootInfo_State{
    Not_Present = 0,
    Present = 1,
    IDK = 2,
};


enum Booter_IDs{
    BootedBy_IDK = 0,
    BootedBy_BIOS = 1,
    BootedBy_UEFI32 = 2,
    BootedBy_UEFI64 = 3,
    BootedBy_Multiboot1 = 4,
    BootedBy_Multuboot2 = 5,
    BootedBy_Limine = 6,
    BootedBy_Linux32 = 7,
    BootedBy_Linux64 = 8,
};



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

    BootInspect_RAM = 19,

    OtherStrange_RAM = 20,
};
struct RAMMap_DescriptorEntry
{
    uint64_t Physical_Address;//8b
    uint64_t Size;//16b
    enum RAMMap_MemoryType Type;//20b
    uint16_t reserved1;//22b
    uint16_t available_bits;//24b
    uint32_t Flag_atributes;//28b
    uint32_t Reserved2;//32b
};

struct RAMmap_meta{
    uint32_t Descriptors_Amount;
    uint32_t Reserved1;
    uint32_t Reserved2;
    struct RAMMap_DescriptorEntry* EntriesArray_PTR;
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
    unsigned char MB2Tag_Type;
    unsigned char MB2Tag_Size;
};


struct CPUPresenseInfo{
    unsigned char X87;
    unsigned char MaxCPUIDLeaf;
    unsigned char MMX;
    unsigned char AMD64;
    unsigned char SSE1;
    unsigned char SSE2;
    unsigned char _3DNow;
    unsigned char flag7;
    unsigned char flag8;
    unsigned char flag9;
    unsigned char flag10;
    unsigned char PSE36;
    unsigned char RDRAND;
    unsigned char SysEnter;
    unsigned char PAE;
    unsigned char TSC;
    unsigned char MSR;
};



struct BasicRamInfo{
    uint32_t LowRam_Amount;
    uint32_t HighRam_Amount;//8b

    uint64_t Last_RealByte;//16b
    uint64_t FreeRam_Amount;//24b
    uint64_t FreeRam_Above_1MB;//32b
    
    uint32_t MMIO_size;//36b
    uint32_t ReservedRAM_size;//40b
    
    uint32_t UEFI_size;//44b
    uint32_t BadRam_Size;//48b

    uint32_t Other_Types_size;//52b
    uint32_t Reserved1;//56b

    uint64_t Reserved2;//64b
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
    unsigned char IsPascalSTR;
    unsigned char Reserved[3];
    unsigned char* StringPTR;
};



struct LegacyBoot_Info{
    unsigned char Reserved1;

    unsigned char IDKbout_LPT1;
    unsigned char IDKbout_LPT2;
    unsigned char IDKbout_LPT3;
    
    unsigned char IDKbout_COM1;
    unsigned char IDKbout_COM2;
    unsigned char IDKbout_COM3;
    unsigned char IDKbout_COM4;//uint64_1  8b

    uint16_t   LPT1_Address;
    uint16_t   LPT2_Address;
    uint16_t   LPT3_Address;
    uint16_t   VGA_Reg_Base;//uint64_2  16b

    uint16_t   COM1_Address;
    uint16_t   COM2_Address;
    uint16_t   COM3_Address;
    uint16_t   COM4_Address;//uint64_3  24b

    unsigned char HDDInfo_state;//25
    unsigned char BootHDD_ID;//26
    
    unsigned char Partition;//27
    unsigned char SubPartition;// 28b

    unsigned char Reserved3[4];
    unsigned char Reserved4[32];//64b
};






struct BootVarName{
    uint32_t Size;
    enum StringBootArg_EncodingType Encoding_type;
    uint16_t Available_Bits;
    uint16_t Reserved1;
    unsigned char* StringPTR;
};





enum VRAM_layouts{
    VRAMMode_VGA_VESA  = 0,

    VRAMMode_RGB24_Normal=2,
    VRAMMode_BGR24_Normal=3,
    
    VRAMMode_RGBA32_Normal=4,
    VRAMMode_BGRA32_Normal=5,

    RGB565=6,
    BGR565=7,

    RGBX555=8,
    BGRX555=9,

    RGBA4444=10,
    BGRA4444=11,




    VRAMMode_IndexedPalette = 16,
    VRAMMode_Text = 17,
    VRAMMode_RGB_strange = 18,
    VRAMMode_RGBA_strange = 19,

    VRAMMode_RGB_Planar = 20,
    VRAMMode_RGBA_Planar = 21,

};

struct VRAM_RGB_info{
    unsigned char R_BitIndex;
    unsigned char G_BitIndex;
    unsigned char B_BitIndex;
    unsigned char Reserved1;
    uint32_t R_Bitmask;//8b

    uint32_t G_Bitmask;
    uint32_t B_Bitmask;//16b

};

struct VRAM_RGBA_info{
    unsigned char R_BitIndex;
    unsigned char G_BitIndex;
    unsigned char B_BitIndex;
    unsigned char A_BitIndex;//4b
    uint32_t R_BitMask;//8b

    uint32_t G_BitMask;//12b
    uint32_t B_BitMask;//16b

    uint32_t A_BitMask;//20b
    uint32_t Reserved1;//24b

    uint32_t Reserved2;
    uint32_t Reserved3;//32b
};

struct VRAM_planar_info{
    unsigned char R_index;
    unsigned char G_index;
    unsigned char B_index;
    unsigned char A_index;//4b

    uint32_t Reserved1;//8b

    unsigned char R_BitSize;
    unsigned char G_BitSize;
    unsigned char B_BitSize;
    unsigned char A_BitSize;//12b

    uint32_t Reserved2;//16b
};



struct VRAM_Info{
    uint64_t Address;//8b
    
    uint32_t Pitch;
    uint32_t Height;//16b

    uint32_t Width;
    enum VRAM_layouts VRAM_Type;//24b

    unsigned char Bytes_P_Pixel;
    unsigned char Reserved1;
    uint16_t   VGA_Vesa_Index;
    uint32_t   Reserved2;//32b############

    uint32_t Reserved3;//#################
    uint32_t InterLine_PaddingSize;//40b

    struct VRAM_RGB_info* RGB_Info;
    struct VRAM_RGBA_info* RGBA_Info;//48b

    struct VRAM_planar_info* planar_info;
    uint32_t Reserved4;//56b#####################

    uint64_t Reserved5;//64b#####################
};







struct Segment_descriptor_request{
    void* BASE;//4b
    uint32_t Limit;//8b

    unsigned char Is_Accessed;//9b

    unsigned char Is_EXE;//10b
    unsigned char EXE_Is_readable;//11b
    unsigned char EXE_Is_conforming;//12b

    unsigned char Data_is_writable;//13b
    unsigned char Data_is_E_Down;//14b

    unsigned char Privelege;//15b
    unsigned char IsNot_System;//16b

    unsigned char Is_Available;//17b
    unsigned char Is_64;//18b
    unsigned char IsNot_16;//19b
    unsigned char Is_Granular;//20b

    uint16_t CallGate_Selector;//22b
    unsigned char Arg_Copy_Amount;//23b
    unsigned char System_Type;//24b

    unsigned char Request_done;//25b

    uint16_t TaskGate_TSSSelector;//27b

    unsigned char Is_BootCallGate;//28
    unsigned char Is_BootCallCS;//29
    unsigned char Reserved[2];//31b
};

#define GDT_Requests_Amount 32
#define LDT_Requests_Amount 16


struct FirstSentInfo{
    void (*InitGDT)(uint64_t* TheGDT, struct Segment_descriptor_request* _32Requests);
    void (*InitLDT)(uint64_t* TheLDT, struct Segment_descriptor_request* _16Requests);
    int32_t (*CallsRouter)(enum OsInspect_CallCodes, uint32_t* RetPTR, uint32_t arg1, uint32_t arg2, uint32_t arg3, uint32_t arg4, uint32_t arg5, uint32_t arg6);
};

void Kernel_start(struct FirstSentInfo* Initializaers);









struct APM_info{
    uint16_t Version;//2
    uint16_t C_segmnt32;//4
    uint32_t Offset32;//8

    uint16_t C_segmnt286;//10
    uint16_t D_segmnt286;//12
    uint16_t Flags;//14
    uint16_t Cseg32_limit;//16
    uint16_t Cseg286_limit;//18
    uint16_t Dseg286_limit;//20

    unsigned char Padding[12];
};

struct ACPIV1_info{
    uint32_t Size;
    uint32_t Reserved1;
    uint32_t Reserved2;
    void* Tables_PTR;
};

struct ACPIV2_info{
    uint32_t Size;
    uint32_t Reserved1;
    uint32_t Reserved2;
    void* Tables_PTR;
};




struct PowerManagement_Info{
    enum BootInfo_State APM_state;//4b
    enum BootInfo_State ACPIV1_state;//8b
    enum BootInfo_State ACPIV2_state;//12b
    uint32_t Reserved1;

    struct APM_info* APM_ptr;
    struct ACPIV1_info* ACPIV1_PTR;
    struct ACPIV2_info* ACPIV2_PTR;
    uint32_t Reserved2;
};














struct SMBIOS_Info{
    uint32_t size;//4b
    unsigned char Version_Major;
    unsigned char Version_Minor;
    uint16_t Available_Bits;//8b

    void* Table_PTR;//12b
    uint32_t reserved2;//16b
};


enum PCI_ConfMechanism_Presense{
    BothMechanisms_NotPresent = 0,
    Mechanism1_Present = 1,
    Mechanism12_Present= 2,
    BothMechanisms_Present = 3,
};

struct PCI_Address_BasicInfo{
    unsigned char BusIndex;
    unsigned char DevicesAmount;
};

struct PCI_enum_Info{
    unsigned char MoreDevices_IsPresent;//1b
    unsigned char InfosAmount;
    unsigned char Mechanisms_presence;
    unsigned char Reserved1;//4b
    struct PCI_Address_BasicInfo Busses_BasicInfo[12];//16b
};

/*
struct PCI_BIOS_Info{
    unsigned char IDK[32];
};


struct VESA_BIOS_info{
    unsigned char IDK[32];
};
*/
#endif
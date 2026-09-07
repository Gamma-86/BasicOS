with Interfaces;use Interfaces;
with ExtraTypes;use ExtraTypes;

package BootProtocol is

type CallCodes is 
(
   CallCode_Test,
   Typed_Panic,
   Custom_Panic,
   TestCPUID,
   Get_CPUIDInfo,
   Get_BooterID,
   Custom_AVL6,
   Custom_AVL7,

   Get_RAMMap_Size,
   Get_RAMMap,
   Get_Above1MB_RamEntry,
   Get_BasicRamInfo,

   Reserved12,
   Reserved13,
   Reserved14,
   Reserved15,

   Get_BootErrors,
   Get_BootISAinfo,
   Get_BootEntryName,
   Get_VRAM_info,

   Get_VESA_info,
   Get_PCIBIOS_info,
   Get_BIOS32_info,
   Reserved23,
   EnvironmentSTRPrint,
   EnvironmentINTPrint,
   Reserved26,
   Reserved27,
   Reserved28,
   EnvPrint_TestVGASupport,
   EnvPrint_TestVRAMSupport,
   Reserved31,

   Custom_AVL240,
   Custom_AVL241,
   Custom_AVL242,
   Custom_AVL243,
   Custom_AVL244,
   Custom_AVL245,
   Custom_AVL246,
   Custom_AVL247,
   Custom_AVL248,
   Custom_AVL249,
   Custom_AVL250,
   Custom_AVL251,
   Custom_AVL252,
   Custom_AVL253,
   Custom_AVL254,
   Reserved255,

   End_Boot_Inspection
) with Size => 32;
for CallCodes use
(
    CallCode_Test => 0,
    Typed_Panic => 1,
    Custom_Panic => 2,
    TestCPUID => 3,
    Get_CPUIDInfo => 4,
    Get_BooterID => 5,
    Custom_AVL6 => 6,
    Custom_AVL7 => 7,

    Get_RAMMap_Size => 8,
    Get_RAMMap => 9,
    Get_Above1MB_RamEntry => 10,
    Get_BasicRamInfo => 11,

    Reserved12 => 12,
    Reserved13 => 13,
    Reserved14 => 14,
    Reserved15 => 15,

    Get_BootErrors => 16,
    Get_BootISAinfo => 17,
    Get_BootEntryName => 18,
    Get_VRAM_info => 19,

    Get_VESA_info => 20,
    Get_PCIBIOS_info => 21,
    Get_BIOS32_info => 22,
    Reserved23 => 23,
    EnvironmentSTRPrint => 24,
    EnvironmentINTPrint => 25,
    Reserved26 => 26,
    Reserved27 => 27,
    Reserved28 => 28,
    EnvPrint_TestVGASupport => 29,
    EnvPrint_TestVRAMSupport => 30,
    Reserved31 => 31,



    Custom_AVL240 => 16#F0#,
    Custom_AVL241 => 16#F1#,
    Custom_AVL242 => 16#F2#,
    Custom_AVL243 => 16#F3#,
    Custom_AVL244 => 16#F4#,
    Custom_AVL245 => 16#F5#,
    Custom_AVL246 => 16#F6#,
    Custom_AVL247 => 16#F7#,
    Custom_AVL248 => 16#F8#,
    Custom_AVL249 => 16#F9#,
    Custom_AVL250 => 16#FA#,
    Custom_AVL251 => 16#FB#,
    Custom_AVL252 => 16#FC#,
    Custom_AVL253 => 16#FD#,
    Custom_AVL254 => 16#FE#,
    Reserved255 => 16#FF#,
    End_Boot_Inspection => 16#100#
);


function OsBootCall(
      CallCode:CallCodes;
      RetPTR:ExtraTypes.Unsigned32_PTR;
      Arg2:Unsigned_32;
      Arg3:Unsigned_32;
      Arg4:Unsigned_32;
      Arg5:Unsigned_32;
      Arg6:Unsigned_32;
      Arg7:Unsigned_32)
   return Integer_32;

function Test_CallPresence(
   TestedCall:CallCodes;
   RetInfo:Unsigned32_PTR
   )return Integer_32 with Inline => True;

function Full_SelfTest(RetInfo:Unsigned32_PTR) 
return Interfaces.Integer_32 with Inline=>True;







type InfoState is (
   Not_present,
   Present,
   IDK
) with Size => 8;
for InfoState use (
   Not_present => 0,
   Present => 1,
   IDK => 2
);



type Booter_IDs is 
(
   IDK,
   BIOS,
   UEFI32,
   UEFI64,
   Multiboot1,
   Multiboot2,
   Limine,
   Linux32,
   Linux64
) with Size => 32;
for Booter_IDs use 
(
   IDK => 0,
   BIOS => 1,
   UEFI32 => 2,
   UEFI64 => 3,
   Multiboot1 => 4,
   Multiboot2 => 5,
   Limine => 6,
   Linux32 => 7,
   Linux64 => 8
);

type RAMTypes is
(
   Available,
   ReservedBySomething,
   ACPI,
   ForHibernation,
   Bad,
   EFI_Loader_Code,
   EFI_Loader_Data,
   EFI_Boot_Code,
   EFI_Boot_Data,
   EFI_Runtime_Code,
   EFI_Runtime_Data,
   ACPI_Reclaim,
   ACPI_NVS,

   MMIO,
   PMIO_Ports,
   MotherboardCode,
   EEPROM,

   ReadRAMend,
   BootInspect_RAM,
   OtherStrange
) with Size=>32;
for RAMTypes use 
(
   Available => 1,
   ReservedBySomething => 2,
   ACPI => 3,
   ForHibernation => 4,
   Bad => 5,

   EFI_Loader_Code => 6,
   EFI_Loader_Data => 7,
   EFI_Boot_Code => 8,
   EFI_Boot_Data => 9,
   EFI_Runtime_Code => 10,
   EFI_Runtime_Data => 11,
   ACPI_Reclaim => 12,
   ACPI_NVS => 13,

   MMIO => 14,
   PMIO_Ports => 15,
   MotherboardCode => 16,
   EEPROM => 17,

   ReadRAMend => 18,
   BootInspect_RAM => 19,
   OtherStrange => 20
);


type RAMMap_Entry is record
   Phys_Addrss:Unsigned_64;
   Size:Unsigned_64;
   RAMType : RAMTypes;
   Reserved1 : Interfaces.Unsigned_16;
   Available_bits : Unsigned_16;
   Flag_Attributes : Unsigned_32;
   Reserved2 : Unsigned_32;
end record with Size=>256, Alignment => 16;
for RAMMAp_Entry use record
   Phys_Addrss at 0 range 0 .. 63;
   Size at 8 range 0 .. 63;
   RAMType at 16 range 0 .. 31;
   Reserved1 at 16 range 32 .. 47;
   Available_bits at 16 range 48 .. 63;
   Flag_Attributes at 24 range 0..31;
   Reserved2 at 24 range 32..63;
end record;
type RAMMap_Entry_PTR is access all RAMMap_Entry;

type RAMEntries is array (Positive range <>) of RAMMap_Entry;
type RAMEntries_PTR is access all RAMEntries;

type RAMmap_meta is record
   DescriptorsAmount : Unsigned_32;
   Reserved1 : Unsigned_32;
   Reserved2 : Unsigned_32;
   EntriesPTR : RAMEntries_PTR;
end record with Size => 32, Alignment => 16;
for RAMmap_meta use record
   DescriptorsAmount at 0 range 0 .. 31;
   Reserved1 at 4 range 0 .. 31;
   Reserved2 at 8 range 0 .. 31;
   EntriesPTR at 12 range 0 .. 31;
end record;
type RAMmap_meta_PTR is access all RAMmap_meta; 






type BootErrorFlags is record
   flag0 : Unsigned_8;
   flag1 : Unsigned_8;
   flag2 : Unsigned_8;
   flag3 : Unsigned_8;
   flag4 : Unsigned_8;
   flag5 : Unsigned_8;
   flag6 : Unsigned_8;
   flag7 : Unsigned_8;
   flag8 : Unsigned_8;
   flag9 : Unsigned_8;
   flag10: Unsigned_8;
   flag11: Unsigned_8;
   flag12: Unsigned_8;
   flag13: Unsigned_8;
   flag14: Unsigned_8;
   flag15: Unsigned_8;
   flag16: Unsigned_8;
   flag17: Unsigned_8;
   flag18: Unsigned_8;
   flag19: Unsigned_8;
   flag20: Unsigned_8;
   flag21: Unsigned_8;
   flag22: Unsigned_8;
   flag23: Unsigned_8;
   flag24: Unsigned_8;
   flag25: Unsigned_8;
   flag26: Unsigned_8;
   flag27: Unsigned_8;
   flag28: Unsigned_8;
   flag29: Unsigned_8;
   MB2Tag_Type: Unsigned_8;
   MB2Tag_Size: Unsigned_8;
end record with Alignment => 16, Size => 256, Convention => C;






type CPUPresenseInfo is record
   X87 : Unsigned_8;
   MaxCPUIDLeaf : Unsigned_8;
   MMX : Unsigned_8;
   AMD64 : Unsigned_8;
   SSE1 : Unsigned_8;
   SSE2 : Unsigned_8;
   _3DNow : Unsigned_8;
   flag7 : Unsigned_8;
   flag8 : Unsigned_8;
   flag9 : Unsigned_8;
   flag10: Unsigned_8;
   PSE36 : Unsigned_8;
   RDRAND: Unsigned_8;
   SysEnter: Unsigned_8;
   PAE : Unsigned_8;
   TSC : Unsigned_8;
   MSR : Unsigned_8;
end record with Size => 128, Alignment => 16, Convention => C;

type BasicRAMInfo is record
   LowRAM_size : Unsigned_32;
   HighRAM_size : Unsigned_32;

   Last_RealByte : Unsigned_64;
   FreeRAM_size : Unsigned_64;
   FreeRAM_Above1MB : Unsigned_64;
   MMIO_size : Unsigned_32;
   ReservedRAM_size : Unsigned_32;

   UEFI_size : Unsigned_32;
   BadRAM_size : Unsigned_32;

   OtherTypes_size : Unsigned_32;
   Reserved1 : Unsigned_32;

   Reserved2 : Unsigned_64;
end record with Size => 512, Alignment => 16, Convention => C;







type STR_encodings is (
   Empty,
   ASCII,
   UTF8,
   UTF16,
   UTF32
) with Size => 32;
for STR_encodings use(
   Empty => 0,
   ASCII => 0,
   UTF8 => 0,
   UTF16 => 0,
   UTF32 => 0,
);
type String_Args is record
   Size : Unsigned_32;
   EncodeType : STR_encodings;
   IsPascalSTR : Boolean;
   Reserved1 : Unsigned_8Z;
   Reserved2 : Unsigned_8Z;
   Reserved3 : Unsigned_8Z;
   TheString : Interfaces.C.Strings.chars_ptr;
end record with Size => 16, Alignment => 16;
for String_Args use record
   Size at 0 range 0 .. 31;
   EncodeType at 4 0 .. 31;

   IsPascalSTR at 8 0 .. 7;
   Reserved1 at 9 0 .. 7;
   Reserved2 at 10 0 .. 7;
   Reserved3 at 11 0 .. 7;

   TheString at 12 0 .. 31;
end record;








type Reserved_Array is array (0..31) of Unsigned_8Z;


type ISA_Boot_info is record
   Reserved1 : Unsigned_8Z;

   IDKbout_LPT1 : Boolean;
   IDKbout_LPT2 : Boolean;
   IDKbout_LPT3 : Boolean;

   IDKbout_COM1 : Boolean;
   IDKbout_COM2 : Boolean;
   IDKbout_COM3 : Boolean;
   IDKbout_COM4 : Boolean;

   LPT1_Address : Unsigned_16;
   LPT2_Address : Unsigned_16;
   LPT3_Address : Unsigned_16;
   VGA_Reg_Base : Unsigned_16;

   COM1_Address : Unsigned_16;
   COM2_Address : Unsigned_16;
   COM3_Address : Unsigned_16;
   COM4_Address : Unsigned_16;

   HDDInfo_State : InfoState;
   BootHDD_BIOS_ID : Unsigned_8;

   Partition : Unsigned_8;
   SubPartition : Unsigned_8;

   Reserved2 : Unsigned_32Z;
   Reserved3 : Reserved_Array;

end record;





type BootMenuOSName is record
   Size : Unsigned_32;
   EncodeType : STR_encodings;
   Available_bits : Unsigned_16;
   Reserved1 : Unsigned_16Z;
   TheString : Interfaces.C.Strings.chars_ptr
end record with Size => 128, ALignment => 16;
for BootMenuOSName use record
   Size at 0 range 0 .. 31;
   EncodeType at 4 range 0 .. 31;
   Available_bits at 6 range 0 .. 15;
   Reserved1 at 8 range 0 .. 15;
   TheString at 12 range 0 ..31;
end record





end BootProtocol;
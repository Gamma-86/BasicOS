with Interfaces;use Interfaces;
with ExtraTypes;use ExtraTypes;
with System;
with X86_segments;
with X86_segments.LDT;

--    THIS is a full description of types and some function present in my boot
--protocol that can send information at runtime or at elf file requests
--it preserves all BIOS information if used natively(not as protocol translator)
--BIOS information means BIOS data area and BIOS interrupts and whatever else
--BIOS has.



--1   Sent opcodes to BootCalls to get info about thing end
--2   Function to call through the call gate to get information
--       I think you probably should implement callgate caller yourself
-- 2.1   Test_CallPresense - call gate wrapper
-- 2.2   FUll_Selftest call gate wrapper
-- 2.3
--3   Logic type about Info state of something
--4   type Booter IDs, IDs of by who you were booted
--       Also includes protocl that Boot inspector translated
--5   RAM MAP description information and types
-- 5.1   RAM region descriptor record
-- 5.2   RAMMap_entry pointer
-- 5.3   RAm entries  array
-- 5.4   RAM entrues array pointer
-- 5.5   RAM descriptors and their meta record
--6   BootErrorFlags record
--7   information record about CPUID and its bits
--8   Basic information about RAM info
--9   String encoding types
--10  OS given arguments when launched

--11 ISA information
-- 11.1 array of zero bytes
-- 11.2 Information about ISA devices

--12 OS name in boot menu

--11  VRAM information
-- 11.1  VRAM pixel in ram layour type
-- 11.2  VRAM RGB type pixel layout information record
-- 11.3  VRAM RGBA type pixel layout information record
-- 11.4  VRAM planar type pixel layour information record
-- 11.10  Final VRAM info record
-- 11.11  VRAM full info pointer type

--20 Segment descriptor request record
-- 20.1 Segment descripto request pointer
-- 20.2 GDT requests constant amount
-- 20.3 GDT_Requests start index in GDT
-- 20.4 GDT requests range in array
-- 20.5 GDT_requests array
-- 20.6 GDT requests Array pointer

-- 20.10 LDT_requests constant amount
-- 20.11 LDT_Requests copying start index in LDT
-- 20.12 LDT_requests index in array range
-- 20.13 LDT requests array
-- 20.14 LDT Requests array pointer

-- 20.20 Pointer to the funciton to initialize GDT
-- 20.21 Pointer to the function to initialize LDT

-- 21 pointer to direct BootCall fucntion 

--30 first sent info to kernel entry point structure record
-- 30.1 FIrst sent info record
-- 30.2 First sent info record pointer, that is the thing sent to kernel entry

--40 APM infofmation record, should be researched more
--40.1 APM info pointer type

--50 ACPIV1 information record , should be researched more
--50.1 ACPIV1 information pointer

--60 ACPIV2 information record, should be researched more
--60.1 ACPIV2 record pointer

--64 Power management full info including APM, ACPI
--64.1 Power management info pointer

--70 SMBIOS information record ; requires further study in topic
--70.1 SMBIOS info record pointer

--80 PCI information
-- 80.1 PCI configuration mechanisms #1,2 presense enumearation type 
-- 80.2 PCI bus(by bus i mean the bits in PCI address) amount of devices on it information

-- 80.3 array of PCI busses inforamtion entries
-- 80.4 PCI basic enumeration info showing if PCI #1,2 present and how 
--    some busses and how many devices present on them



--############################################################################
--############################################################################
--############################################################################
--
--
--
--############################################################################
--############################################################################
--############################################################################

package BootProtocol is





--############################################################################
--############################################################################
--############################################################################
--
--    1 - BootCall Opcodes
--
--############################################################################
--############################################################################
--############################################################################

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

   Get_ISA_IDE_info,
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

    Get_ISA_IDE_info => 12,
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

--############################################################################
--############################################################################
--############################################################################
--
--    2 Function to call call gate wrapper
--
--############################################################################
--############################################################################
--############################################################################

function OsBootCallGate(
      CallCode:CallCodes;
      RetPTR:ExtraTypes.Unsigned32_PTR;
      Arg1:Unsigned_32;
      Arg2:Unsigned_32;
      Arg3:Unsigned_32;
      Arg4:Unsigned_32;
      Arg5:Unsigned_32;
      Arg6:Unsigned_32)
   return Integer_32 with Convention => C;

--############################################################################
-- 2.1 test call presense
--############################################################################

function Test_CallPresence(
   TestedCall:CallCodes;
   RetInfo:Unsigned32_PTR
   )return Integer_32 with Inline => True;

--############################################################################
-- 2.2 perform full self test
--############################################################################

function Full_SelfTest(RetInfo:Unsigned32_PTR) 
return Interfaces.Integer_32 with Inline=>True;






--############################################################################
--############################################################################
--############################################################################
--
--    3 logic info state
--
--############################################################################
--############################################################################
--############################################################################

type InfoStates is (
   Not_present,
   Present,
   IDK
) with Size => 8;
for InfoStates use (
   Not_present => 0,
   Present => 1,
   IDK => 2
);


--############################################################################
--############################################################################
--############################################################################
--
--    4 who u were booted by IDs
--
--############################################################################
--############################################################################
--############################################################################

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
--############################################################################
--############################################################################
--############################################################################
--
--    5 RAM region types
--
--############################################################################
--############################################################################
--############################################################################

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

--############################################################################
--############################################################################
--############################################################################
--
--  5 THE RAM MAP
--
--############################################################################
--############################################################################
--############################################################################

--############################################################################
--    5.1 RAM region descriptor
--############################################################################
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
--############################################################################
--    5.2
--############################################################################
type RAMMap_Entry_PTR is access all RAMMap_Entry;

--############################################################################
--    5.3
--############################################################################
type RAMEntries is array (Positive range <>) of RAMMap_Entry;

--############################################################################
--    5.4
--############################################################################
type RAMEntries_PTR is access all RAMEntries;

--############################################################################
--    5.5
--############################################################################
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





--############################################################################
--############################################################################
--############################################################################
--
--    6 Boot and translation errors
--
--############################################################################
--############################################################################
--############################################################################

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

--############################################################################
--############################################################################
--############################################################################
--
--    7 CPUID information
--
--############################################################################
--############################################################################
--############################################################################
type CPUPresenseInfo is record
   X87 : Unsigned_8;
   MaxCPUIDLeaf : Unsigned_8;
   MMX : Unsigned_8;
   AMD64 : Unsigned_8;
   SSE1 : Unsigned_8;
   SSE2 : Unsigned_8;
   A_3DNow : Unsigned_8;
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







--############################################################################
--############################################################################
--############################################################################
--
--    8 Basic RAM information
--
--############################################################################
--############################################################################
--############################################################################
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



--############################################################################
--############################################################################
--############################################################################
--
--    9 String encoding types
--
--############################################################################
--############################################################################
--############################################################################

type STR_encodings is (
   Empty,
   ASCII,
   UTF8,
   UTF16,
   UTF32
) with Size => 32;
for STR_encodings use(
   Empty => 0,
   ASCII => 1,
   UTF8 => 2,
   UTF16 => 3,
   UTF32 => 4
);

--############################################################################
--############################################################################
--############################################################################
--
--    10 OS launch CLI arguments
--
--############################################################################
--############################################################################
--############################################################################


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
   EncodeType at 4 range 0 .. 31;

   IsPascalSTR at 8 range 0 .. 7;
   Reserved1 at 9 range 0 .. 7;
   Reserved2 at 10 range 0 .. 7;
   Reserved3 at 11 range 0 .. 7;

   TheString at 12 range 0 .. 31;
end record;







--############################################################################
--############################################################################
--############################################################################
--
--    11 ISA information
--
--############################################################################
--############################################################################
--############################################################################

--############################################################################
--    11.1 reserved array of bytes
--############################################################################

type Reserved_Array is array (0..31) of Unsigned_8Z;

--############################################################################
--    11.2 Information about industry standart architecture devices
--############################################################################

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

   HDDInfo_State : InfoStates;
   BootHDD_BIOS_ID : Unsigned_8;

   Partition : Unsigned_8;
   SubPartition : Unsigned_8;

   Reserved2 : Unsigned_32Z;
   Reserved3 : Reserved_Array;
end record;




--############################################################################
--############################################################################
--############################################################################
--
--    12 OS name in boot menu
--
--############################################################################
--############################################################################
--############################################################################

type BootMenuOSName is record
   Size : Unsigned_32;
   EncodeType : STR_encodings;
   Available_bits : Unsigned_16;
   Reserved1 : Unsigned_16Z;
   TheString : Interfaces.C.Strings.chars_ptr;
end record with Size => 128, ALignment => 16;
for BootMenuOSName use record
   Size at 0 range 0 .. 31;
   EncodeType at 4 range 0 .. 31;
   Available_bits at 6 range 0 .. 15;
   Reserved1 at 8 range 0 .. 15;
   TheString at 12 range 0 ..31;
end record;


--############################################################################
--############################################################################
--############################################################################
--
--    12 VRAM information
--
--############################################################################
--############################################################################
--############################################################################

--############################################################################
--    11.1 pixel storing types
--############################################################################
type VRAM_layouts is
(
   VGA_VESA,
   
   RGB24_Normal,
   BGR24_Normal,
   
   RGBA32_Normal,
   BGRA32_Normal,

   RGB565,
   BGR565,

   RGBX555,
   BGRX555,

   RGBA4444,
   BGRA4444,



   IndexedPalette,
   Text,
   RGB_Strange,
   RGBA_Strange,

   RGB_Planar,
   RGBA_Planar
) with Size => 32;
for VRAM_layouts use
(
   VGA_VESA => 0,

   RGB24_Normal => 2,
   BGR24_Normal => 3,

   RGBA32_Normal => 4,
   BGRA32_Normal => 5,

   RGB565 => 6,
   BGR565 => 7,

   RGBX555 => 8,
   BGRX555 => 9,

   RGBA4444 => 10,
   BGRA4444 => 11,

   IndexedPalette => 16,
   Text => 17,
   RGB_Strange => 18,
   RGBA_Strange => 19,

   RGB_Planar => 20,
   RGBA_Planar => 21
);








--############################################################################
--    11.2 VRAM RGB layour information
--############################################################################

type VRAM_RGB_info is record
   R_BitIndex : Unsigned_8;
   G_BitIndex : Unsigned_8;
   B_BitIndex : Unsigned_8;
   Reserved1 : Unsigned_8Z;

   R_Bitmask : Unsigned_32;
   G_Bitmask : Unsigned_32;
   B_Bitmask : Unsigned_32;
end record with Alignment=>16, Size=>128;
for VRAM_RGB_info use record
   R_BitIndex at 0 range 0..7;
   G_BitIndex at 1 range 0..7;
   B_BitIndex at 2 range 0..7;
   Reserved1 at 3 range 0..7;

   R_Bitmask at 4 range 0..31;
   G_Bitmask at 8 range 0..31;
   B_Bitmask at 12 range 0..31;
end record;
type VRAM_RGB_info_PTR is access all VRAM_RGB_info;



--############################################################################
--    11.3 RGBA layout
--############################################################################

type VRAM_RGBA_info is record
   R_BitIndex : Unsigned_8;
   G_BitIndex : Unsigned_8;
   B_BitIndex : Unsigned_8;
   A_BitIndex : Unsigned_8;

   R_BitMask  : Unsigned_32;
   G_BitMask  : Unsigned_32;
   B_BitMask  : Unsigned_32;
   A_BitMask  : Unsigned_32;

   Reserved1  : Unsigned_32Z;
   Reserved2  : Unsigned_32Z;
   Reserved3  : Unsigned_32Z;
end record with Alignment => 16, Size => 256;
for VRAM_RGBA_info use record
   R_BitIndex at 0 range 0 .. 7;
   G_BitIndex at 1 range 0 .. 7;
   B_BitIndex at 2 range 0 .. 7;
   A_BitIndex at 3 range 0 .. 7;

   R_BitMask at 4 range 0 .. 31;
   G_BitMask at 8 range 0 .. 31;
   B_BitMask at 12 range 0 .. 31;
   A_BitMask at 16 range 0 .. 31;

   Reserved1 at 20 range 0 .. 31;
   Reserved2 at 24 range 0 .. 31;
   Reserved3 at 28 range 0 .. 31;
end record;
type VRAM_RGBA_info_PTR is access all VRAM_RGBA_info;



--############################################################################
--    11.4 planar layout
--############################################################################

type VRAM_planar_info is record
   R_index : Unsigned_8;
   G_index : Unsigned_8;
   B_index : Unsigned_8;
   A_index : Unsigned_8;

   Reserved1 : Unsigned_32Z;

   R_BitSize : Unsigned_8;
   G_BitSize : Unsigned_8;
   B_BitSize : Unsigned_8;
   A_BitSize : Unsigned_8;

   Reserved2 : Unsigned_32;
end record with Alignment => 16, Size => 128, Convention => C;
type VRAM_planar_info_PTR is access all VRAM_planar_info;



--############################################################################
--    11.10 Final VRAM information compilation
--############################################################################

type VRAM_Info is record
   Address : Unsigned_64;

   Pitch : Unsigned_32;
   Height: Unsigned_32;

   Width : Unsigned_32;
   VRAM_type : VRAM_layouts;

   Bytes_P_pixel : Unsigned_8;
   Reserved1 : Unsigned_8Z;
   VGA_VESA_mode : Unsigned_16;
   Reserved2 : Unsigned_32Z;

   Reserved3 : Unsigned_32Z;
   InterLine_PaddingSize : Unsigned_32;

   RGB_info : VRAM_RGB_info_PTR;
   RGBA_info : VRAM_RGBA_info_PTR;

   planar_info : VRAM_planar_info_PTR;
   Reserved4 : Unsigned_32Z;

   Reserved5 : Unsigned_64Z;
end record with Convention=>C, Alignment=>16;
for VRAM_Info use record
   Address at 0 range 0 .. 63;

   Pitch at 8 range 0 .. 31;
   Height at 12 range 0 .. 31;

   Width at 16 range 0 .. 31;
   VRAM_type at 20 range 0 .. 31;

   Bytes_P_pixel at 24 range 0 .. 7;
   Reserved1 at 25 range 0 .. 7;
   VGA_VESA_mode at 26 range 0 .. 15;
   Reserved2 at 28 range 0 .. 31;

   Reserved3 at 32 range 0 .. 31;
   InterLine_PaddingSize at 36 range 0 .. 31;

   RGB_info at 40 range 0 .. 31;
   RGBA_info at 44 range 0 .. 31;
   planar_info at 48 range 0 .. 31;
   Reserved4 at 52 range 0 .. 31;

   Reserved5 at 56 range 0 .. 63;
end record;
--############################################################################
--    11.11 VRAM info pointer
--############################################################################

type VRAM_Info_PTR is access all VRAM_Info;








--############################################################################
--############################################################################
--############################################################################
--
--    SEGMENT DESCIRPTOR REQUEST
--
--############################################################################
--############################################################################
--############################################################################

type Segment_descriptor_request is record
   BASE : System.Address;
   Limit : Unsigned_32;

   Is_Accessed : Boolean;

   Is_EXE : Boolean;
   EXE_Readable : Boolean;
   EXE_Conforming : Boolean;

   Data_Writable : Boolean;
   Data_Is_E_Down : Boolean;

   Privelege : X86_segments.Privelege_LVL_t;
   IsNot_System : Boolean;

   Is_Available : Boolean;
   Is_64 : Boolean;
   IsNot_16 : Boolean;
   Is_Granular : Boolean;

   CallGate_Selector : X86_segments.Segment_Selector;
   Argum_Copy_Amount : Integer range 0..31;
   System_Type : X86_segments.SystemTypes_t;

   Request_done : Boolean;
   TaskGate_TSSSelector : X86_segments.Segment_Selector;

   Is_BootCallGate : Boolean;
   Is_BootCallCS : Boolean;

   Reserved : Unsigned_16Z;
end record with Alignment => 16, Size => 256;
--############################################################################
--    20.1 Request pointer
--############################################################################
type Segment_descriptor_request_PTR is access all Segment_descriptor_request;


--############################################################################
--    20.2,3,4,5,6,7 GDT requests information
--############################################################################

GDT_Requests_Amount : constant Integer := 32;
GDT_Requests_Start  : constant Integer := 0;
subtype GDT_Requests_Range is Integer range 0 .. 31;
type GDT_Requests_Array is array(GDT_Requests_Range) of Segment_descriptor_request;
type GDT_Requests_Array_PTR is access all GDT_Requests_Array;

--############################################################################
--    20.10,11,12,13,14 LDT requests information
--############################################################################

LDT_Requests_Amount : constant Integer := 16;
LDT_Requests_Start  : constant Integer := 16;
subtype LDT_Requests_Range is Integer range 0 .. 16;
type LDT_Requests_Array is array(LDT_Requests_Array) of Segment_descriptor_request;
type LDT_Requests_Array_PTR is access all LDT_Requests_Array;

--############################################################################
--    20.20 Initialize GDT from requests pointer
--############################################################################
type InitGDT_PTR is access procedure (TheGDT : X86_segments.GDT_t_PTR; Requests32 : GDT_Requests_Array_PTR)
   with Convention => C;
--############################################################################
--    20.21 Initialize LDT from requests pointer
--############################################################################
type InitLDT_PTR is access procedure (TheLDT : X86_segments.LDT.LDT_t_PTR; Requests16 : LDT_Requests_Array_PTR)
   with Convention => C;

--############################################################################
--    21 GET boot information function directly(not call gate)
--############################################################################
type OsCallsDirect_PTR is access function (
   CallCode:CallCodes;
   RetPTR:ExtraTypes.Unsigned32_PTR;
   Arg1:Unsigned_32;
   Arg2:Unsigned_32;
   Arg3:Unsigned_32;
   Arg4:Unsigned_32;
   Arg5:Unsigned_32;
   Arg6:Unsigned_32)
return Integer_32 with Convention => C;





--############################################################################
--############################################################################
--############################################################################
--
--    30 The information sent to the kernel entry point
--
--############################################################################
--############################################################################
--############################################################################

--############################################################################
--    30.1 the record of first sent info
--############################################################################

type FirstSentInfo is record
   InitGDT : InitGDT_PTR;
   InitLDT : InitLDT_PTR;
   DirectBootCall : OsCallsDirect_PTR;
   IDK : Unsigned_32;
end record with Size => 128;
for FirstSentInfo use record
   InitGDT at 0 range 0 .. 31;
   InitLDT at 4 range 0 .. 31;
   DirectBootCall at 8 range 0 .. 31;
   IDK at 12 range 0 .. 31;
end record;
--############################################################################
--    30.2 first sent info to the kernel pointer
--############################################################################
type FirstSentInfo_PTR is access all FirstSentInfo;



--############################################################################
--############################################################################
--############################################################################
--
--    40 APM information reocrd
--
--############################################################################
--############################################################################
--############################################################################
type APM_info is record
   Version : Unsigned_16;
   C_segmnt32 : Unsinged_32;
   Offset32 : Unsigned_32;

   C_segmnt286 : Unsigned_16;
   D_segmnt286 : Unsigned_16;
   Flags : Unsigned_16;
   Cseg32_limit : Unsigned_16;
   Cseg286_limit : Unsigned_16;
   Dseg286_limit : Unsigned_16;

   Reserved1 : Unsigned_64Z;
   Reserved2 : Unsigned_32Z;
end record with Alignment => 16, Size => 256;
for APM_info use record
   Version at 0 range 0 .. 15;--2
   C_segmnt32 at 2 range 0 .. 15;--4
   Offset32 at 4 range 0 .. 31;--8

   C_segmnt286 at 8 range 0 .. 15;--10
   D_segmnt286 at 10 range 0 .. 15;--12
   Flags at 12 range 0 .. 15;--14
   Cseg32_limit at 14 range 0 .. 15;
   Cseg286_limit at 16 range 0 .. 15;
   Dseg286_limit at 18 range 0 .. 15;

   Reserved1 at 20 range 0 .. 63;
   Reserved2 at 28 range 0 .. 31;
end record;
--############################################################################
--  40.1 its pointer
--############################################################################
type APM_info_PTR is access all APM_info;



--############################################################################
--############################################################################
--############################################################################
--
--    50 ACPI V1 information record
--
--############################################################################
--############################################################################
--############################################################################

type ACPIV1_info is record
   Size : Unsigned_32;
   Reserved1 : Unsigned_32Z;
   Reserved2 : Unsigned_32Z;
   Tables_PTR : System.Address;
end record with Size => 128, Alignment => 16;
for ACPIV1_info use record
   Size at 0 range 0 .. 31;
   Reserved1 at 4 range 0 .. 31;
   Reserved2 at 8 range 0 .. 31;
   Tables_PTR at 12 range 0 .. 31;
end record;
--############################################################################
--    50.1 its pointer
--############################################################################
type ACPIV1_info_PTR is access all ACPIV1_info;








--############################################################################
--############################################################################
--############################################################################
--
--    60 ACPI V2 information record
--
--############################################################################
--############################################################################
--############################################################################
type ACPIV2_info is record
   Size : Unsigned_32;
   Reserved1 : Unsigned_32;
   Reserved2 : Unsigned_32;
   Tables_PTR : System.Address;
end record with Size => 128, Alignment => 16;
for ACPIV2_info use record
   Size at 0 range 0 .. 31;
   Reserved1 at 4 range 0 .. 31;
   Reserved2 at 8 range 0 .. 31;
   Tables_PTR at 12 range 0 .. 31;
end record;
--############################################################################
--    60.1 Its pointer
--############################################################################
type ACPIV2_info_PTR is access all ACPIV2_info;





--############################################################################
--############################################################################
--############################################################################
--
--    64 Power management information record
--
--############################################################################
--############################################################################
--############################################################################
type PowerManagemet_Info is record
   APM_state : InfoStates;
   ACPIV1_state : InfoStates;
   ACPIV2_state : InfoStates;
   Reserved1 : Unsigned_32Z;

   APM : APM_info_PTR;
   ACPIV1 : ACPIV1_info_PTR;
   ACPIV2 : ACPIV2_info_PTR;
   Reserved2 : Unsigned_32Z;
end record with Size => 256, Alignment => 16;
for PowerManagemet_Info use record
   APM_state at 0 range 0 .. 31;
   ACPIV1_state at 4 range 0 .. 31;
   ACPIV2_state at 8 range 0 .. 31;
   Reserved1 at 12 range 0 .. 31;

   APM at 16 range 0 .. 31;
   ACPIV1 at 20 range 0 .. 31;
   ACPIV2 at 24 range 0 .. 31;
   Reserved2 at 28 range 0 .. 31;
end record;
--############################################################################
--    64.1 its pointer
--############################################################################
type PowerManagemet_Info_PTR is access all PowerManagemet_Info;





--############################################################################
--############################################################################
--############################################################################
--
--    70 SMBIOS information record
--
--############################################################################
--############################################################################
--############################################################################
type SMBIOS_Info is record
   Size : Unsigned_32;
   Version_Major : Unsigned_8;
   Version_Minor : Unsigned_8;
   Available_bits: Unsigned_16;

   SMBIOS_PTR : System.Address;
   Reserved2 : Unsigned_32;
end record with Size => 128, Alignment => 16;
for SMBIOS_Info use record
   Size at 0 range 0 .. 31;
   Version_Major at 4 range 0 .. 7;
   Version_Minor at 5 range 0 .. 7;
   Available_bits at 6 range 0 .. 15;

   SMBIOS_PTR at 8 range 0 .. 31;
   Reserved2 at 12 range 0 .. 31;
end record;
--############################################################################
--    its pointer
--############################################################################
type SMBIOS_Info_PTR is access all SMBIOS_Info;









--############################################################################
--############################################################################
--############################################################################
--
--    80 PCI information
--
--############################################################################
--############################################################################
--############################################################################

--############################################################################
--    80.1 PCI #1,2 mechanisms presense type
--############################################################################

type PCI_ConfMechanisms_Presense is 
(
   Both_NotPresent,
   Mech1_present,
   Mech2_present,
   Both_Present
) with Size => 8;
for PCI_ConfMechanisms_Presense use 
(
   Both_NotPresent => 0,
   Mech1_present => 1,
   Mech2_present => 2,
   Both_Present => 3
);


--############################################################################
--    80.2 PCI signle bus info entry
--############################################################################

type PCI_Address_BasicInfo is record
   BusIndex : Unsigned_8;
   Devices_Amount : Unsigned_8;
end record with Size => 16, Convention=>C;
--############################################################################
--    80.3 the array of them
--############################################################################
type Busses_BasicInfo is array(0..11) of PCI_Address_BasicInfo;

--############################################################################
--    80.4 PCI enumaration information and other PCI stuff
--############################################################################
type PCI_enum_Info is record
   MoreDevices_Present : Boolean;
   InfosAmount : Unsigned_8;
   Mechanisms_state : PCI_ConfMechanisms_Presense;
   Reserved1 : Unsigned_8Z;
   Busses_Info : Busses_BasicInfo;
end record with Size => 128, Alignment => 16;
for PCI_enum_Info use record
   MoreDevices_Present at 0 range 0 .. 7;
   InfosAmount at 1 range 0 .. 7;
   Mechanisms_state at 2 range 0 .. 7;
   Reserved1 at 3 range 0 .. 7;

   Busses_Info at 4 range 0 .. 96;
end record;





end BootProtocol;
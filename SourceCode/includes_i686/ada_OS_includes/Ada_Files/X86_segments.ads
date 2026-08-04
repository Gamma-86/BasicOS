--The x86 has segmentation
--This file describes data types required for segmentation
--You can use data types in this file to interact with segmentation Memory
--Protection mechanisms, but there are also other fancy stuff that x86 offer
--10 Type Always 0/1 Boolean 
--20 Type Privelege LVL

--30 Type Base Low/High(Separation of 32 bit pointer to 24/8 bit unsigned)
--30.10 Record Type Base Separated
--30.11 Type Pointer that points to Base Separated record
--30.20 function To Separate Raw Pointer(void*) into Separate High/Low record
--30.30 function to Glue High/Low Address in record 
--   into 1 System.Address(void*)


--40 Type Limit Low/High
--40.10 Record Type Limit_separated made out of Low/Hish Limits
--40.11 Pointer Type that points to Limit Separated
--40.20 Function To Divide Unsigned into High/Low parts record
--40.30 Function To Glue the High/Low record into 1 Unsgined number

--50 System Types enumeration that can be in TYPE filed of system descriptor
--50.9  A Subtypes that are system, but cannot be in GDT
--50.10 Enumeration of system types that can be in GDT
--50.20 Subtypes of GDT System Type that are very specific for certain system
--    segments

--60 Type Access Byte (from Typical segment descriptor)

--70 Record Type Segment_Descriptor_Raw, the most generic Descriptor reasonable
--70.9 Pointer to the GDT_Descriptor_RAW
--70.10 Unchecked conversion function between unsigned64 and GDT_Descriptor Raw

--80 Record Type for GDT descriptor fourth word of NonSystem(Data Or COde) descriptor

--90 Record Type Segment descriptor for code
--90.9 Pointer to the Code segment descriptor
--90.10 Unsigned64<->DescriptorCOde<->DescriptorRAW  Unchecked conversion

--100 Record Type - Segment descriptor for DATA
--100.9 Pointer to the DATA descriptor
--100.10 DescriptorRaw<->DescriptorData<->Unsigned64 Unchecked conversions

--110 Integer Type segment Index, which is index in GDT with range 
--    of Max/Min possible segment Index

--120 Record Type - Segment Selector, a CPU way to access segments themselves
--120.10 Unchecked conversions between segment selector and Unsigned16

--130 Record Type - Call Gate 32, one of possible system calls ways
--130.9 Type - Pointer to the CALL GATE 32
--130.10 DescriptorRAW<->Call Gate 32<->Unsigned 64 unchecked conversions


--150 GDT_t, GDT_t_PTR : the man himself
--150.10 GDT_Descriptor and GDT_Descriptor pointer


--#######################################################
--#######################################################
--
--
--
--#######################################################
--#######################################################

--#######################################################
--
--#######################################################


with Interfaces;
with Interfaces.C;
with Ada.Unchecked_Conversion;
with System.Storage_Elements;--For Pointer arithmetic
with System;--For Raw pointers(Void*)
package X86_segments is
--#######################################################
--#######################################################
--
--        10 
--
--#######################################################
--#######################################################

   subtype Always_0Bool_t is Boolean range False .. False;
   subtype Always_1Bool_t is Boolean range True .. True;

--#######################################################
--#######################################################
--
--  20
--
--#######################################################
--#######################################################

   type Privelege_LVL_t is mod 2 ** 2
      with Size => 2;
      for Privelege_LVL_t'Size use 2;


--#######################################################
--#######################################################
--
--    30
--
--#######################################################
--#######################################################

   type Base_Low_t is mod 2 ** 24
      with Size => 24;
      for Base_Low_t'Size use 24;
   type Base_High_t is mod 2 ** 8
      with Size => 8;
      for Base_High_Type'Size use 8;
--#######################################################
--    30.10
--#######################################################

   type Base_Separated_r is record
      Base_Low : Base_Low_t;
      Base_High : Base_High_t;
   end record
   with Size => 32;
   for Base_Separated_r use record
      Base_Low at 0 range 0 .. 23;
      Base_High at 0 range 24 .. 31;
   end record;
   for Base_Separated_r'Size use 32;
--#######################################################
--    30.11
--#######################################################
   type Base_Separated_r_PTR is access all Base_Separated_r;
--#######################################################
--    30.20
--#######################################################
function Separate_BaseAddress32 (The_Address : System.Address) return Base_Separated_r_PTR;
--#######################################################
--    30.30
--#######################################################
function Glue_BaseAddress32 (Separated_Address : Base_Separated_r) return System.Address;


--#######################################################
--#######################################################
--
--    40
--
--#######################################################
--#######################################################

   type Limit_Low_t is mod 2 ** 16
      with Size => 16;
      for Limit_Low_t'Size use 16;
   type Limit_High_t is mod 2 ** 4
      with Size => 4;
      for Limit_High_t'Size use 4;

--#######################################################
--    40.10
--#######################################################

   type Limit_Separated_r is record
      Limit_Low : Limit_Low_t;
      Limit_High : Limit_High_t;
   end record with Size => 20;
   for Limit_Separated_r use record
      Limit_Low at 0 range 0 .. 15;
      Limit_High at 0 range 16 .. 19;
   end record;
   for Limit_Separated_r'Size use 20;
--#######################################################
--    40.11
--#######################################################
   type Limit_Separated_r_PTR is access all Limit_Separated_r;

--#######################################################
--    40.20
--#######################################################
function Separate_SegmentLimit (Limit : Interfaces.Unsigned_32) return Limit_Separated_r_PTR;
--#######################################################
--    40.30
--#######################################################
function Glue_SegmentLimit(Separated_Record_PTR : Limit_Separated_r_PTR) return Interfaces.Unsigned_32;






--#######################################################
--#######################################################
--
--    50
--
--#######################################################
--#######################################################



   type SystemTypes_t is 
   (
      Invalid0,
      TSS16_Available,
      LDT,
      TSS16_Busy,
      CallGate16,
      Task_Gate,
      Interrupt16,
      Trap16,
      Reserved8,
      TSS32_Available,
      Reserved10,
      TSS32_Busy,
      CallGate32,
      Reserved13,
      Interrupt32,
      Trap32
   ) with Size => 4;
   for SystemTypes_t use
   (
      Invalid0 = 0,
      TSS16_Available = 2#0001#,
      LDT  = 2#0010#,
      TSS16_Busy      = 2#0011#,
      CallGate16     = 2#0100#,
      Task_Gate       = 2#0101#,
      Interrupt16     = 2#0110#,
      Trap16          = 2#0111#,
      Reserved8       = 2#1000#,
      TSS32_Available = 2#1001#,
      Reserved10      = 2#1010#,
      TSS32_Busy      = 2#1011#,
      CallGate32     = 2#1100#,
      Reserved13      = 2#1101#,
      Interrupt32     = 2#1110#,
      Trap32          = 2#1111#
   );
   for SystemTypes_t'Size use 4;

--#######################################################
--    50.9
--#######################################################

   subtype SystemTypes_TaskGate_SubT is SystemTypes_t range Task_Gate .. Task_Gate;


--#######################################################
--    50.10
--#######################################################

   type GDTSysTypes_t is
   (
      Invalid0,
      TSS16_Available,
      LDT,
      TSS16_Busy,
      CallGate16,
      Task_Gate,
--      Interrupt16,
--      Trap16,
      Reserved8,
      TSS32_Available,
      Reserved10,
      TSS32_Busy,
      CallGate32,
      Reserved13
--      Interrupt32,
--      Trap32
   ) with Size => 4;
   for SystemTypes_t use
   (
      Invalid0 = 0,
      TSS16_Available = 2#0001#,
      LDT  = 2#0010#,
      TSS16_Busy      = 2#0011#,
      CallGate16     = 2#0100#,
      Task_Gate       = 2#0101#,
--      Interrupt16     = 2#0110#,
--      Trap16          = 2#0111#,
      Reserved8       = 2#1000#,
      TSS32_Available = 2#1001#,
      Reserved10      = 2#1010#,
      TSS32_Busy      = 2#1011#,
      CallGate32     = 2#1100#,
      Reserved13      = 2#1101#
--      Interrupt32     = 2#1110#,
--      Trap32          = 2#1111#
   );
   for GDTSysTypes_t'Size use 4;
--#######################################################
--    50.20
--#######################################################

   subtype GDTSysTypes_LDT_SubT is GDTSysTypes_t range LDT .. LDT;
   subtype GDTSysTypes_CallGate16_SubT is GDTSysTypes_t range CallGate16 .. CallGate16;
   subtype GDTSysTypes_CallGate32_SubT is GDTSysTypes_t range CallGate32 .. CallGate32;
   subtype GDTSysTypes_TSS16_SubT is GDTSysTypes_t range TSS16_Available .. TSS16_Busy;
   subtype GDTSysTypes_TSS32_SubT is GDTSysTypes_t range TSS32_Available .. TSS32_Busy;
   subtype GDTSysTypes_TaskGate_SubT is GDTSysTypes_t range Task_Gate .. Task_Gate;
--   subtype SystemTypes_IDT16Types_SubT is SystemTypes_t range Task_Gate .. Trap16;
--   subtype SystemTypes_IDT32Types_SubT is SystemTypes_t range Interrupt32 .. Trap32;
--   subtype SystemTypes_IDTTypes_SubT is SystemTypes_t range Task_Gate .. Trap32;



--#######################################################
--#######################################################
--
--    60
--
--#######################################################
--#######################################################



   type Access_Byte_t is record
      Descriptor_Type : SystemTypes_t;
      IsNot_System : Boolean;
      Privelege_LVL : Privelege_LVL_t;
      Is_Present : Boolean;
   end record 
   with Size => 8;
   for Access_Byte_t use record
      Descriptor_Type at 0 range 0 .. 3;
      IsNot_System at 0 range 4 .. 4;
      Privelege_LVL at 0 range 5 .. 6;
      Is_Present at 0 range 7 .. 7;
   end record;
   for Access_Byte_t'Size use 8;



--#######################################################
--#######################################################
--
--    70
--
--#######################################################
--#######################################################


   type Segment_Descriptor_Raw is record
      Word1 : Interfaces.Unsigned_16;
      Word2 : Interfaces.Unsigned_16;
      Byte5 : Interfaces.Unsigned_8;
      Access_Byte : Access_Byte_t;
      Word4 : Interfaces.Unsigned_32;
   end record
   with Size => 64;
   for Segment_Descriptor_Raw use record
      Word1 at 0 range 0 .. 15;
      Word2 at 0 range 16 .. 31;
      Byte5 at 4 range 0 .. 7;
      Access_Byte at 4 range 8 .. 15;
      Word4 at 4 range 16 .. 31;
   end record;
   for Segment_Descriptor_Raw'Size use 64;
--#######################################################
--    70.9
--#######################################################
   type Segment_Descriptor_Raw_PTR is access all Segment_Descriptor_Raw;

--#######################################################
--    70.10
--#######################################################


function DescriptorRaw_TO_uint64 is new Ada.Unchecked_Conversion
   (
      Source => Segment_Descriptor_Raw,
      Target => Interfaces.Unsigned_64
   );
function uint64_TO_DescriptorRAW is new Ada.Unchecked_Conversion
   (
      Source => Interfaces.Unsigned_64,
      Target => Segment_Descriptor_Raw
   );





--#######################################################
--#######################################################
--
--  80
--
--#######################################################
--#######################################################

   type GDT_Descriptor_NonSys_Word4_t is record
      Limit_High : Limit_High_t;
      Available_Bit : Boolean;
      Is_64 : Boolean;
      Is_32 : Boolean;
      Is_Granular : Boolean;
      Base_High : Base_High_t;
   end record
   with Size => 16;
   for GDT_Descriptor_NonSys_Word4_t use record
      Limit_High at 0 range 0 .. 3;
      Available_Bit at 0 range 4 .. 4;
      Is_64 at 0 range 5 .. 5;
      Is_32 at 0 range 6 .. 6;
      Is_Granular at 0 range 7 .. 7;
      Base_High at 0 range 8 .. 15;
   end record;
   for GDT_Descriptor_NonSys_Word4_t'Size use 16;




--#######################################################
--#######################################################
--
--    90
--
--#######################################################
--#######################################################



   type GDT_Descriptor_Code is record
      Limit_Low : Limit_Low_t;
      Base_Low  : Base_Low_t;

      Is_Accessed : Boolean;
      Is_Readable : Boolean;
      Is_Conforming : Boolean;
      Is_Executable : Always_1Bool_t;
      IsNot_System  : Always_1Bool_t;
      Privelege_LVL : Privelege_LVL_t;
      Is_Present : Boolean;
      
      Word4 : GDT_Descriptor_NonSys_Word4_t;
   end record
   with Size => 64;
   for GDT_Descriptor_Code use record
      Limit_Low at 0 range 0 .. 15;
      Base_Low at 0 range 16 .. 39;

      Is_Accessed at 4 range 8 .. 8;
      Is_Readable at 4 range 9 .. 9;
      Is_Conforming at 4 range 10 .. 10;
      Is_Executable at 4 range 11 .. 11;
      IsNot_System at 4 range 12 .. 12;
      Privelege_LVL at 4 range 13 .. 14;
      Is_Present at 4 range 15 .. 15;

      Word4 at 4 range 16 .. 31;
   end record;
   for GDT_Descriptor_Code'Size use 64;
--#######################################################
--    90.9
--#######################################################
   type GDT_Descriptor_Code_PTR is access all GDT_Descriptor_Code;
--#######################################################
--    90.10
--#######################################################


function DescriptorCode_TO_DescriptorRaw is new ADA.Unchecked_Conversion
   (
      Source => GDT_Descriptor_Code,
      Target => Segment_Descriptor_Raw
   );
function DescriptorRaw_TO_DescriptorCode is new ADA.Unchecked_Conversion
   (
      Source => Segment_Descriptor_Raw,
      Target => GDT_Descriptor_Code
   );
function DescriptorCode_TO_uint64 is new ADA.Unchecked_Conversion
   (
      Source => GDT_Descriptor_Code,
      Target => Interfaces.Unsigned_64
   );
function uint64_TO_DescriptorCode is new ADA.Unchecked_Conversion
   (
      Source => Interfaces.Unsigned_64,
      Target => GDT_Descriptor_Code
   );






--#######################################################
--#######################################################
--
-- 100
--
--#######################################################
--#######################################################

   type GDT_Descriptor_Data is record
      Limit_Low : Limit_Low_t;
      Base_Low  : Base_Low_t;

      Is_Accessed : Boolean;
      Is_Writable : Boolean;
      Is_Expanding_Down : Boolean;
      Is_Executable : Always_0Bool_t;
      IsNot_System : Always_1Bool_t;
      Privelege_LVL : Privelege_LVL_t;
      Is_Present : Boolean;

      Word4 : GDT_Descriptor_NonSys_Word4_t;
   end record
   with Size => 64;
   for GDT_Descriptor_Data use record
      Limit_Low at 0 range 0 .. 15;
      Base_Low at 0 range 16 .. 39;

      Is_Accessed at 4 range 8 .. 8;
      Is_Writable at 4 range 9 .. 9;
      Is_Expanding_Down at 4 range 10 .. 10;
      Is_Executable at 4 range 11 .. 11;
      IsNot_System at 4 range 12 .. 12;
      Privelege_LVL at 4 range 13 .. 14;
      Is_Present at 4 range 15 .. 15;

      Word4 at 4 range 16 .. 31;
   end record;
   for GDT_Descriptor_Data'Size use 64;
--#######################################################
--    100.9
--#######################################################
   type GDT_Descriptor_Data_PTR is access all GDT_Descriptor_Data;
--#######################################################
--    100.10
--#######################################################

function DescriptorData_TO_DescriptorRaw is new ADA.Unchecked_Conversion
   (
      Source => GDT_Descriptor_Data,
      Target => Segment_Descriptor_Raw
   );
function DescriptorRaw_TO_DescriptorData is new ADA.Unchecked_Conversion
   (
      Source => Segment_Descriptor_Raw,
      Target => GDT_Descriptor_Data
   );
function DescriptorData_TO_uint64 is new ADA.Unchecked_Conversion
   (
      Source => GDT_Descriptor_Data,
      Target => Interfaces.Unsigned_64
   );
function uint64_TO_DescriptorData is new ADA.Unchecked_Conversion
   (
      Source => Interfaces.Unsigned_64,
      Target => GDT_Descriptor_Data
   );



--#######################################################
--#######################################################
--
--    110
--
--#######################################################
--#######################################################

   type Segment_Index_t is new Integer range 0 .. 8191
      with Size => 13;
   for Segment_Index_t'Size use 13;



--#######################################################
--#######################################################
--
--    120
--
--#######################################################
--#######################################################

   type Segment_Selector is record
      Requested_Privelege : Privelege_LVL_t;
      IsIn_LDT : Boolean;
      Segment_Index : Segment_Index_t;
   end record
      with Size => 16;
   for Segment_Selector use record
      Requested_Privelege at 0 range 0 .. 1;
      IsIn_LDT at 0 range 2 .. 2;
      Segment_Index at 0 range 3 .. 15;
   end record;
   for  Segment_Selector'Size use 16;
   type Segment_SelectorPTR is access all Segment_Selector;

--#######################################################
--    120.10
--#######################################################

function Selector_TO_uint16 is new ADA.Unchecked_Conversion
   (
      Source => Segment_Selector,
      Target => Interfaces.Unsigned16
   );
function uint16_TO_Selector is new ADA.Unchecked_Conversion
   (
      Source => Interfaces.Unsigned_16,
      Target => Segment_Selector
   );





--#######################################################
--#######################################################
--
--    130
--
--#######################################################
--#######################################################



   type Call_Gate32_r is record
      Offset_Low : Interfaces.Unsigned_16;
      Selector : Segment_Selector;
      Argum_Copy_Amount : Interfaces.Unsigned_8 range 0 .. 31;
      Descriptor_Type : GDTSystemTypes_CallGate32_SubT;
      IsNot_System : Always_0Bool_t;
      Privelege_LVL : Privelege_LVL_t;
      Is_Present : Boolean;
      Offset_High : Interfaces.Unsigned_16;
   end record
   with Size => 64;
   for Call_Gate32_r use record
      Offset_Low at 0 range 0 .. 15;
      Selector at 0 range 16 .. 31;
      Argum_Copy_Amount at 4 range 0 .. 7;
      Descriptor_Type at 4 range 8 .. 12;
      Privelege_LVL at 4 range 13 .. 14;
      Is_Present at 4 range 15 .. 15;
      Offset_High at 4 range 16 .. 31;
   end record;
   for Call_Gate32_r'Size use 64;
--#######################################################
--    130.9
--#######################################################
   type Call_Gate32_r_PTR is access all Call_Gate32_r;
--#######################################################
--    130.10
--#######################################################

function CallGate32_TO_DescriptorRaw is new ADA.Unchecked_Conversion
   (
      Source => Call_Gate32_r,
      Target => Segment_Descriptor_Raw
   );
function DescriptorRaw_TO_CallGate32 is new ADA.Unchecked_Conversion
   (
      Source => Segment_Descriptor_Raw,
      Target => Call_Gate32_r
   );
function CallGate32_TO_uint64 is new ADA.Unchecked_Conversion
   (
      Source => Call_Gate32_r,
      Target => Interfaces.Unsigned_64
   );
function uint64_TO_CallGate32 is new ADA.Unchecked_Conversion
   (
      Source => Interfaces.Unsigned_64,
      Target => Call_Gate32_r
   );












--#######################################################
--#######################################################
--
--    150
--
--#######################################################
--#######################################################

type GDT_t is array (Segment_Index_t) of Segment_Descriptor_Raw;
type GDT_t_PTR is access all GDT_t;
--#######################################################
--    150.10
--#######################################################
type GDT_Descriptor_r is record
   Limit : Interfaces.Unsigned_16;
   GDT_Pointer : GDT_t_PTR;
end record
   with Size => 48;
for GDT_Descriptor_r use record
   Limit at 0 range 0 .. 15;
   GDT_Pointer at 0 range 16 .. 47;
end record;
for GDT_Descriptor_r'Size use 48;

type GDT_Descriptor_r_PTR is access all GDT_Descriptor_r; 



private
   
end X86_segments;
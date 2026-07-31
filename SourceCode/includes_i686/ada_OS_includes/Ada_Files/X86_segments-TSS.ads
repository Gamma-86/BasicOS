with IA32_Hardware_Registers;
with Interfaces;
with System;
with X86_paging;
package X86_segments.TSS is
--Documentation Update required

--10 Record Type - TSS 32 Descriptor, a local thread storage for hardware
--    Multitasking
--10.9 Pointer to TSS32 descriptor
--10.10 DescriptorRAW<->TSS32<->Unsigned 64 unchecked conversions

--20 the Task state Segment32 structure itself
--



type Interrupt_Redirect_e is (
   To_IVT,
   To_IDT
) with Size => 1;
for Interrupt_Redirect_e use(
   To_IVT => 0,
   To_IDT => 0
);
for Interrupt_Redirect_e'Size use 1;

type Int_Redir_BitMap is array (0 .. 255) of Interrupt_Redirect_e
   with Component_Size => 1, Pack, Size => 256;
for Int_Redir_BitMap'Size use 256;

type Port_Permission is (
   Allowed,
   Denied
) with Size => 1;
for Port_Permission use (
   Allowed => 0,
   Denied  => 0
);
for Port_Permission'Size use 1;

type Port_Perm_BitMap is array(0 .. 65535) of Port_Permission
   with Component_Size => 1, Pack, Size => 65536; 

type TSS_Bitmap_Structs is record
   IntRedirect_BitMap : Int_Redir_BitMap;
   PortBitMap : Port_Perm_BitMap;
end record;



--#######################################################
--#######################################################
--
--    Task_Gate, Task Gate Descriptor
--
--#######################################################
--#######################################################
type TaskGate_Descriptor_r is record
   Reserve_0_15 : Interfaces.Unsigned_16 range 0 .. 0;
   TSS_Selector : Segment_Selector;
   Reserved4_0_7: Interfaces.Unsigned_8 range 0 .. 0 ;
   Descriptor_Type : GDTSysTypes_TaskGate_SubT;
   Bit0         : Always_0Bool_t;
   Privelege_LVL : Privelege_LVL_t;
   Is_Present   : Boolean;
   Reserved4_16_31 : Interfaces.Unsigned_16 range 0 .. 0;
end record with Size => 64;
for TaskGate_Descriptor_r use record
   Reserve_0_15 at 0 range 0 .. 15;
   TSS_Selector at 0 range 16 .. 31;
   Reserved4_0_7 at 4 range 0 .. 7;
   Descriptor_Type at 4 range 8 .. 11;
   Bit0 at 4 range 12 .. 12;
   Privelege_LVL at 4 range 13 .. 14;
   Is_Present at 4 range 15 .. 15;
   Reserved4_16_31 at 4 range 16 .. 31;
end record;
for TaskGate_Descriptor_r'Size use 64;
--#######################################################
--    Task Gate Pointer
--#######################################################

type TaskGate_Descriptor_r_PTR is access all TaskGate_Descriptor_r;
--#######################################################
-- Task Gate conversion functions
--#######################################################

function TaskGate_To_DescriptorRaw is new Ada.Unchecked_Conversion(
   Source => TaskGate_Descriptor_r,
   Target => GDT_Descriptor_Raw
);
function DescriptorRaw_To_TaskGate is new Ada.Unchecked_Conversion(
   Source => GDT_Descriptor_Raw,
   Target => TaskGate_Descriptor_r
);
function TaskGate_To_uint64 is new Ada.Unchecked_Conversion(
   Source => TaskGate_Descriptor_r,
   Target => Interfaces.Unsigned_64
);
function uint64_To_TaskGate is new Ada.Unchecked_Conversion(
   Source => Interfaces.Unsigned_64,
   Target => TaskGate_Descriptor_r
);

--#######################################################
--#######################################################
--
--    10
--
--#######################################################
--#######################################################

   type TSS32_Descriptor_r is record
      Limit_Low : Limit_Low_t;
      Base_Low  : Base_Low_t;

      Is1_Bit1  : Always_1Bool_t;
      Is_Busy   : Boolean;
      Is0_Bit1  : Always_0Bool_t;
      Is1_Bit2  : Always_1Bool_t;
      IsNot_System : Always_0Bool_t;
      Privelege_LVL : Privelege_LVL_t;
      Is_Present : Boolean;

      Limit_High : Limit_High_t;
      Available_Bit : Boolean;

      Is_64 : Always_0Bool_t;
      Is0_Bit2 : Always_0Bool_t;
      Is_Granular : Boolean;
      Base_High : Base_High_t;
   end record
   with Size => 64;
   for TSS32_Descriptor_r use record
      Limit_Low at 0 range 0 .. 15;
      Base_Low at 0 range 16 .. 39;

      Is1_Bit1 at 4 range 8 .. 8;
      Is_Busy at 4 range 9 .. 9;
      Is0_Bit1 at 4 range 10 .. 10;
      Is1_Bit2 at 4 range 11 .. 11;
      IsNot_System at 4 range 12 .. 12;
      Privelege_LVL at 4 range 13 .. 14;
      Is_Present at 4 range 15 .. 15;

      Limit_High at 4 range 16 .. 19;
      Available_Bit at 4 range 20 .. 20;

      Is_64 at 4 range 21 .. 21;
      Is0_Bit2 at 4 range 22 .. 22;
      Is_Granular at 4 range 23 .. 23;
      Base_High at 4 range 24 .. 31;
   end record;
   For TSS32_Descriptor_r'Size use 64;
--#######################################################
--    10.9
--#######################################################
   type TSS32_Descriptor_r_PTR is access all TSS32_Descriptor_r;
--#######################################################
--    10.10
--#######################################################

function TSS32_TO_DescriptorRaw is new ADA.Unchecked_Conversion
   (
      Source => TSS32_Descriptor,
      Target => GDT_Descriptor_Raw
   );
function DescriptorRaw_TO_TSS32 is new ADA.Unchecked_Conversion
   (
      Source => GDT_Descriptor_Raw,
      Target => TSS32_Descriptor
   );
function TSS32_TO_uint64 is new ADA.Unchecked_Conversion
   (
      Source => TSS32_Descriptor,
      Target => Interfaces.Unsigned_64
   );
function uint64_TO_TSS32 is new ADA.Unchecked_Conversion
   (
      Source => Interfaces.Unsigned_64,
      Target => TSS32_Descriptor
   );

   

--#######################################################
--#######################################################
--
--    20
--
--#######################################################
--#######################################################
type TSS_Bitmap_Structs is record
   VirtInt_Redirect : Int_Redir_BitMap;
   PortBitMap : Port_Perm_BitMap;
end record;



type TSS32_r is record
   Prev_TSS : Segment_Selector;

   ESP_LVL0 : Interfaces.Unsigned_32;
   SS_LVL0  : Segment_Selector;

   ESP_LVL1 : Interfaces.Unsigned_32;
   SS_LVL1  : Segment_Selector;

   ESP_LVL2 : Interfaces.Unsigned_32;
   SS_LVL2  : Segment_Selector;

   CR3      : IA32_Hardware_Registers.Control_Register3_r;

   EIP      : Interfaces.Unsigned_32;

   EFlags   : IA32_Hardware_Registers.EFlags_register_r;

   EAX      : Interfaces.Unsigned_32;
   ECX      : Interfaces.Unsigned_32;
   EDX      : Interfaces.Unsigned_32;
   EBX      : Interfaces.Unsigned_32;
   ESP      : System.Address;
   EBP      : System.Address;
   ESI      : Interfaces.Unsigned_32;
   EDI      : Interfaces.Unsigned_32;

   ES       : Segment_Selector;
   CS       : Segment_Selector;
   SS       : Segment_Selector;
   DS       : Segment_Selector;
   FS       : Segment_Selector;
   GS       : Segment_Selector;

   LDT_Selector : Segment_Selector;
   Do_Switch_Trap_Int : Segment_Selector;

   IO_Map_Base  : Interfaces.Unsigned_16;
end record;

end X86_segments.TSS;
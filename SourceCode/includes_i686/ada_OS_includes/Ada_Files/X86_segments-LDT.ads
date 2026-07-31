package X86_segments.LDT is

   type LDTSystemTypes_t is
   (
      Invalid0,
      CallGate16,
      CallGate32
   );
   for LDTSystemTypes_t use
   (
      Invalid0       = 0,
      CallGate16     = 2#0100#,
      CallGate32     = 2#1100#
   );

   type LDT_t is array (Segment_Index_t) of GDT_Descriptor_RAW;
   type LDT_t_PTR is access all LDT_t;





--#######################################################
--#######################################################
--
--    20
--
--#######################################################
--#######################################################
   type LDT_Descriptor_r is record
      Limit_Low : Limit_Low_t;
      Base_Low  : Base_Low_t;
      
      LDT_Type  : GDTSystemTypes_LDT_SubT;
      IsNot_System : Always_0Bool_t;
      Privelege_LVL : Privelege_LVL_t;
      Is_Present : Boolean;
      
      Limit_High : Limit_High_t;

      Available_Bit : Boolean;
      Is_64 : Boolean;
      ZeroBit: Always_0Bool_t;
      Is_Granular : Boolean;
      Base_High : Base_High_t;
   end record
   with Size => 64;
   for LDT_Descriptor_r use record
      Limit_Low at 0 range 0 .. 15;
      Base_Low at 0 range 16 .. 39;

      LDT_Type at 4 range 8 .. 11;
      IsNot_System at 4 range 12 .. 12;
      Privelege_LVL at 4 range 13 .. 14;
      Is_Present at 4 range 15 .. 15;

      Limit_High at 4 range 16 .. 19;

      Available_Bit at 4 range 20 .. 20;
      Is_64 at 4 range 21 .. 21;
      ZeroBit at 4 range 22 .. 22;
      Is_Granular at 4 range 23 .. 23;

      Base_High at 4 range 24 .. 31;
   end record;
   for LDT_Descriptor'Suze use 64;
--#######################################################
--    20.9
--#######################################################
   type LDT_Descriptor_PTR is access all LDT_Descriptor;
--#######################################################
--    20.10
--#######################################################

function LDT_TO_DescriptorRaw is new ADA.Unchecked_Conversion
   (
      Source => LDT_Descriptor,
      Target => GDT_Descriptor_Raw
   );
function DescriptorRaw_TO_LDT is new ADA.Unchecked_Conversion
   (
      Source => GDT_Descriptor_Raw,
      Target => LDT_Descriptor
   );
function LDT_TO_uint64 is new ADA.Unchecked_Conversion
   (
      Source => LDT_Descriptor,
      Target => Interfaces.Unsigned_64
   );
function uint64_TO_LDT is new ADA.Unchecked_Conversion
   (
      Source => Interfaces.Unsigned_64,
      Target => LDT_Descriptor
   );



end X86_segments.LDT;
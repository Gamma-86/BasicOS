with System;
with Interfaces;
with Ada.Unchecked_Conversion;

package Segmentation is
   package Descriptors is
      type Base_Low_Type is mod 2 ** 24;
         for Base_Low_Type'Size use 24;
      type Base_High_Type is mod 2 ** 8;
         for Base_High_Type'Size use 8;


      type Limit_Low_Type is mod 2 ** 16;
         for Limit_Low_Type'Size use 16;
      type Limit_High_Type is mod 2 ** 4;
         for Limit_High_Type'Size use 4;

      type DPL_type is mod 2 ** 2;
         for DPL_type'Size use 2;

      type TypeField_type is 
      (
         Data_R,
         Data_R_A,
         Data_R_W,
         Data_R_W_A,
         Data_R_EDown,
         Data_R_EDown_A,
         Data_R_W_EDown,
         Data_R_W_EDown_A,

         Code,
         Code_A,
         Code_R,
         Code_R_A,
         Code_C,
         Code_C_A,
         Code_R_C,
         Code_R_C_A,

         TSS16_Free,
         LDT,
         TSS16_Busy,
         CallGate16,
         TaskGate,
         Interrupt16,
         Trap16,
         TSS32_Free,
         TSS32_Busy,
         CallGate32,
         Interrupt32,
         Trap32
      );
      for TypeField_type use
      (
         Data_R =>         2#0_0_000#,
         Data_R_A =>       2#0_0_001#,
         Data_R_W =>       2#0_0_010#,
         Data_R_W_A =>     2#0_0_011#,
         Data_R_EDown =>   2#0_0_100#,
         Data_R_EDown_A => 2#0_0_101#,
         Data_R_W_EDown => 2#0_0_110#,
         Data_R_W_EDown_A=>2#0_0_111#,

         Code       =>  2#0_1_000#,
         Code_A =>      2#0_1_001#,
         Code_R =>      2#0_1_010#,
         Code_R_A =>    2#0_1_011#,
         Code_C =>      2#0_1_100#,
         Code_C_A =>    2#0_1_101#,
         Code_R_C =>    2#0_1_110#,
         Code_R_C_A =>  2#0_1_111#,

         TSS16_Free =>  2#1_0001#,
         LDT =>         2#1_0010#,
         TSS16_Busy =>  2#1_0011#,
         CallGate16 =>  2#1_0100#,
         TaskGate =>    2#1_0101#,
         Interrupt16 => 2#1_0110#,
         Trap16 =>      2#1_0111#,
         TSS32_Free =>  2#1_1001#,
         TSS32_Busy =>  2#1_1011#,
         CallGate32 =>  2#1_1100#,
         Interrupt32 => 2#1_1110#,
         Trap32 =>      2#1_111#
--         Reserved8 = 2#1000#,
--         Reserved10 = 2#1010#,
--         Reserved13 = 2#1101#
      );
      for TypeField_type'Size use 5;

      subtype TypeFieldData_type is TypeField_type 
         range Data_R .. Data_R_W_EDown_A;
         for TypeFieldData_type'Size use 5;
      subtype TypeFieldCode_type  is TypeField_type range Code .. Code_R_C_A;
         for TypeFieldCode_type'Size use 5;
      subtype TypeFieldSystem_type is TypeField_type range TSS16_Free..Trap32;
         for TypeFieldSystem_type'Size use 5;
      type AccessByteRaw is record
         TypeField : TypeField_type;
         Privelege : DPL_type;
         IsPresent : Boolean;
      end record;
      for  AccessByteRaw use record
         TypeField at 0 range 0 .. 4;
         Privelege at 0 range 5 .. 6;
         IsPresent at 0 range 7 .. 7;
      end record;
      for AccessByteRaw'Size use 8;

      type SizeTypeFlags is record
         Available  : Boolean;
         Reserved64 : Boolean;
         Is32bit    : Boolean;
         Granular   : Boolean;
      end record;
      for SizeTypeFlags use record
         Available  at 0 range 0 .. 0;
         Reserved64 at 0 range 1 .. 1;
         Is32bit    at 0 range 2 .. 2;
         Granular   at 0 range 3 .. 3;
      end record;
      for SizeTypeFlags'Size use 4;

      type SegmentRaw is record
         LimitLow : Limit_Low_Type;
         BaseLow  : Base_Low_Type;
         AccessByte:AccessByteRaw;
         LimitHigh: Limit_High_Type;
         Flags    : SizeTypeFlags;
         BaseHigh : Base_High_Type;
      end record;
      for SegmentRaw use record
         LimitLow   at 0 range 0 .. 15;
         BaseLow    at 0 range 16 .. 39;
         AccessByte at 4 range 8 .. 15;
         LimitHigh  at 4 range 16 .. 19;
         Flags      at 4 range 20 .. 23;
         BaseHigh   at 4 range 24 .. 31;
      end record;
      for SegmentRaw'Size use 64;

            
      type CodeAccessByte is record
         TypeField  : TypeFieldCode_type;
         Privelege  : DPL_type;
         IsPresent  : Boolean;
      end record;
      for CodeAccessByte use record
         TypeField  at 0 range 0 .. 4;
         Privelege  at 0 range 5 .. 6;
         IsPresent  at 0 range 7 .. 7;
      end record;
      for CodeAccessByte'Size use 8;

      type DataAccessByte is record
         TypeField  : TypeFieldData_type;
         Privelege  : DPL_type;
         IsPresent  : Boolean;
      end record;
      for DataAccessByte use record
         TypeField at 0 range 0 .. 4;
         Privelege  at 0 range 5 .. 6;
         IsPresent  at 0 range 7 .. 7;
      end record;
      for DataAccessByte'Size use 8;


      type SystemAccessByte is record
         TypeField   : TypeFieldSystem_type;
         Privelege   : DPL_type;
         IsPresent   : Boolean;
      end record;
      for SystemAccessByte use record
         TypeField at 0 range 0 .. 4;
         Privelege   at 0 range 5 .. 6;
         IsPresent   at 0 range 7 .. 7;
      end record;
      for SystemAccessByte'Size use 8;





      type CodeSegment is record
         LimitLow   : Limit_Low_Type;
         BaseLow    : Base_Low_Type;
         AccessByte : CodeAccessByte;
         LimitHigh  : Limit_High_Type;
         Flags      : SizeTypeFlags;
         BaseHigh   : Base_High_Type;
      end record;
      for CodeSegment use record
         LimitLow   at 0 range 0 .. 15;
         BaseLow    at 0 range 16 .. 39;
         AccessByte at 4 range 8 .. 15;
         LimitHigh  at 4 range 16 .. 19;
         Flags      at 4 range 20 .. 23;
         BaseHigh   at 4 range 24 .. 31;
      end record;
      for CodeSegment'Size use 64;

      type DataSegment is record
         LimitLow   : Limit_Low_Type;
         BaseLow    : Base_Low_Type;
         AccessByte : DataAccessByte;
         LimitHigh  : Limit_High_Type;
         Flags      : SizeTypeFlags;
         BaseHigh   : Base_High_Type;
      end record;
      for DataSegment use record
         LimitLow   at 0 range 0 .. 15;
         BaseLow    at 0 range 16 .. 39;
         AccessByte at 4 range 8 .. 15;
         LimitHigh  at 4 range 16 .. 19;
         Flags      at 4 range 20 .. 23;
         BaseHigh   at 4 range 24 .. 31;
      end record;
      for DataSegment'Size use 64;

      type SystemSegment is record
         LimitLow   : Limit_Low_Type;
         BaseLow    : Base_Low_Type;
         AccessByte : SystemAccessByte;
         LimitHigh  : Limit_High_Type;
         Flags      : SizeTypeFlags;
         BaseHigh   : Base_High_Type;
      end record;
      for SystemSegment use record
         LimitLow   at 0 range 0 .. 15;
         BaseLow    at 0 range 16 .. 39;
         AccessByte at 4 range 8 .. 15;
         LimitHigh  at 4 range 16 .. 19;
         Flags      at 4 range 20 .. 23;
         BaseHigh   at 4 range 24 .. 31;
      end record;
      for SystemSegment'Size use 64;

      type AddressFragmented is record
         BaseLow  : Base_Low_Type;
         BaseHigh : Base_High_Type;
      end record;
      for AddressFragmented use record
         BaseLow  at 0 range 0 .. 23;
         BaseHigh at 0 range 24 .. 31;
      end record;
      for AddressFragmented'Size use 32;

      type LimitFragmented is record
         LimitLow  : Limit_Low_Type;
         LimitHigh : Limit_High_Type;
      end record;
      for LimitFragmented use record
         LimitLow  at 0 range 0 .. 15;
         LimitHigh at 0 range 16 .. 19;
      end record;
      for LimitFragmented'Size use 20;

      function Fragment_Address
        (Address : System.Address) return AddressFragmented;
      function Fragment_Limit (Limit : Integer) return LimitFragmented;
   private

   end Descriptors;
end Segmentation;

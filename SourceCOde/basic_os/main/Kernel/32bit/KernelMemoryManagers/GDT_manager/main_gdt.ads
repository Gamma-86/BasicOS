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
      type TypeField_type is mod 2**4;
         for TypeField_type'Size use 4;

      type AccessByteRaw is record
         TypeField : TypeField_type;
         IsNotSystem:Boolean;
         Privelege : DPL_type;
         IsPresent : Boolean;
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
         TypeField  : TypeField_type;
         IsSegment  : Boolean;
         Privelege  : DPL_type;
         IsPresent  : Boolean;
      end record;
      for CodeAccessByte use record
         TypeField  at 0 range 0 .. 3;
         IsSegment  at 0 range 4 .. 4;
         Privelege  at 0 range 5 .. 6;
         IsPresent  at 0 range 7 .. 7;
      end record;
      for CodeAccessByte'Size use 8;

      type DataAccessByte is record
         Accessed   : Boolean;
         Writable   : Boolean;
         ExpandDown : Boolean;
         Executable : Boolean;
         IsSegment  : Boolean;
         Privelege  : DPL_type;
         IsPresent  : Boolean;
      end record;
      for DataAccessByte use record
         Accessed   at 0 range 0 .. 0;
         Writable   at 0 range 1 .. 1;
         ExpandDown at 0 range 2 .. 2;
         Executable at 0 range 3 .. 3;
         IsSegment  at 0 range 4 .. 4;
         Privelege  at 0 range 5 .. 6;
         IsPresent  at 0 range 7 .. 7;
      end record;
      for DataAccessByte'Size use 8;

      type SystemAccessByteType is
      (
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
         Trap32,

         Reserved8,
         Reserved10,
         Reserved13
      );
      for SystemAccessByteType use
      (
         TSS16_Free = 2#0001#,
         LDT = 2#0010#,
         TSS16_Busy = 2#0011#,
         CallGate16 = 2#0100#,
         TaskGate = 2#0101#,
         Interrupt16 = 2#0110#,
         Trap16 = 2#0111#,
         Reserved8 = 2#1000#,
         TSS32_Free = 2#1001#,
         Reserved10 = 2#1010#,
         TSS32_Busy = 2#1011#,
         CallGate32 = 2#1100#,
         Reserved13 = 2#1101#,
         Interrupt32 = 2#1110#,
         Trap32 = 2#1111#
      );
      for SystemAccessByteType'Size use 4;

      type SystemAccessByte is record
         TypeNibble  : SystemAccessByteType;
         IsNotSystem : Boolean;
         Privelege   : DPL_type;
         IsPresent   : Boolean;
      end record;
      for SystemAccessByte use record
         TypeNibble  at 0 range 0 .. 3;
         IsNotSystem at 0 range 4 .. 4;
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

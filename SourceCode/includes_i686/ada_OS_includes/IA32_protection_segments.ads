with Interfaces;
with Interfaces.C;

package IA32_protection_segments is
   type Privelege_LVL_type is mod 2 ** 2
      with Size => 2;
      for Privelege_LVL_type'Size use 2;

   type Base_Low_Type is mod 2 ** 24
      with Size => 24;
      for Base_Low_Type'Size use 24;
   type Base_High_Type is mod 2 ** 8
      with Size => 8;
      for Base_High_Type'Size use 8;


   type Limit_Low_Type is mod 2 ** 16
      with Size => 16;
      for Limit_Low_Type'Size use 16;
   type Limit_High_Type is mod 2 ** 4
      with Size => 4;
      for Limit_High_Type'Size use 4;

   type GDT_Descriptor_Raw is record
      Word1 : Interfaces.Unsigned_16;
      Word2 : Interfaces.Unsigned_16;
   end record;






   type Segment_Index_type is new Integer range 0 .. 8191
      with Size => 13;
   for Segment_Index_type'Size use 13;

   type Segment_Selector is record
      Requested_Privelege : Privelege_LVL_type;
      IsIn_LDT : Boolean;
      Segment_Index : Segment_Index_type;
   end record
      with Size => 16;
   for Segment_Selector use record
      Requested_Privelege at 0 range 0 .. 1;
      IsIn_LDT at 0 range 2 .. 2;
      Segment_Index at 0 range 3 .. 15;
   end record;
   for  Segment_Selector'Size use 16;
   type Segment_SelectorPTR is access all Segment_Selector;








private
   
end IA32_protection_segments;
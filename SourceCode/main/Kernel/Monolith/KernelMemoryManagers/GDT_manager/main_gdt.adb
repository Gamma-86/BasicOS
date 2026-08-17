with ReturnBitfields;
with System;
with x86_protection;
with x86_protection.Segmentation;

package body main_GDT is
   
   
   
   
--function Insert_GDT_Descriptor goal:
--Insert the segment descriptor to the required index in GDT
--  by generating it from given values 
-- while also checking if the Pointer is NULL, checking index
-- checking if the segment type and other fields don't contradict each other
--plan:
--   check if Index is bigger than maximum GDT table index(8191)(CRITICAL)
--       set ArrayIndexOverflow bit
--   check if Index is bigger than offset limit in GDT descriptor(Acceptable)
--       set ArrayIndexOverflow bit
--   check if BASE is 0, if it is(ACCEPTABLE, NO ABORT)
--      set NULL_Address TRUE
--
--   1 fragment limit and Base with corresponding fucntions
--   2 Basically assign corresponding parameters to correspondingdescriptors
--        fields
--   3copy it to the GDT in the address of INDEX
--   4return ReturnedBitfield of cource checking if we fulfilled with error
   function Insert_GDT_Descriptor(
      Limit : Interfaces.Unsigned_32;
      Base_Address : System.Address;
      Segment_Type : x86_protection.TypeField_type;
      Privelge : x86_protection.Privelege_LVL_type;
      Is_Present : Boolean;
      Is_Available:Boolean;
      Is_32bit   : Boolean;
      Is_Granular: Boolean;
      Index      : x86_protection.Segment_Index_type
   )
   is 
      use x86_protection;
      use x86_protection.Segmentation;
      Returned_Bitfield : ReturnBitfields.GeneralOS;
      Converted_Address : AddressFragmented;
      Converted_Limit   : LimitFragmented;
      Critical_error_made : Boolean := False;
      Calculated_Descriptor : x86_protection.SegmentRaw;
   begin
      Returned_Bitfield := (0);
      if Index > Segment_Index_type'Last then
         Returned_Bitfield.ArrayIndexOverflow := True;
         Returned_Bitfield.ReturnValNameSpace := ReturnBitfields.GeneralOS;
         Critical_error_made := TRUE;
      end if;
      if Unsigned_16(Index)*8 > MainGDT_Descriptor.limit then
         Returned_Bitfield.ArrayIndexOverflow;
         Returned_Bitfield.ReturnValNameSpace := ReturnBitfields.GeneralOS;
      end if;
      if Base_Address = System.Null_Address then
         Returned_Bitfield.Null_Address := True;
         Returned_Bitfield.ReturnValNameSpace := ReturnBitfields.GeneralOS;
      end if;

      if Critical_error_made then
         return Returned_Bitfield;
      end if;

      Converted_Address := Fragment_Address(Base_Address);
      Converted_Limit   := Fragment_Limit(Limit);

      Calculated_Descriptor :=
      (
         LimitLow => Converted_Limit.Limit_Low,
         BaseLow => Converted_Address.BaseLow,
         AccessByteRaw => (Segment_Type, Privelge, Is_Present),
         LimitHigh => Converted_Limit.LimitHigh,
         Flags => (Available=>Is_Available, Reserved64=>False, Is32bit=>Is_32bit, Granular => Is_Granular),
         BaseHigh => Converted_Address.BaseHigh
      );
      MainGDT_start(Index) := Calculated_Descriptor;
      if Returned_Bitfield.ReturnValNameSpace /= ReturnBitfields.SuccessCode 
      then
         Returned_Bitfield.FulfilledWithError := True;
      end if;

      return Returned_Bitfield;
   end Insert_GDT_Descriptor;
   


   
end main_GDT;
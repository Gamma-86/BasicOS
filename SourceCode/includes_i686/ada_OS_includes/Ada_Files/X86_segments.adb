with Ada.Unchecked_Conversion;
with Interfaces;
with System.Storage_Elements;
with System;
with X86_segments;

package body X86_segments is
--A package bodyfor X86 Segmentation specification that - for now - conatains
--Conversion and extraction functions, A formal, Bueracratic, ways of telling
--Ada compilers to interpret, for example, pointer as record made out of 
--8 / 24 bit unsigned intergers for more convenient use
--
--10 Function to Convert Raw Address into record made out of 8 / 24 bit
--    unsigneds

--20 Function to Glue the record made out of 8/24 bit Unsigned into raw Address 

--30 Function to Separate Give unsigned 32 into record made out of 16 and 4 bit
--    unsigneds for further use in segments limits

--40 FUnction to GLue record made out of 16/4 bit unsigned into single
--    32 bit unsgiend with zero expansion

--#######################################################
--#######################################################
--
--        10 
--
--#######################################################
--#######################################################
function Separate_BaseAddress32 (The_Address : System.Address) return Base_Separated_r_PTR is
   use System.Storage_Elements;
   use Interfaces;

   Address_Raw : constant Integer_Address := To_Integer(The_Address);
   Address_32  : constant Unsigned_32 := Unsigned_32( Address_Raw and 16#FFFF_FFFF# );

   Result : Base_Separated_r;
begin
   Result.Base_Low := Base_Low_t (Address_32 and 16#00FF_FFFF#);
   Result.Base_High := Base_High_t ( Shift_Right(Address_32, Base_Low_t'Size) );

   return Result;
end Separate_BaseAddress32;
--#######################################################
--#######################################################
--
--        20 
--
--#######################################################
--#######################################################
function Glue_BaseAddress32 (Separated_Address : Base_Separated_r) 
   return System.Address 
is
   use System.Storage_Elements;
   use Interfaces;

   Glued_Integer_Low : constant Unsigned_32 := 
      Unsigned_32( 
         Separated_Address_PTR.Base_Low 
      );
   Glued_Integer_High: constant Unsigned_32 := 
      Unsigned_32(
         Shift_Left(Separated_Address_PTR.Base_High, Base_Low_t'Size)
      );

   Semi_Result : Unsigned_32 := Glued_Integer_High or Glued_Integer_Low;
begin
   return To_Address( Integer_Address(Semi_Result) );
end Glue_BaseAddress32;








--#######################################################
--#######################################################
--
--        30
--
--#######################################################
--#######################################################
function Separate_SegmentLimit (Limit : Interfaces.Unsigned_32) return Limit_Separated_r is
   use Interfaces;
   Extracted_Limit_Low : Limit_Low_t;
   Extracted_Limit_High: Limit_High_t;
   Result : Limit_Separated_r;
begin
   Extracted_Limit_Low := Limit_Low_t(Limit);
   Extracted_Limit_High := Limit_High_t( Shift_Right(Limit, Limit_Low_t'Size) );

   Result.Limit_Low  := Extracted_Limit_Low;
   Result.Limit_High := Extracted_Limit_High;

   return Result;
end Name;
--#######################################################
--#######################################################
--
--        40
--
--#######################################################
--#######################################################
function Glue_SegmentLimit
   (Separated_Record_PTR : Limit_Separated_r_PTR) 
   return Interfaces.Unsigned_32 
is
   U32_Low : constant Interfaces.Unsigned_32 :=
   Interfaces.Unsigned_32(
      Separated_Record_PTR.Limit_Low
   );

   U32_High : constant Interfaces.Unsigned_32 :=
   Interfaces.Unsigned_32(
      Interfaces.Shift_Left( Separated_Record_PTR.Limit_Low, Limit_Low_t'Size)
   );
begin
   return U32_Low or U32_High;
end Glue_SegmentLimit;












end X86_segments;
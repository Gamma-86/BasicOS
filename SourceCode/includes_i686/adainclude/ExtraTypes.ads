with Interfaces;
with Interfaces.C;
package ExtraTypes is
   type IntegerPTR is access all Integer;
   type BooleanPTR is access all Boolean;
   type FloatPTR is access all Float;
   type CharacterPTR is access all Character;

   type Unsigned8_PTR is access all Interfaces.Unsigned_8;
   type Unsigned16_PTR is access all Interfaces.Unsigned_16;
   type Unsigned32_PTR is access all Interfaces.Unsigned_32;
   type Unsigned64_PTR is access all Interfaces.Unsigned_64;
   type Unsigned128_PTR is access all Interfaces.Unsigned_128;

   type Integer8_PTR is access all Interfaces.Integer_8;
   type Integer16_PTR is access all Interfaces.Integer_16;
   type Integer32_PTR is access all Interfaces.Integer_32;
   type Integer64_PTR is access all Interfaces.Integer_64;
   type Integer128_PTR is access all Interfaces.Integer_128;

   type Float32_PTR is access all Interfaces.IEEE_Float_32;
   type Float64_PTR is access all Interfaces.IEEE_Float_64;
   type EXT_Float_PTR is access all Interfaces.IEEE_Extended_Float;

   type int_PTR is access all Interfaces.C.int;
   type short_PTR is access all Interfaces.C.short;
   type long_PTR is access all Interfaces.C.long;
   type longlong_PTR is access all Interfaces.C.long_long;
   type s_char_PTR is access all Interfaces.C.signed_char;

   type u_int is access all Interfaces.C.unsigned;
   type u_short is access all Interfaces.C.unsigned_short;
   type u_long is access all Interfaces.C.unsigned_long;
   type u_longlong is access all Interfaces.C.unsigned_long_long;
   type u_char is access all Interfaces.C.unsigned_char;

   type C_float_PTR is access all Interfaces.C.C_float;
   type double_PTR is access all Interfaces.C.double;
   type long_double_PTR is access all Interfaces.C.long_double;


   type C_bool_PTR is access all Interfaces.C.C_bool; 
   type size_t_PTR is access all Interfaces.C.size_t;

   type char_PTR is access all Interfaces.C.char;
   type Wide_CharacterPTR is access all Wide_Character;
   type wchar_t_PTR is access all Interfaces.C.wchar_t;
   type char16_t_PTR is access all Interfaces.C.char16_t;
   type char32_t_PTR is access all Interfaces.C.char32_t;


   type ADA_STR_PTR is access all String;






   subtype Character_Z is Character range 0..0;
   subtype Integer_Z is Integer range 0..0;
   subtype Boolean_F is Boolean range False..False;
   subtype Boolean_T is Boolean range True..True;

   subtype Unsigned_8Z is Interfaces.Unsigned_8 range 0 .. 0;
   subtype Unsigned_16Z is Interfaces.Unsigned_16 range 0 .. 0;
   subtype Unsigned_32Z is Interfaces.Unsigned_32 range 0 .. 0;
   subtype Unsigned_64Z is Interfaces.Unsigned_64 range 0 .. 0;
   subtype Unsigned_128Z is Interfaces.Unsigned_128 range 0 .. 0;

   subtype Integer_8Z is Interfaces.Integer_8 range 0 .. 0;
   subtype Integer_16Z is Interfaces.Integer_16 range 0 .. 0;
   subtype Integer_32Z is Interfaces.Integer_32 range 0 .. 0;
   subtype Integer_64Z is Interfaces.Integer_64 range 0 .. 0;
   subtype Integer_128Z is Interfaces.Integer_128 range 0 ..0;

   subtype int_Z is Interfaces.C.int range 0 .. 0;
   subtype short_Z is Interfaces.C.short range 0 .. 0;
   subtype long_Z is Interfaces.C.long range 0 .. 0;
   subtype longlong_Z is Interfaces.C.long_long range 0 .. 0;
   subtype s_char_Z is Interfaces.C.signed_char range 0 .. 0;
   
   subtype u_int_Z is Interfaces.C.unsigned range 0 .. 0;
   subtype u_short_Z is Interfaces.C.unsigned_short range 0 .. 0;
   subtype u_long_Z is Interfaces.C.unsigned_long range 0 .. 0;
   subtype u_longlong_Z is Interfaces.C.unsigned_long_long range 0 .. 0;
   subtype u_char_Z is Interfaces.C.unsigned_char range 0 .. 0;

   subtype size_t_Z is Interfaces.C.size_t range 0 .. 0;
   subtype char_Z is Interfaces.C.char range 0 .. 0;
   subtype Wide_Character_Z is Wide_Character range 0..0;
   subtype wchar_t_Z is Interfaces.C.wchar_t range 0..0;
   subtype char16_t_Z is Interfaces.C.char16_t range 0..0;
   subtype char32_t_Z is Interfaces.C.char32_t range 0..0;
   
end ExtraTypes;
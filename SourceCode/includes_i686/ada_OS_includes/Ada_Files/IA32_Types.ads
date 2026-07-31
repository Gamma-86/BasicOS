with Ada.Unchecked_Conversion;
with IA32_Types;
with Interfaces;


package IA32_Types is
--deocumentation required


type Byte is mod 2 ** 8 with Size => 8;
for Byte'Size use 8;
type Byte_PTR is access all Byte;

type Byte_S is range -128 .. 127 with Size => 8;
for Byte_S'Size use 8;
type Byte_S_PTR is access all Byte_S;



type Word is mod 2 ** 16 with Size => 16;
for Word'Size use 16;
type Word_PTR is access all Word;

type Word_S is range -65536 .. 65535 with Size => 16;
for Word_S'Size use 16;
type Word_S_PTR is access all Word_S;



type DWord is mod 2 ** 32 with Size => 32;
for DWord'Size use 32;
type DWord_PTR is access all DWord;



type DWord_S is range -16#8000_0000# .. 16#7FFF_FFFF# with Size => 32;
for DWord_S'Size use 32;
type DWord_S_PTR is access all DWord_S;



type Qword_S is new Long_Long_Integer with Size => 64;
for Qword_S'Size use 64;
type Qword_S_PTR is access all Qword_S;



type Qword is mod 2 ** Long_Long_Integer'Size with Size => 64;
for Qword'Size use 64;
type Qword_PTR is access all Qword;


type Nibble is mod 2**4 with Size => 4;
for Nibble'Size use 4;

type BCD is range 0 .. 9 with Size => 4;
for BCD'Size use 4;
type BCD_sign is (
   X87_BCD_Positive,
   X87_BCD_Negative,
   BCD_Positive1,
   BCD_Positive2,
   BCD_Negative1,
   BCD_Negative2
) with Size => 4;
for BCD_sign use(
   X87_BCD_Positive => 0,
   X87_BCD_Negative => 8,
   BCD_Positive1 => 16#C#,
   BCD_Positive2 => 16#F#,
   BCD_Negative1  => 16#D#,
   BCD_Negative2  => 16#B#
);
for BCD_sign'Size use 4;


type X87_float is digits 18;
pragma Assert(X87_float'Machine_Mantissa = 64);
pragma Assert(X87_float'Digits >= 18);
pragma Assert(X87_float'Size = 80);
type X87_float_PTR is access all X87_float;


type X87_StackPointer is mod 2**3 with Size => 3;
for X87_StackPointer'Size use 3;




type X87_Precision_Modes is (
   Single,
   Double,
   Double_Extended
) with Size => 2;
for X87_Precision_Modes use (
   Single => 0,
   Double => 2,
   Double_Extended => 3
);
for X87_Precision_Modes'Size use 2;

type Rounding_Modes is (
   Round_To_Nearest,
   Round_To_M_inf,
   Round_To_P_inf,
   Round_To_Zero
) with Size => 2;
for Rounding_Modes use (
   Round_To_Nearest => 0,
   Round_To_M_inf => 1,
   Round_To_P_inf => 2,
   Round_To_Zero  => 3
);
for Rounding_Modes'Size use 2;





type X87_RegisterStatus is (
   Valid,
   Zero,
   Special,
   Empty
) with Size =>2;
for X87_RegisterStatus use (
   Valid => 0,
   Zero => 1,
   Special => 2,
   Empty => 3
);
for X87_RegisterStatus'Size use 2;



type MMX_Register is new Qword;


type MMX_PackedBytes is record
   Bytes : array (0..8) of Byte;
end record with Size => Qword'Size;
for MMX_PackedBytes use record
Bytes at 0 range 0 .. 63;
end record;
for MMX_PackedBytes'Size use Qword'Size;

type MMX_PackedBytes_PTR is access all MMX_PackedBytes;

function MMX_PackedBytes_To_Register is new Ada.Unchecked_Conversion(
   Source => MMX_PackedBytes,
   Target => MMX_Register
);
function MMX_Register_To_PackedBytes is new Ada.Unchecked_Conversion(
   Source => MMX_Register,
   Target => MMX_PackedBytes
);


type MMX_PackedWords is record
   Words : array (0 .. 3) of Word;
end record with Size => Qword'Size;
for MMX_PackedWords use record
   Words at 0 range 0 .. 63;
end record;
for MMX_PackedWords'Size use Qword'Size;

type MMX_PackedWords_PTR is access all MMX_PackedWords;

function MMX_PackedWords_To_Registers is new Ada.Unchecked_Conversion(
   Source => MMX_PackedWords,
   Target => MMX_Register
);
function MMX_Register_To_PackedWords is new Ada.Unchecked_Conversion(
   Source => MMX_Register,
   Target => MMX_PackedWords
);



type MMX_PackedDWords is record
   Dwords : array(0..1) of DWord;
end record with Size => Qword'Size;
for MMX_PackedDWords use record
   Dwords at 0 range 0 .. 63;
end record;
for MMX_PackedDWords'Size use Qword'Size;

type MMX_PackedDWords_PTR is access all MMX_PackedDWords; 

function MMX_PackedDWords_To_Register is new Ada.Unchecked_Conversion(
   Source => MMX_PackedDWords,
   Target => MMX_Register
);
function MMX_Register_To_PackedDwords is new Ada.Unchecked_Conversion(
   Source => MMX_Register,
   Target => MMX_PackedDWords
);





 






type SSE_Register is record
   Byte0 : Byte;
   Byte1 : Byte;
   Byte2 : Byte;
   Byte3 : Byte;

   Byte4 : Byte;
   Byte5 : Byte;
   Byte6 : Byte;
   Byte7 : Byte;

   Byte8 : Byte;
   Byte9 : Byte;
   Byte10 : Byte;
   Byte11 : Byte;

   Byte12 : Byte;
   Byte13 : Byte;
   Byte14 : Byte;
   Byte15 : Byte;
end record with Alignment => 16, Size => 128;
for SSE_Register use record
   Byte0 at 0 range 0 .. 7;
   Byte1 at 1 range 0 .. 7;
   Byte2 at 2 range 0 .. 7;
   Byte3 at 3 range 0 .. 7;

   Byte4 at 4 range 0 .. 7;
   Byte5 at 5 range 0 .. 7;
   Byte6 at 6 range 0 .. 7;
   Byte7 at 7 range 0 .. 7;

   Byte8 at 8 range 0 .. 7;
   Byte9 at 9 range 0 .. 7;
   Byte10 at 10 range 0 .. 7;
   Byte11 at 11 range 0 .. 7;

   Byte12 at 12 range 0 .. 7;
   Byte13 at 13 range 0 .. 7;
   Byte14 at 14 range 0 .. 7;
   Byte15 at 15 range 0 .. 7;
end record;
for SSE_Register'Size use 128;
for SSE_Register'Alignment use 16;

type SSE_Register_PTR is access all SSE_Register;


type SSE_PackedQwords is record
   Qwords : array (0 .. 1) of Qword;
end record with Size => SSE_Register'Size, Alignment => SSE_Register'Alignment;
for SSE_PackedQwords use record
   Qwords at 0 range 0 .. 127;
end record;
for SSE_PackedQwords'Size use SSE_Register'Size;
for SSE_PackedQwords'Alignment use SSE_Register'Alignment;

type SSE_PackedQwords_PTR is access all SSE_PackedQwords;

function SSE_Qwords_To_Register is new Ada.Unchecked_Conversion(
   Source => SSE_PackedQwords,
   Target => SSE_Register
);
function SSE_Register_To_Qwords is new Ada.Unchecked_Conversion(
   Source => SSE_Register,
   Target => SSE_PackedQwords
);






type SSE_PackedWords is record
   Words : array (0 .. 7) of Word; 
end record with Alignment=> SSE_Register'Size, Size=> SSE_Register'Alignment;
for SSE_PackedWords use record
   Words at 0 range 0 .. 127;
end record;
for SSE_PackedWords'Size use SSE_Register'Size;
for SSE_PackedWords'Alignment use SSE_Register'Alignment;

type SSE_PackedWords_PTR is access all SSE_PackedWords;

function SSE_Words_To_Register is new Ada.Unchecked_Conversion(
   Source => SSE_PackedWords,
   Target => SSE_Register
);
function SSE_Register_To_Words is new Ada.Unchecked_Conversion(
   Source => SSE_Register,
   Target => SSE_PackedWords
);










type SSE_PackedDwords is record
   Dwords : Array (0..4) of Dword with Component_Size=>DWord'Size;
end record with Alignment=> SSE_Register'Size, Size=> SSE_Register'Alignment;
for SSE_PackedDwords use record
   Dwords at 0 range 0 .. 127;
end record;
for SSE_PackedDwords'Size use SSE_Register'Size;
for SSE_PackedDwords'Alignment use SSE_Register'Alignment;

type SSE_PackedDwords_PTR is access all SSE_PackedDwords;

function SSE_Dwords_To_Register is new Ada.Unchecked_Conversion(
   Source => SSE_PackedDwords,
   Target => SSE_Register
);
function SSE_Register_To_Dwords is new Ada.Unchecked_Conversion(
   Source => SSE_Register,
   Target => SSE_PackedDwords
);


type SSE_PackedFloats is record
   Floats : array (0 .. 3) of Interfaces.IEEE_Float_32;
end record with Alignment=> SSE_Register'Size, Size=> SSE_Register'Alignment;
for SSE_PackedFloats use record
   Floats at 0 range 0 .. 127;
end record;
for SSE_PackedFloatsArray'Size use SSE_Register'Size;
for SSE_PackedFloatsArray'Alignment use SSE_Register'Alignment;

type SSE_PackedFloats_PTR is access all SSE_PackedFloats;

function SSE_Floats_To_Register is new Ada.Unchecked_Conversion(
   Source => SSE_PackedFloats,
   Target => SSE_Register
);
function SSE_Register_To_Floats is new Ada.Unchecked_Conversion(
   Source => SSE_Register,
   Target => SSE_PackedFloats
);




type SSE_PackedDoubles is record
   Doubles : array (0 .. 1) of Interfaces.IEEE_Float_64;
end record with Alignment=> SSE_Register'Size, Size=> SSE_Register'Alignment;
for SSE_PackedDoubles use record
   Doubles at 0 range 0 .. 127;
end record;
for SSE_PackedDoubles'Size use SSE_Register'Size;
for SSE_PackedDoubles'Alignment use SSE_Register'Alignment;

type SSE_PackedDoubles_PTR is access all SSE_PackedDoubles;

function SSE_Doubles_To_Register is new Ada.Unchecked_Conversion(
   Source => SSE_PackedDoubles,
   Target => SSE_Register
);
function SSE_Register_To_Doubles is new Ada.Unchecked_Conversion(
   Source => SSE_Register,
   Target => SSE_PackedDoubles
);




end IA32_Types;
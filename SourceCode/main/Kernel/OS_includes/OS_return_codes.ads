--enum GeneralOsRetCodes
--    {
--    SuccessCode = 0,
--    LOW8_GeneralOSErrorSpace = 2,
--    LOW8_GeneralOSErrorSpace_Extended1 =3, 
--        HIGH_OtherErrorBit = 0x0100,
--        HIGH_NULLptrErrorBit = 0x0200,
--        HIGH_InsertOverflowBit = 0x0400,
--        HIGH_ArrayInsertUnableBit = 0x0800,
--        HIGH_ArrayIndexOverflowBit = 0x1000,
--        HIGH_AllocationFailedBit = 0x2000,
--        HIGH_AllocationImpossibleBit = 0x4000,
--       HIGH_SpinlockWatchdogSetBit = 0x8000,
--
--       HIGH_TaskFulfilWithErrorBit = 0x80000000,
--    };

--IF THERE IS NO ERROR, RETURN ABSOLUTE 0

with Ada.Unchecked_Conversion;
with Interfaces;
package ReturnBitfields is

   type LOW8_ReturnSpace is 
   (
      SuccessCode,
      GeneralOS_ReturnSpace,
      GeneralOS_ReturnSpace_Extended1
   );
   for LOW8_ReturnSpace use
   (
      SuccessCode => 0,
      GeneralOS_ReturnSpace => 2,
      GeneralOS_ReturnSpace_Extended1 => 3
   );
   for LOW8_ReturnSpace'Size use 8;

type Return_Bitfield32_raw is record
   LOW8_returnValNameSpace : LOW8_ReturnSpace;
   Reserved8 : Boolean;
   Reserved9 : Boolean;
   Reserved10 : Boolean;
   Reserved11 : Boolean;
   Reserved12 : Boolean;
   Reserved13 : Boolean;
   Reserved14 : Boolean;
   Reserved15 : Boolean;
   Reserved16 : Boolean;
   Reserved17 : Boolean;
   Reserved18 : Boolean;
   Reserved19 : Boolean;
   Reserved20 : Boolean;
   Reserved21 : Boolean;
   Reserved22 : Boolean;
   Reserved23 : Boolean;
   Reserved24 : Boolean;
   Reserved25 : Boolean;
   Reserved26 : Boolean;
   Reserved27 : Boolean;
   Reserved28 : Boolean;
   Reserved29 : Boolean;
   Reserved30 : Boolean;
   FulfilledWithError : Boolean;
end record;
for Return_Bitfield32_raw use record
   LOW8_returnValNameSpace at 0 range 0 .. 7;

   Reserved8 at 0 range 8 .. 8;
   Reserved9 at 0 range 9 .. 9;
   Reserved10 at 0 range 10 .. 10;
   Reserved11 at 0 range 11 .. 11;
   Reserved12 at 0 range 12 .. 12;
   Reserved13 at 0 range 13 .. 13;
   Reserved14 at 0 range 14 .. 14;
   Reserved15 at 0 range 15 .. 15;

   Reserved16 at 0 range 16 .. 16;
   Reserved17 at 0 range 17 .. 17;
   Reserved18 at 0 range 18 .. 18;
   Reserved19 at 0 range 19 .. 19;
   Reserved20 at 0 range 20 .. 20;
   Reserved21 at 0 range 21 .. 21;
   Reserved22 at 0 range 22 .. 22;
   Reserved23 at 0 range 23 .. 23;

   Reserved24 at 0 range 24 .. 24;
   Reserved25 at 0 range 25 .. 25;
   Reserved26 at 0 range 26 .. 26;
   Reserved27 at 0 range 27 .. 27;
   Reserved28 at 0 range 28 .. 28;
   Reserved29 at 0 range 29 .. 29;
   Reserved30 at 0 range 30 .. 30;

   FulfilledWithError at 0 range 31 .. 31;
end record;
for Return_Bitfield32_raw'Size use 32;
function Returnfield32raw_To_int32 is new Ada.Unchecked_Conversion
   (
      Source => Return_Bitfield32_raw,
      Target => Interfaces.Integer_32
   );
function int32_To_Returnfield32raw is new Ada.Unchecked_Conversion
   (
      Source => Interfaces.Integer_32,
      Target => Return_Bitfield32_raw
   );


type GeneralOS is record
   ReturnValNameSpace : LOW8_ReturnSpace;
   OtherError : Boolean;
   NullPTR : Boolean; --use this when the error is related to NUll pointer
   InsertOverflow : Boolean;--Use this when there is no space left, and you can't push/add thing to stack/queue
   ArrayInsertUnable : Boolean;--Use this when you can't add thing to a static allocated memory region
   ArrayIndexOverflow : Boolean;--Use this when the index to insert you were given, is too big or wrong in some other way
   AllocationFailed : Boolean;--Use this when, for example, there is no free RAM left to alllocate
   AllocationImpossible : Boolean;--Use this when, for example, allocation requirements are impossible (Like 1 TB of RAM)
   WatchdogSet : Boolean;--Use this when you need to indicate that watchdog timer was for some reason set
   TooBigNumber : Boolean;--use this when the give argument is arithmetically too big, for example the float is Inf, or you want to set VGA mode too big
   TooSmallNumber : Boolean;--THe same as Too big, but for small numbers
   Reserved18 : Boolean;
   Reserved19 : Boolean;
   Reserved20 : Boolean;
   Reserved21 : Boolean;
   Reserved22 : Boolean;
   Reserved23 : Boolean;
   Reserved24 : Boolean;
   Reserved25 : Boolean;
   Reserved26 : Boolean;
   Reserved27 : Boolean;
   Reserved28 : Boolean;
   Reserved29 : Boolean;
   Reserved30 : Boolean;
   FulfilledWithError : Boolean;--Use this when you 
end record;

for GeneralOS use record
   ReturnValNameSpace   at 0 range 0..7;

   OtherError           at 0 range 8..8;
   NullPTR              at 0 range 9 .. 9;
   InsertOverflow       at 0 range 10 .. 10;
   ArrayInsertUnable    at 0 range 11 .. 11; 
   ArrayIndexOverflow   at 0 range 12 .. 12;
   AllocationFailed     at 0 range 13 .. 13;
   AllocationImpossible at 0 range 14 .. 14;
   WatchdogSet          at 0 range 15 .. 15;
   TooBigNumber         at 0 range 16 .. 16;
   TooSmallNumber       at 0 range 17 .. 17;

   Reserved18 at 0 range 18 .. 18;
   Reserved19 at 0 range 19 .. 19;
   Reserved20 at 0 range 20 .. 20;
   Reserved21 at 0 range 21 .. 21;
   Reserved22 at 0 range 22 .. 22;
   Reserved23 at 0 range 23..  23;
      
   Reserved24 at 0 range 24 .. 24;
   Reserved25 at 0 range 25 .. 25;
   Reserved26 at 0 range 26 .. 26;
   Reserved27 at 0 range 27 .. 27;
   Reserved28 at 0 range 28 .. 28;
   Reserved29 at 0 range 29 .. 29;
   Reserved30 at 0 range 30 .. 30;
   FulfilledWithError at 0 range 31 .. 31;
end record;
for GeneralOS'Size use 32;
function GeneralOS_To_int32 is new Ada.Unchecked_Conversion
   (Source=> GeneralOS, Target => Interfaces.Integer_32);
function int32_To_GeneralOS is new Ada.Unchecked_Conversion
   (Source => Interfaces.Integer_32, Target => GeneralOS);
function GeneralOS_To_Returnfield32raw is new Ada.Unchecked_Conversion
   (Source => GeneralOS, Target => Return_Bitfield32_raw);
function Returnfield32raw_To_GeneralOS is new Ada.Unchecked_Conversion
   (Source => Return_Bitfield32_raw, Target => GeneralOS);

end OS_return_codes;
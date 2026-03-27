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


package ReturnBitfields is

   type LOW8_ReturnSpace is 
   (
      GeneralOS_ReturnSpace,
      GeneralOS_ReturnSpace_Extended1
   );
   for LOW8_ReturnSpace use
   (
      GeneralOS_ReturnSpace => 2,
      GeneralOS_ReturnSpace_Extended1 => 3
   );

type GeneralOS is record
   ReturnValNameSpace : LOW8_ReturnSpace;
   OtherError : Boolean;
   NullPTR : Boolean;
   InsertOverflow : Boolean;
   ArrayInsertUnable : Boolean;
   ArrayIndexOverflow : Boolean;
   AllocationFailed : Boolean;
   AllocationImpossible : Boolean;
   SpinlockWatchdogSet : Boolean;
   TooBigNumber : Boolean;
   TooSmallNumber : Boolean;
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

for GeneralOS use record
   ReturnValNameSpace   at 0 range 0..7;

   OtherError        at 1 range 0..0;
   NullPTR           at 1 range 1 .. 1;
   InsertOverflow    at 1 range 2 .. 2;
   ArrayInsertUnable at 1 range 3 .. 3; 
   ArrayIndexOverflow at 1 range 4 .. 4;
   AllocationFailed at 1 range 5 .. 5;
   AllocationImpossible at 1 range 6 .. 6;
   SpinlockWatchdogSet at 1 range 7 .. 7;
      
   Reserved16 at 2 range 0 .. 0;
   Reserved17 at 2 range 1 .. 1;
   Reserved18 at 2 range 2 .. 2;
   Reserved19 at 2 range 3 .. 3;
   Reserved20 at 2 range 4 .. 4;
   Reserved21 at 2 range 5 .. 5;
   Reserved22 at 2 range 6 .. 6;
   Reserved23 at 2 range 7 .. 7;
      
   Reserved24 at 3 range 0 .. 0;
   Reserved25 at 3 range 1 .. 1;
   Reserved26 at 3 range 2 .. 2;
   Reserved27 at 3 range 3 .. 3;
   Reserved28 at 3 range 4 .. 4;
   Reserved29 at 3 range 5 .. 5;
   Reserved30 at 3 range 6 .. 6;
   Reserved31 at 3 range 7 .. 7;
end record;

   type GeneralOSReturnCodes_enum is 
   (
   SuccessCode,
   LOW8_GeneralOSErrorSpace,
   LOW8_GeneralOSErrorSpace_Extended1,
      HIGH_OtherErrorBit,
      HIGH_NULLptrErrorBit,
      HIGH_InsertOverflowBit,
      HIGH_ArrayInsertUnableBit,
      HIGH_ArrayIndexOverflowBit,
      HIGH_AllocationFailedBit,
      HIGH_AllocationImpossibleBit,
      HIGH_SpinlockWatchdogSetBit,


      HIGH_TaskFulfilWithErrorBit
   );
   for GeneralOSReturnCodes_enum use
   (
   SuccessCode = 0,
   LOW8_GeneralOSErrorSpace => 2,
   LOW8_GeneralOSErrorSpace_Extended1 => 3,
      HIGH_OtherErrorBit =>16#0100#,
      HIGH_NULLptrErrorBit =>16#0200#,
      HIGH_InsertOverflowBit =>16#0400#,
      HIGH_ArrayInsertUnableBit =>16#0800#,
      HIGH_ArrayIndexOverflowBit => 16#1000#,
      HIGH_AllocationFailedBit => 16#2000#,
      HIGH_AllocationImpossibleBit => 16#4000#,
      HIGH_SpinlockWatchdogSetBit => 16#8000#,

   
      HIGH_TaskFulfilWithErrorBit => 16#80000000#
   );

private

end OS_return_codes;
%ifndef OS_RETURN_CODES_NASM_SENTRY
%define OS_RETURN_CODES_NASM_SENTRY

%define NULL 0


struc ReturnBitfields_ReservedBitfield_BitIndexes
    .Reserved0 resb 1;
    .Reserved1 resb 1;
    .Reserved2 resb 1;
    .Reserved3 resb 1;
    .Reserved4 resb 1;
    .Reserved5 resb 1;
    .Reserved6 resb 1;
    .Reserved7 resb 1;
    .Reserved8 resb 1;
    .Reserved9 resb 1;
    .Reserved10 resb 1;
    .Reserved11 resb 1;
    .Reserved12 resb 1;
    .Reserved13 resb 1;
    .Reserved14 resb 1;
    .Reserved15 resb 1;
    .Reserved16 resb 1;
    .Reserved17 resb 1;
    .Reserved18 resb 1;
    .Reserved19 resb 1;
    .Reserved20 resb 1;
    .Reserved21 resb 1;
    .Reserved22 resb 1;
    .Reserved23 resb 1;
    .Reserved24 resb 1;
    .Reserved25 resb 1;
    .Reserved26 resb 1;
    .Reserved27 resb 1;
    .Reserved28 resb 1;
    .Reserved29 resb 1;
    .Reserved30 resb 1;
    .Reserved31 resb 1;
endstruc

struc ReturnBitfields_GeneralOS_BitIndexes
    .LOW8_ReturnValNameSpace resb 8
    .OtherError resb 1;
    .NullPTR resb 1;
    .InsertOverflow resb 1;
    .ArrayInsertUnable resb 1;
    .ArrayIndexOverflow resb 1
    .AllocationFailed resb 1;
    .AllocationImpossible resb 1;
    .SpinlockWatchdogSet resb 1;
    .TooBigNumber resb 1;
    .TooSmallNumber resb 1;
    .Reserved18 resb 1;
    .Reserved19 resb 1;
    .Reserved20 resb 1;
    .Reserved21 resb 1;
    .Reserved22 resb 1;
    .Reserved23 resb 1;
    .Reserved24 resb 1;
    .Reserved25 resb 1;
    .Reserved26 resb 1;
    .Reserved27 resb 1;
    .Reserved28 resb 1;
    .Reserved29 resb 1;
    .Reserved30 resb 1;
    .FulfilledWithError resb 1;
endstruc

struc ReturnBitfields_GeneralOSExtended1_BitIndexes
    .LOW8_ReturnValNameSpace resb 8
    .Reserved8 resb 1;
    .Reserved9 resb 1;
    .Reserved10 resb 1;
    .Reserved11 resb 1;
    .Reserved12 resb 1;
    .Reserved13 resb 1;
    .Reserved14 resb 1;
    .Reserved15 resb 1;
    .Reserved16 resb 1;
    .Reserved17 resb 1;
    .Reserved18 resb 1;
    .Reserved19 resb 1;
    .Reserved20 resb 1;
    .Reserved21 resb 1;
    .Reserved22 resb 1;
    .Reserved23 resb 1;
    .Reserved24 resb 1;
    .Reserved25 resb 1;
    .Reserved26 resb 1;
    .Reserved27 resb 1;
    .Reserved28 resb 1;
    .Reserved29 resb 1;
    .Reserved30 resb 1;
    .Reserved31 resb 1;
endstruc


%define SuccessCode 0
%define LOW8_GeneralOS_ReturnNameSpace 2
%define LOW8_GeneralOS_ReturnNameSpace_Extended1 3
    %define HIGH_Other 1<<GeneralOS_RETRN_BitField_BitIndexes.OtherError
    %define HIGH_NullPTR 1<<GeneralOS_RETRN_BitField_BitIndexes.NullPTR
    %define HIGH_InsertOverflow 1<<GeneralOS_RETRN_BitField_BitIndexes.InsertOverflow
    %define HIGH_ArrayInsertUnable 1<<GeneralOS_RETRN_BitField_BitIndexes.ArrayInsertUnable
    %define HIGH_ArrayIndexOverflow 1<<GeneralOS_RETRN_BitField_BitIndexes.ArrayIndexOverflow
    %define HIGH_AllocationFailed 1<<GeneralOS_RETRN_BitField_BitIndexes.AllocationFailed
    %define HIGH_AllocationImpossible 1<<GeneralOS_RETRN_BitField_BitIndexes.AllocationImpossible
    %define HIGH_SpinlockWatchdogSet 1<<GeneralOS_RETRN_BitField_BitIndexes.SpinlockWatchdogSet
    %define HIGH_TooBigNumber 1<<GeneralOS_RETRN_BitField_BitIndexes.TooBigNumber
    %define HIGH_TooSmallNumber 1<<GeneralOS_RETRN_BitField_BitIndexes.TooSmallNumber

    %define HIGH_FulfilledWithError 1<<GeneralOS_RETRN_BitField_BitIndexes.FulfilledWithError

%endif
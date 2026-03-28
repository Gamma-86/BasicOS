#ifndef OS_RETURN_CODES_H_SENTRY
#define OS_RETURN_CODES_H_SENTRY

enum ReturnBitfields_GeneralOS_BitIndexes
    {
        LOW8_ReturnValNameSpace = 0,
        OtherError = 8,
        Nullptr,
        InsertOverflow,
        ArrayInsertUnable,
        ArrayIndexOverflow,
        AllocationFailed,
        AllocationImpossible,
        SpinlockWatchdogSet,
        TooBigNumber,
        TooSmallNumber,
        Reserved18,
        Reserved19,
        Reserved20,
        Reserved21,
        Reserved22,
        Reserved23,
        Reserved24,
        Reserved25,
        Reserved26,
        Reserved27,
        Reserved28,
        Reserved29,
        Reserved30,
        FulfilledWithError,
    };

#define NULL ((void*)0)

#endif
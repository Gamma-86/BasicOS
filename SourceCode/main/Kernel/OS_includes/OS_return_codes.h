#ifndef OS_RETURN_CODES_H_SENTRY
#define OS_RETURN_CODES_H_SENTRY

enum LOW8_return_errorspaces{
    SuccessCode = 0,
    LOW8_GeneralOS = 2,
    LOW8_GeneralOS_Extended1,
};

enum ReturnBitfields_GeneralOS_BitIndexes
{
    GeneralOS_OtherError = 8,
    GeneralOS_Nullptr,
    GeneralOS_InsertOverflow,
    GeneralOS_ArrayInsertUnable,
    GeneralOS_ArrayIndexOverflow,
    GeneralOS_AllocationFailed,
    GeneralOS_AllocationImpossible,
    GeneralOS_WatchdogSet,
    GeneralOS_TooBigNumber,
    GeneralOS_TooSmallNumber,
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
    GeneralOS_FulfilledWithError,
};

#ifndef NULL
#define NULL ((void*)0)
#endif

#endif
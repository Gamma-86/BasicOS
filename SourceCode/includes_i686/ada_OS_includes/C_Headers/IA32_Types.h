#ifndef IA32_TYPES_H_SENTRY
#define IA32_TYPES_H_SENTRY

typedef unsigned char Byte;
typedef signed char Byte_S;

typedef unsigned short int Word;
typedef signed short int Word_S;

typedef unsigned int Dword;
typedef signed int Dword_S;

typedef unsigned long long Qword;
typedef signed long long Qword_S;

typedef long double X87_Float;



enum IA32_X87_PrecisionModes{
    X87_Single = 0,
    X87_Double = 2,
    X87_Double_Extended = 3,
};

enum IA32_Float_RoundingModes{
    Round_To_Nearest = 0,
    Round_To_M_Inf = 1,
    Round_To_P_Inf = 2,
    Round_To_Zero = 3,
};

enum X87_RegisterTagStatus{
   X87Reg_Valid = 0,
   X87Reg_Zero = 1,
   X87Reg_Special = 2,
   X87Reg_Empty = 3
};






typedef unsigned long long MMX_Qword;

struct MMX_PackedBytes {
    Byte Bytes[8];
};
struct MMX_PackedWords{
    Word Words[4];
};
struct MMX_PackedDwords{
    Dword Dwords[2];
};

union IA32_MMX_Register{
    MMX_Qword Qword;
    MMX_PackedDwords Packed_Dwords;
    MMX_PackedWords  Packed_Words;
    MMX_PackedBytes  Packed_Bytes;
};







union IA32_SSE_Register{
    Byte  PackedBytes[16];
    Word  PackedWords[8] ;
    Dword PackedDwords[4];
    Qword PackedQwords[2];

    float  PackedFloats[4];
    double PackedDoubles[2];
};



#endif
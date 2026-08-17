#ifndef IA32LIB_BITWISE_ARITHMETIC_H_SENTRY
#define IA32LIB_BITWISE_ARITHMETIC_H_SENTRY
#include <stdint.h>

uint32_t BitScanForward16(uint16_t scanned_thing);
uint32_t BitScanForward32(uint32_t scanned_thing);

uint32_t BitScanReverse16(uint16_t scanned_thing);
uint32_t BitScanReverse32(uint32_t scanned_thing);

unsigned char BitTest16(uint16_t Bitfield, unsigned char Bit_index);
unsigned char BitTest32(uint32_t Bitfield, unsigned char Bit_index);

unsigned char BitTestSet16(uint16_t* Bitfield, unsigned char Bit_index);
unsigned char BitTestSet32(uint32_t* BitFIeld, unsigned char Bit_index);

unsigned char BitPopCount8(unsigned char BitField);
unsigned char BitPopCount16(uint16_t BitField);


uint32_t X_1Bits_PopCount(unsigned char* Bitfield_Array, uint16_t Size);
uint32_t X_0Bits_PopCount(unsigned char* Bitfield_Array, uint16_t Size);


#endif
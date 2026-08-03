#ifndef ATOMICOPERATIONS_H_SENTRY
#define ATOMICOPERATIONS_H_SENTRY 

#include <stdint.h>

void Bool_Lock(unsigned char* LockingBool);
unsigned char Bool_Lock_Watchdog(unsigned char* LockingBool, unsigned int WatchdogTime);
void Bool_Unlock(unsigned char* LockingBool);



void Locked_increment8(char* Incremented);
void Locked_increment16(unsigned short* Incremented);
void Locked_increment32(uint32_t* Incremented);
void Locked_increment64(uint64_t* Incremented);

void Locked_decrement8(unsigned char* Decremented);
void Locked_decrement16(unsigned short* Decremented);
void Locked_decrement32(uint32_t* Decremented);
void Locked_decrement64(uint64_t* Decremented);



unsigned char Locked_uadd8(unsigned char* increased, unsigned char increase);
signed char Locked_sadd8(signed char* increased, signed char increase);

uint16_t Locked_uadd16(uint16_t* increased, uint16_t increase);
int16_t Locked_sadd16( int16_t* increased, int16_t increase);

uint32_t Locked_uadd32(uint32_t* increased, uint32_t increase);
int32_t  Locked_sadd32(int32_t*  increased, int32_t  increase);

uint64_t Locked_uadd64(uint64_t* increased, uint64_t increase);
int64_t Locked_sadd64(int64_t* increased, int64_t increase);

#endif
#ifndef INITIALALLOCATOR_H_SENTRY
#define INITIALALLOCATOR_H_SENTRY
#include <stdint.h>
int32_t Arena1_initial_malloc(void** PTR, uint32_t size);//Allocates RAM from arena, returns 0 or GeneralOS bitfield
int32_t Arena1_initial_calloc(void** PTR, uint32_t size);//Allocates memory from Arena initializes with 0, returns 0 or GeneralOS bitfield
void Arena1_initial_free(void* PTR); //Tries to free Arena part, if anything wrong, does not
void Arena1_reset(); //Initializes arena to inital values

#endif
#ifndef INITIALALLOCATOR_H_SENTRY
#define INITIALALLOCATOR_H_SENTRY
#include <stdint.h>
int32_t Arena1_initial_malloc(void** PTR, unsigned int size);
int32_t Arena1_initial_calloc(void** PTR, unsigned int size);
void Arena1_initial_free(void* PTR);
void Arena1_reset();

#endif
#ifndef C_STACK_ALLOCATION_H_SENTRY
#define C_STACK_ALLOCATION_H_SENTRY

#if 0
#include <alloca.h>
#define COMPILER_STACK_ALLOCATE_FUN alloca
#endif

#if 0
#define COMPILER_STACK_ALLOCATE_FUN void* __cdecl _alloca(unsigned int);
#endif

#if 0
#define COMPILER_STACK_ALLOCATE_FUN __builtin_alloca
#endif


#endif
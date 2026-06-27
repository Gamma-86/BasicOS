#include <stdio.h>
#include "InitialAllocators.h"
#include <stdint.h>

int main(){
    //Test allocation and writing of 4 bytes
    {
        int* Test_PTR = NULL;
        int32_t Returned_status = 0;

        printf("First test: Allocation and writing of 4 bytes \n");
        Returned_status = Arena1_initial_malloc((void**)&Test_PTR, 4);
        printf("Here is returned pointer (It was NULL before) %p", Test_PTR);
        printf("Here is the returned ErorSpace: %d \n", Returned_status&0xFF);
        printf("Here is the returned error bitfield in octal %o: \n", (Returned_status&~0xFF)>>8);

        if (!Test_PTR){
            *Test_PTR = 0xDEADBEEF;
            printf("Here is int at the location of pointer: %X \n", *Test_PTR);
        }
        else{
            printf("Cant write and print int at pointer location cause NULL pointer \n");
        }
    }

    return 0;
}
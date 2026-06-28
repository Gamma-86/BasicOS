#include <stdio.h>
#include "InitialAllocators.h"
#include <stdint.h>
#include "OS_return_codes.h"

int main(){
    //Test allocation and writing of 4 bytes
    {
        int* Test_PTR = NULL;
        int* Test_PTR2 = NULL;
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
            printf("Cant write and print int at pointer location cause NULL pointer \n\n\n");
        }

        printf("Now trying to free this memory and then allocating/comparing pointers\n");
        Arena1_initial_free((void*)Test_PTR);
        printf("Freed the arena, now allocating the same size(4) \n");
        Returned_status = Arena1_initial_malloc((void**)&Test_PTR2, 4);
        printf("Allocated Part of Arena, the same as before \n");

        printf("Here is the returned ErorSpace: %d \n", Returned_status&0xFF);
        printf("Here is the returned error bitfield in octal %o: \n", (Returned_status&~0xFF)>>8);

        if (!Test_PTR){
            printf("Here are pointers themselves: TestPTR-%p , TestPTR2-%p", Test_PTR, Test_PTR2);
            printf("Here is int at the location of pointer: %X \n", *Test_PTR2);

        }
        else{
            printf("Cant write and print int at pointer location cause NULL pointer \n\n\n");
        }


    }
    test_calloc_function();


    return 0;
}






void test_calloc_function(void){
    int* Test_PTR_calloc = NULL;
    int32_t Returned_status = 0;
   
    printf("Now testing initial calloc function of reset arena1\n");
    Arena1_reset();
    Returned_status = Arena1_initial_calloc(&Test_PTR_calloc, 4);
    printf("Callocated 4 bytes\n");
    printf("Here is the pointer %p", Test_PTR_calloc);

    printf("Here is the returned ErorSpace: %d \n", Returned_status&0xFF);
    printf("Here is the returned error bitfield in octal %o: \n", (Returned_status&~0xFF)>>8);

    if(Returned_status){
        decode_error_bitfield((uint64_t)Returned_status);
    }
}

void decode_error_bitfield(int64_t return_bitfield){
    switch (return_bitfield & 0xFF)
    {
    case 0:
        printf("The bitfield has no errors\n");
    case LOW8_GeneralOS:
        printf("The bitfield is GeneralsOS\n");
        if(return_bitfield < 0){
            printf("The task was FULFILLED with Error\n");
        }
        if(return_bitfield & (1<<GeneralOS_OtherError)){
            printf("\t Error - Other Error\n");
        }
        if(return_bitfield & (1<<GeneralOS_Nullptr)){
            printf("\t Error - NULL pointer\n");
        }
        if(return_bitfield & (1<<GeneralOS_InsertOverflow)){
            printf("\t Error - Data Insert, Overflow\n");
        }
        if(return_bitfield & (1<<GeneralOS_ArrayInsertUnable)){
            printf("\t Error - Unable to insert data\n");
        }
        if(return_bitfield & (1<<GeneralOS_AllocationFailed)){
            printf("\t Error - Allocation failed, not enough space\n");
        }
        if(return_bitfield & (1<<GeneralOS_AllocationImpossible)){
            printf("\t Error - Allocation impossible, the thing is too much\n");
        }
        if(return_bitfield & (1<<GeneralOS_WatchdogSet)){
            printf("\t Error - Watchdog timer has expired\n");
        }
        if(return_bitfield & (1<<GeneralOS_TooBigNumber)){
            printf("\t Errpr - The number is too big arithmetically\n");
        }
        if(return_bitfield & (1<<GeneralOS_TooSmallNumber)){
            printf("\t Error - The number is too small arithmetically\n");
        }
 
        break;
    case LOW8_GeneralOS_Extended1:
        printf("The bitfield is GeneralsOS_Extended1\n");
        if(return_bitfield < 0){
            printf("The task was FULFILLED with Error\n");
        }

        break;
    default:
        printf("The unknown return errorspace when decoding bitfield \n");

        break;
    }
}
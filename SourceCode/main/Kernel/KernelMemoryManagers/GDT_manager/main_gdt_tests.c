#include <stdint.h>
#include <stdio.h>

struct GDT_descriptor{
    uint16_t limit;
    uintptr_t GDT_PTR;
};

extern uint64_t MainGDT_start[8192];

extern struct GDT_descriptor MainGDT_Descriptor;

extern uint16_t GDT_Stack_Pointer;
extern uint16_t globASM_FUN_GDT_pushDescriptor(uint64_t Descriptor);

extern void globASM_FUN_lgdt(struct GDT_descriptor* GDT_descriptor);
extern void globASM_FUN_sgdt(struct GDT_descriptor* Where_Load_GDT_descriptor);




int main (){
    printf("Initial GDT state : %x, %x, %x \n", MainGDT_start[0], MainGDT_start[1], MainGDT_start[2], MainGDT_start[3]);
    printf("Intial GDT descriptor state : %d, PTR: %p \n", MainGDT_Descriptor.limit, MainGDT_Descriptor.GDT_PTR);
    uint64_t test_val = 0;

    globASM_FUN_GDT_pushDescriptor(test_val);

    printf("Post GDT state : %x, %x, %x \n", MainGDT_start[0], MainGDT_start[1], MainGDT_start[2], MainGDT_start[3]);
    printf("Post GDT descriptor state : %d, PTR: %p \n", MainGDT_Descriptor.limit, MainGDT_Descriptor.GDT_PTR);


    return 0;
}
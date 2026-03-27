struct multiboot2_info {
    unsigned int total_size;
    unsigned int reserved;  /*0*/  
    char tags[];       
};
struct mb2_tag_head {
    unsigned int type;
    unsigned int size;
    char data[];
};

int kernel_main(unsigned int EAX_magic, void* EBX_BootStructure){
    return 0;
}
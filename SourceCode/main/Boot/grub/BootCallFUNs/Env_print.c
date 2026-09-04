struct VGAText_Char{
    unsigned char Char;
    unsigned char Atrib;
};





struct VGAText_Char (*VGA_80x25Colour_Screen)[80] = (struct VGAText_Char (*)[80]) 0xB8000;
struct VGAText_Char (*VGA_80x25Mono_Screen)[80] = (struct VGAText_Char (*)[80]) 0xB0000;
struct VGAText_Char (*VGA_40x25Colour_Screen)[40] = (struct VGAText_Char (*)[40])0xB8000;
unsigned char (*VGA_320x200x256)[320] = (unsigned char (*)[320])0xA0000;

enum Screen_Mode{
    VGA0h = 0,
    VGA1h,
    VGA2h,
    VGA_8025_TXT = 3,
    VGA4h,
    VGA5h,
    VGA6h,
    VGA7h,

    VGADh = 0xD,
    VGAEh,
    VGAFh,
    VGA10h,
    VGA11h,
    VGA_640x480x16 = 0x12,
    VGA_320x200x256 = 0x13,

    COM1_Console = 0x20,
    COM2_Console,
    COM3_Console,
};




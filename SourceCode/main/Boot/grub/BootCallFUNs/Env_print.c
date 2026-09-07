#include "ASCII_8x8_Font.h"


struct VGAText_Char{
    unsigned char Char;
    unsigned char Atrib;
};



static struct VGAText_Char* VGA_ColourTXT_VRAM_PTR = (struct VGAText_Char*)0xB8000;
static struct VGAText_Char* VGA_MonoTXT_VRAM_PTR = (struct VGAText_Char*)0xB0000;

static struct VGAText_Char (*VGA_8025TXT_ColourScreen)[80] = (struct VGAText_Char (*)[80]) 0xB8000;
static struct VGAText_Char (*VGA_4025TXT_ColourScreen)[40] = (struct VGAText_Char (*)[40]) 0xB8000;
static struct VGAText_Char (*VGA_8025TXT_MonoScreen)[80] = (struct VGAText_Char (*)[80]) 0xB0000;
static unsigned char (*VGA_320x200x256)[320] = (unsigned char (*)[320])0xA0000;

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
    COM4_Console,

    LPT1_Console,
    LPT2_Console,
    LPT3_Console,
    LPT4_Console,
};



struct Screen_state{
    enum Screen_Mode Current_mode;
    unsigned char Cursor_X;
    unsigned char Cursor_Y;
    unsigned char COM_initialized;
    unsigned char X_Size;
    unsigned char Y_Size;
}CurntScreen_Info={
    .Current_mode = VGA_8025_TXT,
    .Cursor_X = 0,
    .Cursor_Y = 0,
    .COM_initialized = 0,
    .X_Size = 80,
    .Y_Size = 25,
};

static void Init_Printing(unsigned char Screen_Mode, unsigned int Width, unsigned char Height){
    
}

static int printEnv_str(char* the_string){

    return;
}







static void ShiftCharsVGA_TXTcolour(unsigned char Is_40x25){
/*
    0-create VGA text character initalized with 0
    1-determine if VGA line is 40 or 80 characters
    2-if screen line is 40 character
       2.1-Start from the y=1 x=0
       2.2- move every 40 characters to the previous line(y-1) for all lines
       2.3-initialize last line(24) with 0
    3-if screen line is 80 characters
       3.1-start from y=1 x=0
       3.2=move every char in line to the previous(y-1) line for all lines(25)
       3.3-overwrite last line(y=24) with 0

    4- i think this is the end
*/
    //0
    struct VGAText_Char ZeroChar = {0};
    //1
    if(Is_40x25){
        for(unsigned char y=1; y<25; y++){  //2.1
            for(unsigned char x=0; x<40; x++){//2.1
                //2.2
                VGA_4025TXT_ColourScreen[y-1][x] = VGA_4025TXT_ColourScreen[y][x];
            }
        }
        for(unsigned char x=0; x<40; x++){
            //2.3
            VGA_4025TXT_ColourScreen[24][x]=ZeroChar;
        }
    }
    else if(CurntScreen_Info.X_Size==80){//3
        for(unsigned char y=1; y<25; y++){//3.1
            for(unsigned char x=0; x<80; x++){//3.1
                //3.2
                VGA_8025TXT_ColourScreen[y-1][x]=VGA_8025TXT_ColourScreen[y][x];
            }
        }
        for(unsigned char x=0; x<80; x++){
            //3.3
            VGA_8025TXT_ColourScreen[79][x] = ZeroChar;
        }
    }

    //4
    return;
};

static void print_VGAtxt_colour(char Character,char Colour, char BackColour, char Is_40x25){
    enum{
        ColourBitmask = 0xF,
        ColourBitIndex = 0,
        BackColourBitmask = 0xF,
        BackColourBitIndex = 4,
    };
    unsigned char Attribute = \
        ((Colour&ColourBitmask)<<ColourBitIndex)\
        | ((BackColour&BackColourBitmask)<<BackColourBitIndex);
    struct VGAText_Char WrittenChar = {
        .Char = Character,
        .Atrib = Attribute,
    };

    unsigned char X = CurntScreen_Info.Cursor_X;
    unsigned char Y = CurntScreen_Info.Cursor_Y;

    if(Is_40x25){
        VGA_4025TXT_ColourScreen[X][Y] = WrittenChar;
    }
    else {
        VGA_8025TXT_ColourScreen[X][Y] = WrittenChar;
    }

    CurntScreen_Info.Cursor_X++;
    if(CurntScreen_Info.Cursor_X>=CurntScreen_Info.X_Size){
        CurntScreen_Info.Cursor_X = 0;
        CurntScreen_Info.Cursor_Y++;
    }
    if(CurntScreen_Info.Cursor_Y>=CurntScreen_Info.Y_Size){
        CurntScreen_Info.Cursor_Y=CurntScreen_Info.Y_Size-1;
        ShiftCharsVGA_TXTcolour(Is_40x25);
    }
    return;
}




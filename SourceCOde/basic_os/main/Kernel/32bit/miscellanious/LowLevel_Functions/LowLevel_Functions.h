#ifndef LOWLEVEL_FUNCTIONS_H_SENTRY
#define LOWLEVEL_FUNCTIONS_H_SENTRY

void globASM_FUN_outb(unsigned short int PortAddress, unsigned char TheByte);
void outb(unsigned short int PortAddress, unsigned char TheByte);

void outw(unsigned short int PortAddress, unsigned short int TheByte);
void globASM_FUN_outw(unsigned short int PortAddress, unsigned short int TheByte);

void outd(unsigned short int PortAddress, unsigned int TheDoubleWord);
void globASM_FUN_outd(unsigned short int PortAddress, unsigned int TheDoubleWord);


void set_IOPL_minLvl(char level);


#endif
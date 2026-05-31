#ifndef LOWLEVEL_FUNCTIONS_H_SENTRY
#define LOWLEVEL_FUNCTIONS_H_SENTRY

void globASM_FUN_outb(unsigned short int PortAddress, unsigned char TheByte);
void outb(unsigned short int PortAddress, unsigned char TheByte);

void outw(unsigned short int PortAddress, unsigned short int TheByte);
void globASM_FUN_outw(unsigned short int PortAddress, unsigned short int TheByte);

void outd(unsigned short int PortAddress, unsigned int TheDoubleWord);
void globASM_FUN_outd(unsigned short int PortAddress, unsigned int TheDoubleWord);



unsigned char inB(unsigned short int PortAddress);
unsigned char globASM_FUN_inB(unsigned short int PortAddress);

unsigned short int inW(unsigned short int PortAddress);
unsigned short int globASM_FUN_inW(unsigned short int PortAddress);

unsigned int inD(unsigned short int PortAddress);
unsigned int globASM_FUN_inD(unsigned short int PortAddress);


void set_IOPL_minLvl(char level);

void WRMSR_ (unsigned int WhereWrite, unsigned long long WhatWrite);
void Write_ModelSpecific_Register \
    (unsigned int WhereWrite, unsigned long long WhatWrite);

unsigned long long RDMSR_(unsigned int WhereRead);
unsigned long long Read_ModelSpecific_Register(unsigned int WhereRead);

#endif
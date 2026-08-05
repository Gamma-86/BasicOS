#ifndef LOWLEVEL_FUNCTIONS_H_SENTRY
#define LOWLEVEL_FUNCTIONS_H_SENTRY
#include <stdint.h>


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




size_t get_CR0();
size_t globASM_FUN_get_CR0();

size_t get_CR2();
size_t globASM_FUN_get_CR2();

size_t get_CR3();
size_t globASM_FUN_get_CR3();

size_t get_CR4();
size_t globASM_FUN_get_CR4();



void write_CR0(size_t Control_Register);
void globASM_FUN_write_CR0(size_t Control_Register);

void write_CR2(size_t Control_Register);
void globASM_FUN_write_CR2(size_t Control_Register);

void write_CR3(size_t Control_Register);
void globASM_FUN_write_CR3(size_t Control_Register);

void write_CR4(size_t Control_Register);
void globASM_FUN_write_CR4(size_t Control_Register);


struct CPUID_Return{
    uint64_t AX;
    uint64_t BX;
    uint64_t CX;
    uint64_t DX;
};
void globASM_FUN_CPUID(struct CPUID_Return* Return_Info, uint32_t Leaf, uint32_t Subleaf);

#endif
with Interfaces;
with System;
with X86_paging;
with X86_segments;
with IA32_Types;use IA32_Types;
package IA32_Hardware_Registers is
   

type EFlags_register_r is record
   Carry_Flag   : Boolean;
   Always1     : X86_segments.Always_1Bool_t;
   Parity_Flag : Boolean;
   Reserved3   : X86_segments.Always_0Bool_t;
   Auxilliary_Flag : Boolean;
   Reserved5   : X86_segments.Always_0Bool_t;
   Zero_Flag   : Boolean;
   Sign_Flag   : Boolean;

   Trap_Flag   : Boolean;
   Interrupt_Enabled : Boolean;
   Direction_Flag : Boolean;
   Overflow_Flag  : Boolean;
   IO_Privlge_LVL : X86_segments.Privelege_LVL_t;
   Nested_Task    : Boolean;

   Reserved15     : X86_segments.Always_0Bool_t;
   Resume_Flag    : Boolean;
   V8086_Flag     : Boolean;
   Alignment_Check : Boolean;
   Virt_Int_Flag  : Boolean;
   Virt_Int_Pending:Boolean;
   Identification_Flag : Boolean;

   Reserved_22_31 : Interfaces.Unsigned_16 range 0 .. 0; 
end record
with Size => 32;
for EFlags_register_r use record
   Carry_Flag at 0 range 0 .. 0;
   Always1 at 0 range 1 .. 1;
   Parity_Flag at 0 range 2 .. 2;
   Reserved3 at 0 range 3 .. 3;
   Auxilliary_Flag at 0 range 4 .. 4;
   Reserved5 at 0 range 5 .. 5;
   Zero_Flag at 0 range 6 .. 6;
   Sign_Flag at 0 range 7 .. 7;

   Trap_Flag at 0 range 8 .. 8;
   Interrupt_Enabled at 0 range 9 .. 9;
   Direction_Flag at 0 range 10 .. 10;
   Overflow_Flag at 0 range 11 .. 11;
   IO_Privlge_LVL at 0 range 12 .. 13;
   Nested_Task at 0 range 14 .. 14;
   Reserved15 at 0 range 15 .. 15;

   Resume_Flag at 0 range 16 .. 16;
   V8086_Flag at 0 range 17 .. 17;
   Alignment_Check at 0 range 18 .. 18;
   Virt_Int_Flag at 0 range 19 .. 19;
   Virt_Int_Pending at 0 range 20 .. 20;
   Identification_Flag at 0 range 21 .. 21;

   Reserved_22_31 at 0 range 22 .. 31;
end record;
for EFlags_register_r'Size use 32;




--############################################################################
--############################################################################
--
--    Control Registers
--
--############################################################################
--############################################################################

type Control_Register1_r is record
   Protection_Enable : Boolean;
   Monito_FPU        : Boolean;
   Emulation_FPU     : Boolean;
   Task_Switched     : Boolean;
   Support_387       : Boolean;
   Numeric_Error_X87_Mode : Boolean;
   Reserved_6_15     : Interfaces.Unsigned_16 range 0 .. 0;
   Write_Protect     : Boolean;
   Reserved17        : Always_0Bool_t;
   Alignment_Mask    : Boolean;
   Reserved_19_28    : Interfaces.Unsigned_16 range 0 .. 0;
   Not_Write_Through : Boolean;
   Cache_Disbled     : Boolean;
   Paging_Enable     : Boolean; 
end record 
with Size => 32;
for Control_Register1_r use record
   Protection_Enable at 0 range 0 .. 0;
   Monito_FPU at 0 range 1 .. 1;
   Emulation_FPU at 0 range 2 .. 2;
   Task_Switched at 0 range 3 .. 3;
   Support_387 at 0 range 4 .. 4;
   Numeric_Error_X87_Mode at 0 range 5 .. 5;
   Reserved_6_15 at 0 range 6 .. 15;
   Write_Protect at 0 range 16 .. 16;
   Reserved17 at 0 range 17 .. 17;
   Alignment_Mask at 0 range 18 .. 18;
   Reserved_19_28 at 0 range 19 .. 28;
   Not_Write_Through at 0 range 29 .. 29;
   Cache_Disbled at 0 range 30 .. 30;
   Paging_Enable at 0 range 31 .. 31;
end record;
for Control_Register1_r'Size use 32;


type Control_Register2 is new System.Address;


type Control_Register3_r is record
   Reserved_0_2  :  Integer range 0 .. 0;
   Page_Write_Through : Boolean;
   Page_Cache_Disabled : Boolean;
   Reserved_5_11  : Integer range 0 .. 0;
   Page_Directory_Base : X86_paging.Paging_Base_Address_t;
end record;


type Control_Register4_r is record 
   V8086_Extension : Boolean;
   Protected_Virt_Int : Boolean;
   Time_RDTSC_Disable : Boolean;
   Debug_Reg45_Disable  : Boolean;
   Page_Size_Big_Enable : Boolean;
   Physical_Address_Extension : Boolean;
   Machine_Check_Enable : Boolean;
   Enable_Global_Pages  : Boolean;
   RDPMC_Enable         : Boolean;
   FXSave_SSE_Enable    : Boolean;
   SSE_Specific_Int_Enable : Boolean;

   Reserved_0           : Integer range 0 .. 0;
end record with Size => 32;
for Control_Register4_r use record
   V8086_Extension at 0 range 0 .. 0;
   Protected_Virt_Int at 0 range 1 .. 1;
   Time_RDTSC_Disable at 0 range 2 .. 2;
   Debug_Reg45_Disable at 0 range 3 .. 3;
   Page_Size_Big_Enable at 0 range 4 .. 4;
   Physical_Address_Extension at 0 range 5 .. 5;
   Machine_Check_Enable at 0 range 6 .. 6;
   Enable_Global_Pages at 0 range 7 .. 7;
   RDPMC_Enable at 0 range 8 .. 8;
   FXSave_SSE_Enable at 0 range 9 .. 9;
   SSE_Specific_Int_Enable at 0 range 10 .. 10;

   Reserved_0 at 0 range 11 .. 31;
end record;
for Control_Register4_r'Size use 32;




--############################################################################
--############################################################################
--
--    X87
--
--############################################################################
--############################################################################

type X87_StatusWord is record
   Invalid_Operaiton : Boolean;
   Denormalized_Operand : Boolean;
   Zero_Division     : Boolean;
   Overflow          : Boolean;
   Underflow         : Boolean;
   Precision_Loss    : Boolean;
   Stack_Fault       : Boolean;
   Error_Happened    : Boolean;
   Condition0        : Boolean;
   Condition1        : Boolean;
   Condition2        : Boolean;
   StackTop          : X87_StackPointer;
   Condition3        : Boolean;
   Is_Busy           : Boolean;
end record with Size => 16;
for X87_StatusWord use record
   Invalid_Operaiton at 0 range 0 .. 0;
   Denormalized_Operand at 0 range 1 .. 1;
   Zero_Division at 0 range 2 .. 2;
   Overflow at 0 range 3 .. 3;
   Underflow at 0 range 4 .. 4;
   Precision_Loss at 0 range 5 .. 5;
   Stack_Fault at 0 range 6 .. 6;
   Error_Happened at 0 range 7 .. 7;
   Condition0 at 0 range 8 .. 8;
   Condition1 at 0 range 9 .. 9;
   Condition2 at 0 range 10 .. 10;
   StackTop at 0 range 11 .. 13;
   Condition3 at 0 range 14 .. 14;
   Is_Busy at 0 range 15 .. 15;
end record;
for X87_StatusWord'Size use 16;

type X87_StatusWord_PTR is access all X87_StatusWord;





type X87_ControlWord is record
   Invalid_Operaiton     : Boolean;
   Denormalized_Operand  : Boolean;
   Zero_Division         : Boolean;
   Overflow              : Boolean;
   Underflow             : Boolean;
   Precision_Loss        : Boolean;

   Precision_Control     : X87_Precision_Modes;
   Rounding_Control      : Rounding_Modes;

   Infinity_Control287   : Boolean;
end record with Size => 16;
for X87_ControlWord use record
   Invalid_Operaiton at 0 range 0 .. 0;
   Denormalized_Operand at 0 range 1 .. 1;
   Zero_Division at 0 range 2 .. 2;
   Overflow at 0 range 3 .. 3;
   Underflow at 0 range 4 .. 4;
   Precision_Loss at 0 range 5 .. 5;

   Precision_Control at 0 range 8 .. 9;
   Rounding_Control at 0 range 10 .. 11;

   Infinity_Control287 at 0 range 12 .. 12;
end record;

type X87_ControlWord_PTR is access all X87_ControlWord;












type X87_TagWord is record
   TAg0 : X87_RegisterStatus;
   Tag1 : X87_RegisterStatus;
   Tag2 : X87_RegisterStatus;
   Tag3 : X87_RegisterStatus;
   Tag4 : X87_RegisterStatus;
   Tag5 : X87_RegisterStatus;
   Tag6 : X87_RegisterStatus;
   Tag7 : X87_RegisterStatus;
end record with Size => 16;
for X87_TagWord use record
   Tag0 at 0 range 0 .. 1;
   Tag1 at 0 range 2 .. 3;
   Tag2 at 0 range 4 .. 5;
   Tag3 at 0 range 6 .. 7;
   Tag4 at 0 range 8 .. 9;
   Tag5 at 0 range 10 .. 11;
   Tag6 at 0 range 12 .. 13;
   Tag7 at 0 range 14 .. 15;
end record;
for X87_TagWord'Size use 16;

type X87_TagWord_PTR is access all X87_TagWord;







type X87_BCD_Reg is record
   Digit0    : BCD;
   Digit1    : BCD;
   Digit2    : BCD;
   Digit3    : BCD;
   Digit4    : BCD;
   Digit5    : BCD;
   Digit6    : BCD;
   Digit7    : BCD;
   Digit8    : BCD;
   Digit9    : BCD;
   Digit10   : BCD;
   Digit11   : BCD;
   Digit12   : BCD;
   Digit13   : BCD;
   Digit14   : BCD;
   Digit15   : BCD;
   Digit16   : BCD;
   Digit17   : BCD;

   Sign      : Boolean;
end record with Size => 80;
for X87_BCD_Reg use record
   Digit0 at 0 range 0 .. 3;
   Digit1 at 0 range 4 .. 7;
   Digit2 at 0 range 8 .. 11;
   Digit3 at 0 range 12 .. 15;
   Digit4 at 0 range 16 .. 19;
   Digit5 at 0 range 20 .. 23;
   Digit6 at 0 range 24 .. 27;
   Digit7 at 0 range 28 .. 31;
   Digit8 at 4 range 0 .. 3;
   Digit9 at 4 range 4 .. 7;
   Digit10 at 4 range 8 .. 11;
   Digit11 at 4 range 12 .. 15;
   Digit12 at 4 range 16 .. 19;
   Digit13 at 4 range 20 .. 23;
   Digit14 at 4 range 24 .. 27;
   Digit15 at 4 range 28 .. 31;
   Digit16 at 8 range 0 .. 3;
   Digit17 at 8 range 4 .. 7;

   Sign at 0 range 79 .. 79;
end record;
for X87_BCD_Reg'Size use 80;

type X87_BCD_Reg_PTR is access all X87_BCD_Reg;

 

type X87_BCD_Reg_Array is record
   BCD_Array : array (0 .. 17) of BCD with Component_Size => 4, Packed;
   Sign : Boolean;
end record with Size => 80;
for X87_BCD_Reg_Array use record
   BCD_Array at 0 range 0 .. 71;
   Sign at 0 range 79 .. 79;
end record;
for X87_BCD_Reg_Array'Size use 80;

type X87_BCD_Reg_Array_PTR is access all X87_BCD_Reg_Array;

function X87_BCDRegArray_To_BCDReg is new Ada.Unchecked_Conversion(
   Source => X87_BCD_Reg_Array,
   Target => X87_BCD_Reg
);
function X87_BCDReg_To_BCDRegArray is new Ada.Unchecked_Conversion(
   Source => X87_BCD_Reg,
   Target => X87_BCD_Reg_Array
);



--############################################################################
--############################################################################
--
--    SSE
--
--############################################################################
--############################################################################



type SSE_MXCSR is record
   Flag_InvalidOper : Boolean;
   Flag_Denormalization : Boolean;
   Flag_ZeroDiv     : Boolean;
   Flag_Overflow    : Boolean;
   Flag_Underflow   : Boolean;
   Flag_Precision   : Boolean;
   Flag_P4_Denor_Is_Zero : Boolean;

   Mask_InvalidOper : Boolean;
   Mask_Denormalization : Boolean;
   Mask_ZeroDiv     : Boolean;
   Mask_Overflow    : Boolean;
   Mask_Underflow   : Boolean;
   Mask_Precision   : Boolean;

   Rounding_Control : Rounding_Modes;

   Flush_To_Zero    : Boolean;

   Reserved : Interfaces.Unsigned_16 range 0 .. 0;
end record with Size => 32;
for SSE_MXCSR use record
   Flag_InvalidOper at 0 range 0 .. 0;
   Flag_Denormalization at 0 range 1 .. 1;
   Flag_ZeroDiv at 0 range 2 .. 2;
   Flag_Overflow at 0 range 3 .. 3;
   Flag_Underflow at 0 range 4 .. 4;
   Flag_Precision at 0 range 5 .. 5;
   Flag_P4_Denor_Is_Zero at 0 range 6 .. 6;

   Mask_InvalidOper at 0 range 7 .. 7;
   Mask_Denormalization at 0 range 8 .. 8;
   Mask_ZeroDiv at 0 range 9 .. 9;
   Mask_Overflow at 0 range 10 .. 10;
   Mask_Underflow at 0 range 11 .. 11;
   Mask_Precision at 0 range 12 .. 12;

   Rounding_Control at 0 range 13 .. 14;

   Flush_To_Zero at 0 range 15 .. 15;
   
   Reserved at 0 range 16 .. 31;
end record;
for SSE_MXCSR'Size use 32;

type SSE_MXCSR_PTR is access all SSE_MXCSR;












end X86_Hardware_Registers;
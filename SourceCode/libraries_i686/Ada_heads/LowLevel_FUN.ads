with IA32_Hardware_Registers;
with IA32_Types;
with Interfaces;use Interfaces;
with Interfaces.C;use Interfaces.C;
with X86_segments;

package LowLevel_FUN is

--Low level x86 IA32 functions for interfacing with specific assembly instructions
--10 procedure outb with globASM_FUN prefix
-- 10.10 procedure outb without prefix both label lead to the same address

--20  OUT instruction for word size number named with globASM)prefix
-- 20.10 outw instruction function without prefix, both labels lead to the same address

--30 procedure globASM_FUN_outd that executes instruction outd
-- 30.10 outd procedure without prefix in the name, both labels lead to the same address

--40 function inb that calls in instruction and returns read value
-- 40.10 the same function as before but with prefix, both labels lead to the same address

--50 function inw that calls in ax, dx instruction and returns read value
-- 50.10 the same function but with prefix, both labels lead to the same address

--60 InD function that calls in eax, dx and return read value
-- 60.10 The same function but with globASM_FUN prefix, both labels lead to the same address

--70 set_IOPL_minLvl procedure that means set Input output privelege level
--   sets the maximum privelege level that can use IN, OUT instruction
--   without looking at the denied ports bitmap
--   If set to 1, level 0,1 can use OUT IN instruction freely 

--80 WRMSR_ procedure to write model specific register of CPU
-- 80.10 the same procedure but labeled by its full name
--    both labels lead to the same address

--90 RDMSR_ read model specific register of CPU function that returns the value
-- 90.10 the same function labeled by its full name
--       both labels lead to the same address

--100    function to Read control registers(they return their state)
-- 100.10 get CR0
-- 100.20 get CR2
-- 100.30 get CR3
-- 100.40 get CR4
--    NO CR1 because it is reserved
--
--110  PROCEDURES TO WRITE CONTROL REGISTER
-- 110.10 write control register 0
-- 110.20 wrtie control register 2
-- 110.30 write control register 3
-- 110.40 write control register 4
--    NO control register 1 because it is reserved fully
--
--120 CPUID related things
-- 120.10 CPUID function returned structure
-- 120.20 CPUID returned structure representation
-- 120.30 the CPUID procedure
--    Note that it does not return the structure because it is too big

procedure globASM_FUN_outb(PortAddress : IA32_Types.Port_t; TheByte : Unsigned_8)
   with 
      Import => True,
      Convention => C,
      External_Name => "globASM_FUN_outb";
procedure outb(PortAddress : IA32_Types.Port_t; TheByte : Unsigned_8)
   with 
      Import => True,
      Convention => C,
      External_Name => "outb";

procedure outw (PortAddress : IA32_Types.Port_t; TheWord16 : Unsigned_16)
   with
      Import => True,
      Convention => C,
      External_Name => "outw";
procedure globASM_FUN_outw (PortAddress : IA32_Types.Port_t; TheWord16 : Unsigned_16)
   with
      Import => True,
      Convention => C,
      External_Name => "globASM_FUN_outw";

procedure outd (PortAddress : IA32_Types.Port_t ; TheDoubleWord32 : Unsigned_32)
   with
      Import => True,
      Convention => C,
      External_Name => "outd";
procedure globASM_FUN_outd (PortAddress : IA32_Types.Port_t ; TheDoubleWord32 : Unsigned_32)
   with
      Import => True,
      Convention => C,
      External_Name => "globASM_FUN_outd";



function inB (PortAddress : IA32_Types.Port_t) return Unsigned_8
   with
      Import => True,
      Convention => C,
      External_Name => "inB";
function globASM_FUN_inB (PortAddress : IA32_Types.Port_t) return Unsigned_8
   with
      Import => True,
      Convention => C,
      External_Name => "globASM_FUN_inB";

function inW (PortAddress : IA32_Types.Port_t) return Unsigned_16
   with
      Import => True,
      Convention => C,
      External_Name => "inW";
function globASM_FUN_inW (PortAddress : IA32_Types.Port_t) return Unsigned_16
   with
      Import => True,
      Convention => C,
      External_Name => "globASM_FUN_inW";

function inD (PortAddress : IA32_Types.Port_t) return Unsigned_16
   with
      Import => True,
      Convention => C,
      External_Name => "inD";
function globASM_FUN_inD(PortAddress : IA32_Types.Port_t) return Unsigned_16
   with
      Import => True,
      Convention => C,
      External_Name => "globASM_FUN_inD";




procedure set_IOPL_minLvl (PrivelegeLevel : X86_segments.Privelege_LVL_t)
   with
      Import => True,
      Convention => C,
      External_Name => "set_IOPL_minLvl";



procedure WRMSR_ (WhereWrite : Unsigned_32 ; WhatWrite : Unsigned_64)
   with
      Import => True,
      Convention => C,
      External_Name => "WRMSR_";
procedure Write_ModelSpecific_Register 
   (
      WhereWrite : Unsigned_32 ; 
      WhatWrite : Unsigned_64
   )
   with
      Import => True,
      Convention => C,
      External_Name => "Write_ModelSpecific_Register";

function RDMSR_(WhereRead : Unsigned_32) return Unsigned_64
   with Import => True,
   Convention => C,
   External_Name => "RDMSR_";
function Read_ModelSpecific_Register(WhereRead : Unsigned_32) return Unsigned_64
   with Import => True,
   Convention => C,
   External_Name => "Read_ModelSpecific_Register";





function get_CR0 return IA32_Hardware_Registers.Control_Register0_r;
function get_CR2 return IA32_Hardware_Registers.Control_Register2;
function get_CR3 return IA32_Hardware_Registers.Control_Register3_r;
function get_CR4 return IA32_Hardware_Registers.Control_Register4_r;



procedure write_CR0(WhatWrite : IA32_Hardware_Registers.Control_Register0_r)
   with Import => True,
   Convention => C,
   External_Name => "write_CR0";
procedure write_CR2(WhatWrite : IA32_Hardware_Registers.Control_Register2)
   with Import => True,
   Convention => C,
   External_Name => "write_CR2";
procedure write_CR3(WhatWrite : IA32_Hardware_Registers.Control_Register3_r)
   with Import => True,
   Convention => C,
   External_Name => "write_CR3";
procedure write_CR4(WhatWrite : IA32_Hardware_Registers.Control_Register4_r)
   with Import => True,
   Convention => C,
   External_Name => "write_CR4";


type CPUID_return is record
   AX : Unsigned_32;
   BX : Unsigned_32;
   CX : Unsigned_32;
   DX : Unsigned_32;  
end record with Size => 256;
for CPUID_return use record
   AX at 0 range 0..31;
   BX at 8 range 0..31;
   CX at 16 range 0..31;
   DX at 24 range 0..31;
end record;

procedure CPUID (
   Returned_info : CPUID_return;
   Leaf : Unsigned_32;
   SubLeaf : Unsigned_32
   ) with
   Import => True,
   Convention => C,
   External_Name => "globASM_FUN_CPUID";


end LowLevel_FUN;
with IA32_Hardware_Registers;
with Interfaces;use Interfaces;
with Interfaces.C;use Interfaces.C;


package LOWLEVEL_FUNCTIONS is
use Interfaces.C;

procedure globASM_FUN_outb(PortAddress : Unsigned_16; TheByte : Unsigned_8)
   with 
      Import => True,
      Convention => C,
      External_Name => "globASM_FUN_outb";
procedure outb(PortAddress : Unsigned_16; TheByte : Unsigned_8)
   with 
      Import => True,
      Convention => C,
      External_Name => "outb";

procedure outw (PortAddress : Unsigned_16; TheWord16 : Unsigned_16)
   with
      Import => True,
      Convention => C,
      External_Name => "outw";
procedure globASM_FUN_outw (PortAddress : Unsigned_16; TheWord16 : Unsigned_16)
   with
      Import => True,
      Convention => C,
      External_Name => "globASM_FUN_outw";

procedure outd (PortAddress : Unsigned_16 ; TheDoubleWord32 : Unsigned_32)
   with
      Import => True,
      Convention => C,
      External_Name => "outd";
procedure globASM_FUN_outd (PortAddress : Unsigned_16 ; TheDoubleWord32 : Unsigned_32)
   with
      Import => True,
      Convention => C,
      External_Name => "globASM_FUN_outd";



function inB (PortAddress : Unsigned_16) return Unsigned_8
   with
      Import => True,
      Convention => C,
      External_Name => "inB";
function globASM_FUN_inB (PortAddress : Unsigned_16) return Unsigned_8
   with
      Import => True,
      Convention => C,
      External_Name => "globASM_FUN_inB";

function inW (PortAddress : Unsigned_16) return Unsigned_16
   with
      Import => True,
      Convention => C,
      External_Name => "inW";
function globASM_FUN_inW (PortAddress : Unsigned_16) return Unsigned_16
   with
      Import => True,
      Convention => C,
      External_Name => "globASM_FUN_inW";

function inD (PortAddress : Unsigned_16) return Unsigned_16
   with
      Import => True,
      Convention => C,
      External_Name => "inD";
function globASM_FUN_inD(PortAddress : Unsigned_16) return Unsigned_16
   with
      Import => True,
      Convention => C,
      External_Name => "globASM_FUN_inD";



type Privelege_LVL_type is mod 2**2;
   for Privelege_LVL_type'Size use 2;
procedure set_IOPL_minLvl (PrivelegeLevel : Privelege_LVL_type)
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
   AX : Unsigned_32,
   BX : Unsigned_32,
   CX : Unsigned_32,
   DX : Unsigned_32   
end record with Size => 256;
for CPUID_return use record
   AX at 0 range 0..31,
   BX at 8 range 0..31,
   CX at 16 range 0..31,
   DX at 24 range 0..31
end record;

procedure CPUID (
   Returned_info : CPUID_return;
   Leaf : Unsigned_32;
   SubLeaf : Unsigned_32
   ) with
   Import => True,
   Convention => C,
   External_Name => "globASM_FUN_CPUID";


end LOWLEVEL_FUNCTIONS;
with Interfaces.C;use Interfaces.C;


package LOWLEVEL_FUNCTIONS is


procedure globASM_FUN_outb(PortAddress : unsigned_short; TheByte : unsigned_char)
   with 
      Import => True,
      Convention => C,
      External_Name => "globASM_FUN_outb";
procedure outb(PortAddress : unsigned_short; TheByte : unsigned_char)
   with 
      Import => True,
      Convention => C,
      External_Name => "outb";



procedure outw (PortAddress : unsigned_short; TheWord16 : unsigned_short)
   with
      Import => True,
      Convention => C,
      External_Name => "outw";
procedure globASM_FUN_outw (PortAddress : unsigned_short; TheWord16 : unsigned_short)
   with
      Import => True,
      Convention => C,
      External_Name => "globASM_FUN_outw";




procedure outd (PortAddress : unsigned_short ; TheDoubleWord32 : unsigned)
   with
      Import => True,
      Convention => C,
      External_Name => "outd";
procedure globASM_FUN_outd (PortAddress : unsigned_short ; TheDoubleWord32 : unsigned)
   with
      Import => True,
      Convention => C,
      External_Name => "globASM_FUN_outd";
   


procedure set_IOPL_minLvl (PrivelegeLevel : unsigned_char)
   with
      Import => True,
      Convention => C,
      External_Name => "set_IOPL_minLvl";

end LOWLEVEL_FUNCTIONS;
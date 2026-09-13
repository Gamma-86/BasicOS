with LowLevel_FUN;

package body PCI_Interface is
type Config2_Forward_r is record
   SpecialCycle : Boolean;
   DevFunction : Fun_Indx;
   Area_IsVisible : Boolean;
end record with Size => 8;
for Config2_Forward_r use record
   SpecialCycle at 0 range 0 .. 0;
   DevFunction at 0 range 1 .. 3;
   Area_IsVisible at 0 range 4 .. 7;
end record;

type Config2_InfoAddress is record
   Zeroed : Integer range 0..0;
   Register : Reg_Indx;
   Device : Dev_Indx range 0..15;
   ConstNUM : Integer range 2#1100#..2#1100#;
end record with Size => 16;
for Config2_InfoAddress use record
   Zeroed at 0 range 0 .. 1;
   Register at 0 range 2 .. 7;
   Device at 0 range 8 .. 11;
   ConstNUM at 0 range 13 .. 15;
end record;





   
end PCI_Interface;
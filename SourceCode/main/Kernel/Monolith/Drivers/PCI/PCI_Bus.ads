with Interfaces;
with System;
package PCI_Bus is
   type Reg_Indx is mod 2**6 with Size => 6;
   type Fun_Indx is mod 2**3 with Size => 3;
   type Dev_Indx is mod 2**5 with Size => 5;
   type Bus_Indx is mod 2**8 with Size => 8;

   subtype Reg_Range is Integer range 0..63;
   subtype Fun_Range is Integer range 0..7;
   subtype Dev_Range is Integer range 0..31;
   subtype Bus_Range is Integer range 0..255; 

type Device_OSIndex_r is record
   DevFunction : Fun_Indx;
   Device : Dev_Indx;
   Bus : Bus_Indx;
   Reserved : Integer range 0..0;
end record with Size=>32;
for Device_OSIndex_r use record
   DevFunction at 0 range 0 .. 7;
   Device at 1 range 0 .. 7;
   Bus at 2 range 0 .. 7;
   Reserved at 3 range 0 .. 7;
end record;






private
   type PCI_MechanismPorts is(
      Conf1Port_Data,
      Conf1Port_Address,
      
      Conf2Port_Forward,
      Conf2Port_SpaceBase
   ) with Size => 16;
   for PCI_MechanismPorts use(
      Conf1Port_Data => 16#CFC#,
      Conf1Port_Address => 16#CF8#,
      
      Conf2Port_Forward => 16#CFA#,
      Conf2Port_SpaceBase => 16#C000#
   );


end PCI_Bus;
with Interfaces.C;use Interfaces.C;
with ReturnBitfields;
package PortDebugOutput is
   function Print_str_lpt (string : The_printed_string) 
      return ReturnBitfields.GeneralOS
      with 
         Import => True,
         Convention=>C,
         External_Name=>"Print_str_lpt";
end Name;
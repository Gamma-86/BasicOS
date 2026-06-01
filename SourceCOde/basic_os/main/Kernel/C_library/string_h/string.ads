with Interfaces.C;

package STRING_H is
function memcpy
   (Destination : System.Address;
   Source      : System.Address;
   Length      : Natural)
return System.Address
with
   Import,
   Convention => C,
   Link_Name => "memcpy",
   Pre  => Source /= Null_Address      and then
            Destination /= Null_Address and then
            not Overlapping (Destination, Source, Length),
   Post => MemCopy'Result = Destination;



function memmove
   (Destination : System.Address;
   Source      : System.Address;
   Length      : Natural)
return System.Address
with
   Import,
   Convention => C,
   Link_Name => "memmove",
   Pre  => Source /= Null_Address      and then
            Destination /= Null_Address and then
            not Overlapping (Destination, Source, Length),
   Post => MemCopy'Result = Destination;


function memchr
   (Seacrh_Location : System.Address;
   Searched_Char      : Character;
   Search_Length      : Natural)
return System.Address
with
   Import,
   Convention => C,
   Link_Name => "memchr",
   Pre  => Source /= Null_Address      and then
            Destination /= Null_Address and then
            not Overlapping (Destination, Source, Length),
   Post => MemCopy'Result = Destination;



   
end STRING_H;
package STRING_H is
function memcpy
   (Destination : System.Address;
   Source      : System.Address;
   Length      : Natural)
return Address
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
return Address
with
   Import,
   Convention => C,
   Link_Name => "memmove",
   Pre  => Source /= Null_Address      and then
            Destination /= Null_Address and then
            not Overlapping (Destination, Source, Length),
   Post => MemCopy'Result = Destination;




   
end STRING_H;
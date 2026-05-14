package body SEGMENT_DESCRIPTORS is
   function Fragment_Address (Address : System.Address) return AddressFragmented is
      ReturnedAddress : AddressFragmented;
   begin

   end Fragment_Address;

   function Fragment_Limit (Limit : Integer) return LimitFragmented is
      ReturnedLimit : LimitFragmented;
   begin
      ReturnedLimit :=
         (LimitLow => Limit_Low_Type (Limit),
          LimitHigh => Limit_High_Type(Interfaces.Shift_Right(Limit, 16))
         );
   end Fragment_Limit;

end SEGMENT_DESCRIPTORS;



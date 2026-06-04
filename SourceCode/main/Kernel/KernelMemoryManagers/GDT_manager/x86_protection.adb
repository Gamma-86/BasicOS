with Interfaces;
package body x86_protection.Segmentation is
      function Fragment_Address
        (Address : System.Address) return AddressFragmented
      is
         ReturnedAddress : AddressFragmented;
         use Interfaces;
         subtype Address_Int is Unsigned_32;

         function To_INT is new
           Ada.Unchecked_Conversion (System.Address, Address_Int);

         ConvertedIntAddress : Address_Int := To_INT (Address);
         FragmentedAddress   : AddressFragmented;
      begin
         FragmentedAddress :=
         (
         BaseLow  => 
            Base_Low_Type(ConvertedIntAddress and 16#FF_FFFF#),
         BaseHigh =>
            Base_High_Type( Shift_Right(ConvertedIntAddress, 24) )
         );

         return FragmentedAddress;
      end Fragment_Address;

      function Fragment_Limit (Limit : Integer) return LimitFragmented is
         ReturnedLimit : LimitFragmented;
         use Interfaces;
      begin
         ReturnedLimit :=
         (
            LimitLow  => Limit_Low_Type (Limit),
            LimitHigh => Limit_High_Type (Shift_Right (Limit, 16))
         );
      end Fragment_Limit;

end Segmentation;

with Interfaces.C;
with Interfaces;
with System;
package InitialAllocators is
   procedure Arena1_initial_free(Pointer : System.Address)
      with 
      Import,
      Convention => C,
      Link_Name => "Arena1_initial_free";
   procedure Arena1_reset
   with 
      Import,
      Convention => C,
      Link_Name => "Arena1_reset"
   ;
   
   function Arena1_initial_malloc
   (
      PTR_PTR : System.Address;
      Size : Interfaces.Unsigned_32
   )
   return Interfaces.Integer_32
   with
      Import,
      Convention => C,
      Link_Name => "Arena1_initial_malloc"
   ;

   function Arena1_initial_calloc
   (
      PTR_PTR : System.Address;
      Size : Interfaces.Unsigned_32
   ) 
   return Interfaces.Integer_32
   with
      Import,
      Convention => C,
      Link_Name => "Arena1_initial_calloc"
   ;

private
   
end Name;
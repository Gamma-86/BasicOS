with x86_protection;use x86_protection;
with x86_protection.Segmentation;
with Interfaces;
with ReturnBitfields;
with System;
package main_GDT is
   MainGDT_start : aliased Segments_Table with
      Import => True,
      Convention => C;
   MainGDT_Descriptor : aliased GDT_descriptor with
      Import => True,
      Convention => C;



   function globASM_FUN_GDT_pushDescriptor(
      Segment_Descriptor : x86_protection.SegmentRaw
   )
   return Interfaces.Unsigned_16
      with
         Import => True,
         Convention => C,
         External_Name => "globASM_FUN_GDT_pushDescriptor";
   GDT_Stack_Pointer : Interfaces.Unsigned_16 
      with
         Import => True,
         Convention => C;



   procedure globASM_FUN_lgdt(
      Pointer_To_Descriptor : x86_protection.GDT_descriptorPTR
   )
   with
      Import => True,
      Convention => C,
      External_Name => "globASM_FUN_lgdt";
   procedure globASM_FUN_sgdt (
      Pointer_To_Descriptor : x86_protection.GDT_descriptorPTR
   )
   with
      Import => True,
      Convention => C,
      External_Name => "globASM_FUN_sgdt";




   function Insert_GDT_Descriptor(
      Limit : Interfaces.Unsigned_32;
      Base_Address : System.Address;
      Segment_Type : x86_protection.TypeField_type;
      Privelge : x86_protection.Privelege_LVL_type;
      Is_Present : Boolean;
      Is_Available:Boolean;
      Is_32bit   : Boolean;
      Is_Granular: Boolean;
      Index      : x86_protection.Segment_Index_type
   )
   return ReturnBitfields.GeneralOS
   with
      Export => True,
      Convention => C,
      External_Name => "Insert_GDT_Descriptor";

private

end main_GDT;
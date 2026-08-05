with VGA_80_25;
with X86_segments;use X86_segments;
with X86_segments.LDT;use X86_segments.LDT;

with Interfaces;
with ReturnBitfields;
with System;
package main_GDT is
--A pacakage that describes the definitions of functions that ease interfaction
--with GDT/LDT/Segment descriptors. Foe example, extracting initial Base/Limit
--from descriptor
--Also this HAS THE INITIAL GDT/LDT MAP and DESCRIPTOR TO REQUES IT

--10 record type - Segment_Request_r -- Request ticket describing the 
--segment to be placed in GDT or LDT, should be organized in array
--10.10 type pointer to it

--20    Array of requests to fill initial GDT
--20.10 Array of requests to fill initial LDT, and its Pointer

--21 Function to fill GDT with Requested segments
--21.10 Function wrapper for C


--30 Function to fill LDT with Requested segments
--30.10 function wrapper for C

--40 Assembler label of GDT start
--40.10 Assembler label of GDT descriptor

--50 Assembler functions to interact with segmentation
--50.10 lgdt instruction function
--50.20 sgdt instruction function
--50.30 lldt instruction function
--50.40 sldt instruction function


--60 Record type of unpacked Code Descriptor, made for extraction of data
--    for further ease of processing
--60.10 Pointer to unpacked code descriptor
--60.20 function to unpack code given code descriptor
--60.30 wrapper of the code descriptor unpacker for C

--70 Record type of unpacked Data Descriptor, made for extraction of data for
--    further ease of processing
--70.10 Pointer to Unpacked data record
--70.20 function to unpack the give Data Descriptor
--70.30 Wrapper of Data Descriptor unpacker for C

--80 Unpacked TSS32 record type, made to extract data from descriptor 
--    for further ease of use
--80.10 Pointer type to unpacked record
--80.20 function to descriptor into record
--80.30 Wrapper of Descriptor unpacker for C

--90 LDT desciptor unpacked record, made to extract data from LDT descriptor
--    for further ease of use
--90.10 Pointer type to unpacked LDT descriptor
--90.20 Function to unpack LDT descriptor
--90.30 wrapper of LDT descriptor unpacker for C

--91 CallGate32 decriptor unpacked record, made to extract data from Call Gate
--    Descriptor for further ease of use
--91.10 Pointer type to unpacked CallGate32 descriptor
--91.20 Function to unpack Call Gate 32 descriptor
--91.30 Wrapper of Call Gate 32 unpacker for C

--100 Functions that generate Segments depending from parameters 
--100.10.10  Generate Data Segment Descriptor
--100.10.20  Wrapper of Data Segment Generator for C
--100.20.10  Generate Code Segment Descriptor
--100.20.20  Wrapper of Code segment generator for C
--100.30.10  Generate Call Gate32 descriptor    
--100.30.20  Wrapper of Call Gate32 generator for C
--100.40.10  TSS32 descriptor generator
--100.40.20  Wrapper for TSS32 generator for C





--############################################################################
--############################################################################
--
--    10
--
--############################################################################
--############################################################################
type Segment_Request_r is record
   Base : System.Address;--4
   Limit: Interfaces.Unsigned_32;--8

   Is_Accessed      : Interfaces.C.unsigned_char;--9

   Is_EXE           : Interfaces.C.unsigned_char;--10
   EXE_is_readable  : Interfaces.C.unsigned_char;--11
   EXE_is_Conforming: Interfaces.C.unsigned_char;--12

   Data_is_writable : Interfaces.C.unsigned_char;--13
   Data_is_E_Down   : Interfaces.C.unsigned_char;--14

   Privelege        : Interfaces.C.unsigned_char;--15
   IsNot_System     : Interfaces.C.unsigned_char;--16
   Is_Present       : Interfaces.C.unsigned_char;--17

   Is_Available    : Interfaces.C.unsigned_char;--18
   Is_64           : Interfaces.C.unsigned_char;--19
   Is_32           : Interfaces.C.unsigned_char;--20
   Is_Granular     : Interfaces.C.unsigned_char;--21

   Call_Gate_Selector : Segment_Selector;--23
   Arg_Copy_Amount    : Interfaces.Unsigned_8;--24
   System_Type        : GDTSystemTypes_t;--25

   Request_done  : Interfaces.C.unsigned_char;

   TaskGate_TSSSelector : X86_segments.Segment_Selector;

   Padding32          : Interfaces.Unsigned_32 range 0..0;--29
end record
   with Size => 256;
for Segment_Request_r use record
   Base at 0 range 0 .. 31;
   Limit at 4 range 0 .. 31;

   Is_Accessed at 8 range 0 .. 7;

   Is_EXE at 9 range 0 .. 7;
   EXE_is_readable at 10 range 0 .. 7;
   EXE_is_Conforming at 11 range 0 .. 7;

   Data_is_writable at 12 range 0 .. 7;
   Data_is_E_Down at 13 range 0 .. 7;

   Privelege at 14 range 0 .. 7;
   IsNot_System at 15 range 0 .. 7;
   Is_Present at 16 range 0 .. 7;

   Is_Available at 17 range 0 .. 7;
   Is_64 at 18 range 0 .. 7;
   Is_32 at 19 range 0 .. 7;
   Is_Granular at 20 range 0 .. 7;

   Call_Gate_Selector at 21 range 0 .. 15;
   Arg_Copy_Amount at 23 range 0 .. 7;
   System_Type at 24 range 0 .. 7;

   Request_done at 25 range 0 .. 7;

   TaskGate_TSSSelector at 26 range 0 .. 15;

   Padding32 at 28 range 0 .. 31;
end record;
for Segment_Request_r'Size use 256;
--#########################################################
--    10.10
--#########################################################
type Segment_Request_r_PTR is access all Segment_Request_r;



--#######################################################
--#######################################################
--
--    20
--
--#######################################################
--#######################################################
type GDT_requests is array (0..31) of Segment_Request_r;
type GDT_requests_PTR is access all GDT_requests;


--#######################################################
--    20.10
--#######################################################
type LDT_requests is array (0..15) of Segment_Request_r;
type LDT_requests_PTR is access all LDT_requests;

--############################################################################
--############################################################################
--
--    21
--
--############################################################################
--############################################################################

function Init_Kernel_GDT(
   Requests_Array_PTR : GDT_requests_PTR;
   Descriptor_PTR : GDT_Descriptor_r_PTR
)return ReturnBitfields.GeneralOS with
   Convention => C;
--############################################################################
--    21.10
--############################################################################
function Init_Kernel_GDT_ForC(
   Requests_Array_PTR : GDT_requests_PTR;
   Descriptor_PTR : GDT_Descriptor_r_PTR
) return Interfaces.Unsigned_32 with
   Export => True,
   Convention => C,
   External_Name => "main_GDT_Init_Kernel_GDT_ForC";


--############################################################################
--############################################################################
--
--    30
--
--############################################################################
--############################################################################

function Init_Kernel_LDT(
   Requests_Array_PTR : LDT_requests_PTR;
   LDT_PTR : LDT_t_PTR 
) return ReturnBitfields.GeneralOS with
   Convention => C;
--############################################################################
--30.10
--############################################################################
function Init_Kernel_LDT_ForC(
   Requests_Array_PTR : LDT_requests_PTR;
   LDT_PTR : LDT_t_PTR 
) return Interfaces.Unsigned_32 with
   Export => True,
   Convention => C,
   External_Name => "main_GDT_Init_Kernel_LDT_ForC";


--############################################################################
--############################################################################
--
--    40
--
--############################################################################
--############################################################################
   MainGDT_start : aliased Segments_Table with
      Import => True,
      Convention => C;
--############################################################################
--    40.10
--############################################################################
   MainGDT_Descriptor : aliased GDT_descriptor with
      Import => True,
      Convention => C;


--############################################################################
--############################################################################
--
--    50
--
--
--############################################################################
--############################################################################

--############################################################################
--    50.10
--############################################################################
   procedure globASM_FUN_lgdt(
      Pointer_To_Descriptor : GDT_Descriptor_r_PTR
   )
   with
      Import => True,
      Convention => C,
      External_Name => "globASM_FUN_lgdt";
--############################################################################
--    50.20
--############################################################################
   procedure globASM_FUN_sgdt (
      Pointer_To_Descriptor : GDT_Descriptor_r_PTR
   )
   with
      Import => True,
      Convention => C,
      External_Name => "globASM_FUN_sgdt";
--############################################################################
--    50.30
--############################################################################

   procedure globASM_FUN_lldt(
      LDT_Selector : Segment_Selector
   )
   with
      Import => True,
      Convention => C,
      External_Name => "globASM_FUN_lldt";
--############################################################################
--    50.40
--############################################################################
   function globASM_FUN_sldt return Segment_Selector
   with
      Import => True,
      Convention => C,
      External_Name => "globASM_FUN_sldt";




--############################################################################
--############################################################################
--
--    60
--
--############################################################################
--############################################################################
type Code_Descriptor_Unpacked_r is record
   Limit : Interfaces.Unsigned_32;
   Base  : System.Address;

   Is_Accessed : Boolean;
   Is_Readable : Boolean;
   Is_Conforming:Boolean;
   Privelege_LVL:Privelege_LVL_t;
   Is_Present  : Boolean;

   Available_Bit: Boolean;
   Is_32       : Boolean;
   Is_Granular : Boolean;
end record
   with Size =>128;
for Code_Descriptor_Unpacked_r use record
   Limit at 0 range 0 .. 31;
   Base at 4 range 0 .. 31;

   Is_Accessed at 8 range 0 .. 7;
   Is_Readable at 9 range 0 .. 7;
   Is_Conforming at 10 range 0 .. 7;
   Privelege_LVL at 11 range 0 .. 7;
   Is_Present at 12 range 0 .. 7;

   Available_Bit at 13 range 0 .. 7;
   Is_32 at 14 range 0 .. 7;
   Is_Granular at 15 range 0 .. 7;
end record;
for Code_Descriptor_Unpacked_r'Size use 128;
--############################################################################
--    60.10
--############################################################################
type Code_Descriptor_Unpacked_r_PTR is access all Code_Descriptor_Unpacked_r;
--############################################################################
--    60.20
--############################################################################
function Unpack_CodeDescriptor(
      Descriptor_PTR : GDT_Descriptor_Code_PTR;
      Unpacked_Code_PTR : Code_Descriptor_Unpacked_r_PTR
   )
return ReturnBitfields.GeneralOS ;
--############################################################################
--    60.30
--############################################################################
function Unpack_CodeDescriptor(
      Descriptor_PTR : GDT_Descriptor_Code_PTR;
      Unpacked_Code_PTR : Code_Descriptor_Unpacked_r_PTR
   )
return Interfaces.Unsigned_32 with
   Export => True,
   Convention => C,
   External_Name => "main_GDT_Unpack_CodeDescriptor_ForC";




--############################################################################
--############################################################################
--
--    70
--
--############################################################################
--############################################################################
type Data_Descriptor_Unpacked_r is record
   Limit : Interfaces.Unsigned_32;
   Base  : System.Address;

   Is_Accessed : Boolean;
   Is_Writable : Boolean;
   Is_E_Down   : Boolean;
   Privelege_LVL:Privelege_LVL_t;
   Is_Present  : Boolean;

   Available_Bit : Boolean;
   Is_32       : Boolean;
   Is_Granular : Boolean;
end record
   with Size => 128;
for Data_Descriptor_Unpacked_r use record
   Limit at 0 range 0 .. 31;
   Base at 4 range 0 .. 31;

   Is_Accessed at 8 range 0 .. 7;
   Is_Writable at 9 range 0 .. 7;
   Is_E_Down at 10 range 0 .. 7;
   Privelege_LVL at 11 range 0 .. 7;
   Is_Present at 12 range 0 .. 7;

   Available_Bit at 13 range 0 .. 7;
   Is_32 at 14 range 0 .. 7;
   Is_Granular at 15 range 0 .. 7;
end record;
for Data_Descriptor_Unpacked_r'Size use 128;
--############################################################################
--    70.10
--############################################################################
type Data_Descriptor_Unpacked_r_PTR is access all Data_Descriptor_Unpacked_r;
--############################################################################
--    70.20
--############################################################################
function Unpack_DataDescriptor(
   Descriptor_PTR : GDT_Descriptor_Data_PTR;
   Unpacked_PTR   : Data_Descriptor_Unpacked_r_PTR
)
return ReturnBitfields.GeneralOS;
--############################################################################
--    70.30
--############################################################################
function Unpack_DataDescriptor_ForC(
   Descriptor_PTR : GDT_Descriptor_Data_PTR;
   Unpacked_PTR   : Data_Descriptor_Unpacked_r_PTR
)
return Interfaces.Unsigned_32 with
   Export => True,
   Convention => C,
   External_Name =>"main_GDT_Unpack_DataDescriptor_ForC";






--############################################################################
--############################################################################
--
--    80
--
--############################################################################
--############################################################################

type TSS32_Descriptor_Unpacked is record
   Limit : Interfaces.Unsigned_32;
   Base  : System.Address;

   Is_Busy : Boolean;
   Privelege_LVL : Privelege_LVL_t;
   Available_Bit : Boolean;
   Is_Present : Boolean;
   Is_Granular : Boolean;

   Padding1    : Interfaces.Unsigned_24 range 0 .. 0;
end record
   with  Size => 128;
for TSS32_Descriptor_Unpacked use record
   Limit at 0 range 0 .. 31;
   Base at 4 range 0 .. 31;

   Is_Busy at 8 range 0 .. 7;
   Privelege_LVL at 9 range 0 .. 7;
   Available_Bit at 10 range 0 .. 7;
   Is_Present at 11 range 0 .. 7;
   Is_Granular at 12 range 0 .. 7;

   Padding0 at 13 range 0 .. 23;
end record;
for TSS32_Descriptor_Unpacked'Size use 128;
--############################################################################
--    80.10
--############################################################################
type TSS32_Descriptor_Unpacked_PTR is access all TSS32_Descriptor_Unpacked;
--############################################################################
--    80.20
--############################################################################
function Unpack_TSS32Descriptor(
   Descriptor_PTR : TSS32_Descriptor_r_PTR;
   Unpacked_PTR  : TSS32_Descriptor_Unpacked_PTR
)return ReturnBitfields.GeneralOS;
--############################################################################
--    80.30
--############################################################################
function Unpack_TSS32Descriptor_ForC(
   Descriptor_PTR : TSS32_Descriptor_r_PTR;
   Unpacked_PTR   : TSS32_Descriptor_Unpacked_PTR
) return Interfaces.Unsigned_32 with
   Export => True,
   Convention => C,
   External_Name => "main_GDT_Unpack_TSS32Descriptor_ForC";



--############################################################################
--############################################################################
--
--    90
--
--############################################################################
--############################################################################
type LDT_Descriptor_Unpacked is record
   Limit : Interfaces.Unsigned_32;--4
   Base  : System.Address;--8

   Privelege_LVL : Privelege_LVL_t;--9
   Is_Present    : Boolean;--10
   Available_Bit : Boolean;--11
   Is_Granular   : Boolean;--12

   Padding       : Interfaces.Unsigned_32;
end record
with Size => 64;
for LDT_Descriptor_Unpacked use record
   Limit at 0 range 0 .. 31;
   Base at 4 range 0 .. 31;

   Privelege_LVL at 8 range 0 .. 7;
   Is_Present at 9 range 0 .. 7;
   Available_Bit at 10 range 0 .. 7;
   Is_Granular at 11 range 0 .. 7;

   Padding     at 12 range 0 .. 31;
end record;
for LDT_Descriptor'Size use 128;
--############################################################################
--    90.10
--############################################################################
type LDT_Descriptor_Unpacked_PTR is access all LDT_Descriptor_Unpacked;
--############################################################################
--    90.20
--############################################################################
function Unpack_LDTDescriptor(
   Descriptor_PTR : LDT_Descriptor_PTR;
   Unpacked_PTR   : LDT_Descriptor_Unpacked_PTR
) return ReturnBitfields.GeneralOS;
--############################################################################
--    90.30
--############################################################################
function Unpack_LDTDescriptor_ForC(
   Descriptor_PTR : LDT_Descriptor_PTR;
   Unpacked_PTR   : LDT_Descriptor_Unpacked_PTR
) return Interfaces.Unsigned_32 with
   Export => True,
   Convention => C,
   External_Name => "main_GDT_Unpack_LDTDescriptor_ForC";
  

--############################################################################
--############################################################################
--
--    91
--
--############################################################################
--############################################################################

--############################################################################
--    91.10
--############################################################################

--############################################################################
--    91.20
--############################################################################

--############################################################################
--    91.30
--############################################################################








--############################################################################
--############################################################################
--
--    100
--
--############################################################################
--############################################################################



--############################################################################
--    100.10.10
--############################################################################

--############################################################################
--    100.10.20
--############################################################################



--############################################################################
--    100.20.10
--############################################################################

--############################################################################
--    100.20.20
--############################################################################



--############################################################################
--    100.30.10
--############################################################################

--############################################################################
--    100.30.20
--############################################################################



--############################################################################
--    100.40.10
--############################################################################

--############################################################################
--    100.40.20
--############################################################################










private

end main_GDT;
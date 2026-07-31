with System;
package X86_paging is

type Byte is mod 2**8 with Size=>8;
for Byte'Size use 8;

subtype Always_0Bool_t is Boolean range False .. False with Size => 1;
subtype Always_1Bool_t is Boolean range True .. True with Size => 1;

type Paging_Base_Address_t is mod 2 ** 20 with Size => 20;
for Paging_Base_Address_t'Size use 20;



PageSize_Normal    : constant Integer := 4096;
PageSize_Big_NoPAE : constant Integer := 2**22;
PageSize_Big_PAE   : constant Integer := 2**21;

subtype PageRange_Normal is Integer range 0 .. 4095 with Size => 32;
subtype PageRange_Big_NoPAE is Integer range 0 .. 2**22 with Size => 32;
subtype PageRange_Big_PAE is integer range 0..2**21 with Size=>32;

type Page is array (PageRange_Normal) of Byte with Alignment => 4096;
for Page'Alignment use 4096;
type Page_PTR is access all Page;

type Page_Big_NoPAE is array(PageRange_Big_NoPAE) of Byte
with Alignment => 2**22;
for Page_Big_NoPAE'Alignment use 2**22;
type Page_Big_NoPAE_PTR is access all Page_Big_NoPAE;

type Page_Big_PAE is array(PageRange_Big_PAE) of Byte
with Alignment => 2**21;
for Page_Big_PAE'Alignment use 2**21;
type Page_Big_PAE_PTR is access all Page_Big_PAE;



subtype PagingTables_GeneralRange is Integer range 0 .. 1023;





type General_PageEntry_LowFlags is record
   Is_Present        : Boolean;
   Is_Writable       : Boolean;
   Is_SuperVisor_LVL : Boolean;
   Is_Write_Through  : Boolean;
   Cache_Disabled    : Boolean;
   Was_Accessed      : Boolean;
end record with Size => 6;
for General_PageEntry_LowFlags use record
   Is_Present at 0 range 0 .. 0;
   Is_Writable at 0 range 1 .. 1;
   Is_SuperVisor_LVL at 0 range 2 .. 2;
   Is_Write_Through at 0 range 3 .. 3;
   Cache_Disabled at 0 range 4 .. 4;
   Was_Accessed at 0 range 5 .. 5;
end record;
for General_PageEntry_LowFlags'Size use 6;



type PageEntry_Available_Field_e is (
   Type0,
   Type1,
   Type2,
   Type3,
   Type4,
   Type5,
   Type6,
   Type7
) with Size => 3;
for PageEntry_Available_Field_e use (
   Type0 => 0,
   Type1 => 1,
   Type2 => 2,
   Type3 => 3,
   Type4 => 4,
   Type5 => 5,
   Type6 => 6,
   Type7 => 7
);
for PageEntry_Available_Field_e'Size use 3;




type Page_Table_Entry is record
   Low_Flags : General_PageEntry_LowFlags;
   Dirty_Was_Written : Boolean;
   Reserved7         : Always_0Bool_t;
   Is_Global         : Boolean;
   Available : PageEntry_Available_Field_e;
   Page_Address : Paging_Base_Address_t;
end record with Size => 32;
for Page_Table_Entry use record
   Low_Flags at 0 range 0 .. 5;
   Dirty_Was_Written at 0 range 6 .. 6;
   Reserved7 at 0 range 7 .. 7;
   Is_Global at 0 range 8 .. 8;
   Available at 0 range 9 .. 11;
   Page_Address at 0 range 12 .. 31;
end record;
for Page_Table_Entry'Size use 32;

type Page_Table_Entry_PTR is access all Page_Table_Entry; 

type Page_Table is array (PagingTables_GeneralRange) of Page_Table_Entry
   with Alignment => 4096 ;
for Page_Table'Alignment use 4096;

type Page_Table_PTR is access all Page_Table;

function Extract_PageEntry_Address(Entry_PTR : in Page_Table_Entry_PTR)
return System.Address
with 
   Export => True,
   Convention => C,
   External_Name => "X86_Paging_Extract_TableEntry_Address";











type DirEntry_Available_Field_e is (
   Type0,
   Type1,
   Type2,
   Type3,
   Type4,
   Type5,
   Type6,
   Type7
) with Size => 3;
for DirEntry_Available_Field_e use (
   Type0 => 0,
   Type1 => 1,
   Type2 => 2,
   Type3 => 3,
   Type4 => 4,
   Type5 => 5,
   Type6 => 6,
   Type7 => 7
);
for DirEntry_Available_Field_e'Size use 3;



type Page_Directory_Entry is record
   Low_Flags : General_PageEntry_LowFlags;
   Reserved6 : Always_0Bool_t;
   Is_Big_Page : Boolean;
   Is_Global   : Boolean;
   Available : DirEntry_Available_Field_e;
   Table_Address : Paging_Base_Address_t;
end record with Size => 32;
for Page_Directory_Entry use record
   Low_Flags at 0 range 0 .. 5;
   Reserved6 at 0 range 6 .. 6;
   Is_Big_Page at 0 range 7 .. 7;
   Is_Global at 0 range 8 .. 8;
   Available at 0 range 9 .. 11;
   Table_Address at 0 range 12 .. 31;
end record;
for Page_Directory_Entry'Size use 32;

type Page_Directory_Entry_PTR is access all Page_Directory_Entry;

type Page_Directory is array (PagingTables_GeneralRange) of Page_Directory_Entry
   with Alignment => 4096;
for Page_Directory'Alignment use 4096;

type Page_Directory_PTR is access all Page_Directory;

function Extract_DirEntry_Address(
   Entry_PTR : Page_Directory_Entry_PTR
   )
   return Page_Table_PTR
   with
      Export => True,
      Convention => C,
      External_Name => "X86_Paging_Extract_DirEntry_Address";
private

end X86_paging;
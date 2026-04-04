with ReturnBitfields;
package body VGA_80_25 is

function Set_Internal_WritePage (Index : Integer) return ReturnBitfields.GeneralOS is
   Return_Value : ReturnBitfields.GeneralOS;
begin
   Return_Value.ReturnValNameSpace := ReturnBitfields.GeneralOS_ReturnSpace;
   case Index is
      when 0 =>
         CurrentPagePTR := Main_VRAM_PTR;
         CurrentPageIndex := 9;
      when 1 =>
         CurrentPagePTR := TextPage1'Address;
         CurrentPageIndex := 1;
      when 2 =>
         CurrentPagePTR := TextPage2'Address;
         CurrentPageIndex := 2;
      when 3=>
         CurrentPagePTR := TextPage3'Address;
         CurrentPageIndex := 3;
      when 4=>
         CurrentPagePTR := TextPage4'Address;
         CurrentPageIndex := 4;
      when others =>
         Return_Value.TooBigNumber := True;
   end case;
end VGA_80_25;

function Get_Corresponing_Page_PTR (Index : Integer) return VRAM_Array_PTR is
begin
   case Index is
      when 0 =>
         return Main_VRAM_PTR;
      when 1 =>
         return TextPage1'Address;
      when 2 =>
         return TextPage2'Address;
      when 3 =>
         return TextPage3'Address;
      when 4 =>
         return TextPage4'Address;
      when others =>
         
   end case;
end Get_Corresponing_Page_PTR;









procedure ShiftCharsUp(Page : VRAM_Array_PTR) is 
begin
   for I in Row'First+1 .. Row'Last loop
      for J in 0 .. Column'Last loop
         Page.all(I-1, J) := Page.all(I, J);  --Upper Row = Current Row
      end loop;
   end loop;

   for I in Column'First .. Column'Last loop
      Page.all(Row'Last, I) := 0;
   end loop;
end ShiftCharsUp;



procedure MoveCursorForward is
   
begin
   
end MoveCursorForward;



function IncreaseXCord (IncreasedXCordPTR : ColumnPTR) return ReturnBitfields.GeneralOS is
   
begin
   
end IncreaseXCord;



function IncreaseYCord (IncreasedYCordPTR : RowPTR) return ReturnBitfields.GeneralOS is 
   
begin
   
end Name;


end VGA_80_25;
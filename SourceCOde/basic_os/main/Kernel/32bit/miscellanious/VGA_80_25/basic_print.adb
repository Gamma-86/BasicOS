with ReturnBitfields;
package body VGA_80_25 is

function Set_Internal_WritePage (Index : Integer) return ReturnBitfields.GeneralOS is
   Return_Value : ReturnBitfields.GeneralOS;
begin
   Return_Value.ReturnValNameSpace := ReturnBitfields.GeneralOS_ReturnSpace;
   case Index is
      when 0 =>
         CurrentPage := Main_VRAM;
      when 1 =>
         CurrentPage := TextPage1'Address;
      when 2 =>
         CurrentPage := TextPage2'Address;
      when 3=>
         CurrentPage := TextPage3'Address;
      when 4=>
         CurrentPage := TextPage4'Address;
      when others =>
         Return_Value.TooBigNumber := True;
   end case;
end Name;











procedure ShiftCharsUp is

begin
   
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
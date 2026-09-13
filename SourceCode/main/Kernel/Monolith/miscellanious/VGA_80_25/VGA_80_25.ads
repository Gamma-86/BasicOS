with ReturnBitfields;
with System;
with Interfaces.C; use Interfaces.C;
package VGA_80_25 is
   type CharColour is 
   (Black, 
   Blue, 
   Green, 
   Cyan, 
   Red, 
   Magenta, 
   Brown, 
   LightGray
   );
   type CharColour is private;
   for  CharColour'Size use 3;
   for  CharColour use
   (
      Black => 0,
      Blue  => 1,
      Green => 2,
      Cyan  => 3,
      Red   => 4,
      Magenta=>5,
      Brown => 6,
      LightGray=>7
   );

   type VRAM_word is record
      ASCII : Character;
      ForeColour : CharColour;
      ForeBright : Boolean;
      BackColour : CharColour;
      BackColour_attrib : Boolean;
   end record;

   for VRAM_word use record
      ASCII at 0 range 0 .. 7;
      ForeColour at 1 range 0..2;
      ForeBright at 1 range 3..3; 
      BackColour at 1 range 4 .. 6;
      BackColour_attrib at 1 range 7 .. 7;
   end record;
   for VRAM_word'Size use 16;
   type VRAM_word_PTR is access VRAM_word;


   type Row is range 0..24;
   type Column is range 0..79;
   type TextPage_a is array(Row, Column) of VRAM_word; 
   type TextPage_PTR is access all TextPage_a;

   type RowPTR is access Row;
   type ColumnPTR is access Column;

   Screen_Width : constant Natural := 80;
   Screen_Height: constant Natural := 25;



   procedure New_Line;
   function PutChar (Char : Character;ForeColour : CharColour  ;BackColour : CharColour) return ReturnBitfields.GeneralOS;
   function PutChar_XY (Char : Character; X:Integer; Y:Integer) return ReturnBitfields.GeneralOS;
   function Set_Internal_WritePage(Index : Integer) return ReturnBitfields.GeneralOS;

private
   procedure MoveCursorForward;
      procedure MoveCursorForward_Xtimes (X:Integer);
   procedure ShiftCharsUp(Page : TextPage_PTR);  --for everything in ROW
   --Move characters in current ROW to the ROW upper
      procedure shiftCharsUp_ByX(X:integer);
   procedure IncreaseYcord_Full(IncreasedYCord_PTR : RowPTR);
      procedure IncreaseYcord_Full_ByX (IncreasedYCord_PTR:RowPTR ; X:Integer);
   function IncrementXCord(IncreasedXCord : Column) return Column;
   function IncrementYCord(IncreasedYCord : Row) return Row;



   Main_VRAM : TextPage_a with Address => System'To_Address(16#B_8000#);

   Page1 : TextPage_a with Address => System'To_Address(16#B_8000#);
   Page2 : TextPage_a with Address => System'To_Address(16#B_8000#);

   Page1_X, Page2_X, Page3_X : Column := 0;
   Page1_Y, Page2_Y, Page3_Y : Row := 0;


   CurrentPagePTR : TextPage_PTR := TextPage1'Address;
   CurrentPageIndex : Integer := 1;
   Current_CursorXCordPTR : ColumnPTR := TextPage1_X'Address;
   Current_CursorYCordPTR : RowPTR := TextPage1_Y'Address;

end VGA_80_25;
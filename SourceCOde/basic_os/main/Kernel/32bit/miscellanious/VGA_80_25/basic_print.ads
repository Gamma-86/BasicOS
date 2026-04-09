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
   type VGA_VRAM_array is array(Row, Column) of VRAM_word; 

   type RowPTR is access Row;
   type ColumnPTR is access Column;
   type VRAM_Array_PTR is access VGA_VRAM_array;

   Screen_Width : constant Natural := 80;
   Screen_Height: constant Natural := 25;





   function PutChar (Char : Character;ForeColour : CharColour  ;BackColour : CharColour) return ReturnBitfields.GeneralOS
      with
         Export => True,
         Convention => C,
         External_Name => "PutChar";
   
   function PutChar_XY (Char : Character; X:Integer; Y:Integer) return ReturnBitfields.GeneralOS
      with
         Export => True,
         Convention => C,
         External_Name => "PutChar_XY";

   function Set_Internal_WritePage(Index : Integer) return ReturnBitfields.GeneralOS
      with
         Export => True,
         Convention => C,
         External_Name => "Set_Internal_WritePage";


private

   procedure ShiftCharsUp(Page : VRAM_Array_PTR);  --for everything in ROW
   --Move characters in current ROW to the ROW upper
   procedure MoveCursorForward;
   function IncreaseXCord (IncreasedXCord : Column) return Column;
   function IncreaseYCord (IncreasedYCord : Row) return Row;

   Main_VRAM_PTR : VGA_VRAM_array;
   for Main_VRAM_PTR'Address use System'To_Address (16#B_8000#);
   Main_VRAM_X : Column := 0;
   Main_VRAM_Y : Row := 0;

   TextPage1, TextPage2, TextPage3, TextPage4 : aliased VGA_VRAM_array;
   TextPage2_X, TextPage3_X, TextPage4_X : Column := 0;
   TextPage2_Y, TextPage3_Y, TextPage4_Y : Row := 0;
   TextPage1_X : Column := 0;
   TextPage1_Y : Column := 0;


   CurrentPagePTR : VRAM_Array_PTR := TextPage1'Address;
   CurrentPageIndex : Integer := 1;
   Current_CursorXCordPTR : ColumnPTR := TextPage1_X'Address;
   Current_CursorYCordPTR : RowPTR := TextPage1_Y'Address;

end VGA_80_25;
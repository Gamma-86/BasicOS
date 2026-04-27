with ReturnBitfields;
package body VGA_80_25 is
--briefly what is here :
--1 procedure new_line: puts the coordinates as if tere was a new line 
--2 function Set_Internal_Writepage(Index:Integer)
--    return ReturnBitfields.GeneralOS
--    It sets on what page should other writing function write 
--3 Get_Corresponing_Page_PTR (Index : Integer) return VRAM_Array_PTR is
--    Returns pointer to the corresponding page according to the Index
--4 procedure MoveCursorForward
--  This procedure is moves cursor to the position of the next character
--  It is expected to call this after printing the character
--5 procedure ShiftCharsUp(Page : Vram_Array_PTR)
--  takes in pointer to the text array that you want to shift up
--    ofcourse, it is expects 2d array 80x25 of 2 byte elementrs
--  This thing moves all elements of array 1 Y coordinate upper
--    This means to lower Y index because Y starts from upper part of screen
--     So for examplle Row 1 will move to Row 0
--     Row 0 will be overwritten
--     Row 24 will be filled with zero
--6 procedure IncreaseYcord_Full(IncreaseYcord_Full(IncreasedYCord_PTR:RowPTR)
--  It increases y coordinate but also covers the case if the number was
--     Maximum Row coordiante
--  IT ALSO, IN THAT CASE CALLS SHIFT ALL CHARS UP
--7 function IncreaseXcord(IncreaseXCord (IncreasedXCord : Column)
--   Return Column
--  Usually increases X coordinate by 1, but also covers the bahaviour of X
--     During the New line (If the X coordinate is the maximum column coordinate)
--     returns 0
--8 IncrementYCord (IncreasedYCord : Row) return Row
--  This functions usually returns Column that is increased by 1,
--    In other case(which is if Increased Y coordinate is too big)
--    It returns maximum possible y coordinate(probably 24) 

procedure New_Line is
begin
--Steps:
--1:Call Increase y coordinate full
--2:and assign 0 to X coordinate
   IncreaseYcord_Full (CurrentPagePTR);
   Current_CursorXCordPTR.all := 0;
end New_line;

function Set_Internal_WritePage (Index : Integer) 
return ReturnBitfields.GeneralOS is


   Return_Value : ReturnBitfields.GeneralOS;
begin
--Steps:
--1: Check the Integer index that was given to the program
--2: If INdex is 0 , it should be interpreted,
--    as main VGA text VRAM at address 0xb_8000
--    if Index is more than 0 it should be interpreted as page Index
--    If the index is bigger that largest TextPage Index,
--        set the 'TooBigNumber' Bit in return bitfield
--3: If everything is correct, do the folowing :
--    Set 'CurrentPagePTR' to the pointer of where to write
--    Set 'CurrentPageIndex' to the corresponding index of the page
--    Set 'Current_CursorXCordPTR' to the corresponding Pointer
--    Set 'Current_CursorYCordPTR' to the corresponding Pointer
--        Every Page has its own X,Y coordinates
--4: I think this is the end

   Return_Value.ReturnValNameSpace := ReturnBitfields.GeneralOS_ReturnSpace;
   case Index is
      when 0 =>
         CurrentPagePTR := Main_VRAM_PTR;
         CurrentPageIndex := 0;
         Current_CursorXCordPTR.all := Main_VRAM_X'Address;
         Current_CursorYCordPTR.all := Main_VRAM_Y'Address;
      when 1 =>
         CurrentPagePTR := TextPage1'Address;
         CurrentPageIndex := 1;
         Current_CursorXCordPTR.all := TextPage1_X'Address;
         Current_CursorYCordPTR.all := TextPage1_Y'Address;
      when 2 =>
         CurrentPagePTR := TextPage2'Address;
         CurrentPageIndex := 2;
         Current_CursorXCordPTR.all := TextPage1_X'Address;
         Current_CursorYCordPTR.all := TextPage2_Y'Address;
      when 3=>
         CurrentPagePTR := TextPage3'Address;
         CurrentPageIndex := 3;
         Current_CursorXCordPTR.all := TextPage3_X'Address;
         Current_CursorYCordPTR.all := TextPage3_Y'Address;
      when 4=>
         CurrentPagePTR := TextPage4'Address;
         CurrentPageIndex := 4;
         Current_CursorXCordPTR.all := TextPage4_X'Address;
         Current_CursorYCordPTR.all := TextPage4_Y'Address;
      when others =>
         Return_Value.TooBigNumber := True;
   end case;
end VGA_80_25;

function Get_Corresponing_Page_PTR (Index : Integer) return VRAM_Array_PTR is
begin
--What to do:
--1: Read the given INTEGER Index
--2: Get Pointer corresponding to the index
--    IF the index is 0, you should return Pointer to main VGA text VRAM
--    If the index is not, for example 1, give Pointer to Text Page 1
--    If the index is bigger than there are pages, return NULL pointers
--3: Return POinters
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
         return null;
   end case;
end Get_Corresponing_Page_PTR;





procedure MoveCursorForward is
   New_X_Coordinate : Column;
   New_Y_Coordinate : Row;
begin
--Increase the X coordinate, if it's 0 - increase Y coordinate. If it's maximum
--Shift all chars up and call Increasy Y cord

--1: Assign Current X,Y coordinates to local X,Y variables
--2: Increase Local X variable with corresponding function
--3: If the X is not zero,Update X coordinate and EXIT;

--ELSE:
--If the X is 0, you should consider increasing Y
--4:Anyway, Call Increase Y CORD FUNCTION and update LOCAL Y variable
--5:Update Current X and Y coordinates from you local variables

--1:
   New_X_Coordinate := Current_CursorXCordPTR.all;
   New_Y_Coordinate := Current_CursorYCordPTR.all;
--2:
   New_X_Coordinate := IncrementXCord(New_X_Coordinate);
--3:
   if  New_X_Coordinate /= 0 then
      Current_CursorXCordPTR.all := New_X_Coordinate;
      return;
   end if;
--4:
   IncreaseYcord_Full(New_Y_Coordinate'Address);
--5
   Current_CursorXCordPTR.all := New_X_Coordinate;
   Current_CursorYCordPTR.all := New_Y_Coordinate;
end MoveCursorForward;





procedure ShiftCharsUp(Page : VRAM_Array_PTR) is
   Zero_VRAM_Word : VRAM_word := (0,0,0,0,0);
begin
--THe basic idea is to move every character  by 1 position up
--   In this case : COPY TO THE SMALLER ARRAY INDEX (SMALLER ROW INDEX)
--   First Row should overwritten, last row filled with 0 or SPACE (0 better)

--   ARRAY IS ADDRESSED (ROW, COLUM) or you could say (Y, X)

--1: Starting from ROW0 + 1 till LAST ROW, COPY all chars from 0 till LAST Column
--     to Previous ROW (ROW-1)
--2: Fill the last row with zeroyed VRAM words
   for I in Row'First+1 .. Row'Last loop
      for J in 0 .. Column'Last loop
         Page.all(I-1, J) := Page.all(I, J);  --Upper Row = Current Row
      end loop;
   end loop;

   for I in Column'First .. Column'Last loop
      Page.all(Row'Last, I) := Zero_VRAM_Word;
         --Zero Every VRAM Word in Last Row
   end loop;
end ShiftCharsUp;


procedure IncreaseYcord_Full(IncreasedYCord_PTR : RowPTR) is
begin
--what to do: increase Y coordinate by 1, If it's Max - shift all chars up
-- and dont increment Y coordinate

--Steps:
--1 Check if Increased Y coordinate is equal to Maximum
--2 If it is, shift all chars up
--2.1 is it is not, just increment Y with function
--3 I think this is the end

--1
if IncreasedYCord_PTR.all >= Row'Last then 
--2
   ShiftCharsUp (CurrentPagePTR);
   IncreasedYCord_PTR.all := Row'Last;
else
--2.1
   IncreasedYCord_PTR.all := IncreasedYCord_PTR.all + 1;
end if;
end IncreaseYcord_Full;


function IncreaseXCord(IncreasedXCord : Column) return Column is
begin
--What to do:
--the basic idea is to increase X by 1
--if the result is more than Max X coordinate(Column), make it 0

   IncreasedXCord := IncreasedXCord + 1;

   if IncreasedXCord > Column'Last then
      IncreasedXCord := 0;
   end if;

   return IncreasedXCord;
end IncrementXCord;



function IncrementYCord(IncreasedYCord : Row) return Row is 
begin
--You should Increase Y by one, 
--But if Y is more than Possible Max Row index, Y cord = Max Row index
--  Usually, in that case, you would need to shift all chars up
--  But we don't want to cause side effects
   IncreasedYCord := IncreasedYCord + 1;

   if IncreasedYCord > Row'Last then
      IncreasedYCord := Row'Last;
   end if;
end IncrementYCord;


end VGA_80_25;
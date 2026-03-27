package SEGMENT_DESCRIPTORS is
   type DPL_type is mod 2**2;



   type CodeAccessByte is record
      Accessed : Boolean;
      Readable : Boolean;
      Conforming:Boolean;
      Executable:Boolean;
      IsSegment :Boolean;
      Privelege :DPL_type;
      IsPresent :Boolean;
   end record;
   for CodeAccessByte use record
      Accessed at 0 range 0 .. 0;
      Readable at 0 range 1 .. 1;
      Conforming at 0 range 2 .. 2;
      Executable at 0 range 3 .. 3;
      IsSegment at 0 range 4 .. 4;
      Privelege at 0 range 5 .. 6;
      IsPresent at 0 range 7 .. 7;
   end record;
   for CodeAccessByte'Size use 8;



   type DataAccessByte is record
      Accessed : Boolean;
      Writable : Boolean;
      ExpandDown:Boolean;
      Executable:Boolean;
      IsSegment :Boolean;
      Privelege :DPL_type;
      IsPresent :Boolean;
   end record;
   for DataAccessByte use record
      Accessed at 0 range 0 .. 0;
      Writable at 0 range 1 .. 1;   
      ExpandDown at 0 range 2 .. 2;
      Executable at 0 range 3 .. 3;
      IsSegment at 0 range 4 .. 4;
      Privelege at 0 range 5 .. 6;
      IsPresent at 0 range 7 .. 7;
   end record;
   for DataAccessByte'Size use 8;



   type SizeTypeFlags is record
      Available : Boolean;
      Reserved64 : Boolean;
      Is32bit : Boolean;
      Granular: Boolean;
   end record;
   for SizeTypeFlags use record
      Available at 0 range 0 .. 0;
      Reserved64 at 0 range 1 .. 1;
      Is32bit at 0 range 2 .. 2;
      Granular at 0 range 3 .. 3;
   end record;
   for SizeTypeFlags'Size use 4; 



   type Base_Low_Type is mod 2**24;
   type Base_High_Type is mod 2**8;

   type Limit_Low_Type is mod 2**16;
   type Limit_High_Type is mod 2**4;



   type CodeSegment is record
      LimitLow : Limit_Low_Type;
      BaseLow  : Base_Low_Type;
      AccessByte:CodeAccessByte;
      LimitHigh: Limit_High_Type;
      Flags : SizeTypeFlags;
      BaseHigh: Base_High_Type;
   end record;
   for CodeSegment use record
      LimitLow at 0 range 0 .. 15;
      BaseLow at 0 range 16 .. 39;
      AccessByte at 4 range 8 .. 15;
      LimitHigh at 4 range 16 .. 19;
      Flags at 4 range 20 .. 23;
      BaseHigh at 4 range 24 .. 31;
   end record;
   for CodeSegment'Size use 64;



   type DataSegment is record
      LimitLow : Limit_Low_Type;
      BaseLow  : Base_Low_Type;
      AccessByte:DataAccessByte;
      LimitHigh: Limit_High_Type;
      Flags : SizeTypeFlags;
      BaseHigh : Base_High_Type;
   end record;
   for DataSegment use record
      LimitLow at 0 range 0 .. 15;
      BaseLow at 0 range 16 .. 39;
      AccessByte at 4 range 8 .. 15;
      LimitHigh at 4 range 16 .. 19;
      Flags at 4 range 20 .. 23;
      BaseHigh at 4 range 24 .. 31;
   end record;
   for DataSegment'Size use 64;













private
   
end SEGMENT_DESCRIPTORS;

with IA32_Types;
with Interfaces;
with System;
package PCI_Bus.ConfSpace is

type API_RetBitfield is record
   NoPCI : Boolean;
   flag1 : Boolean;
   flag2 : Boolean;
   flag3 : Boolean;
   flag4 : Boolean;
   flag5 : Boolean;
   flag6 : Boolean;
   flag7 : Boolean;
   flag8 : Boolean;
   flag9 : Boolean;
   flag10 : Boolean;
   flag11 : Boolean;
   flag12 : Boolean;
   flag13 : Boolean;
   flag14 : Boolean;
   CriticalError : Boolean;
end record with Size=>16;
for API_RetBitfield use record
   NoPCI at 0 range 0 .. 0;
   flag1 at 0 range 1 .. 1;
   flag2 at 0 range 2 .. 2;
   flag3 at 0 range 3 .. 3;
   flag4 at 0 range 4 .. 4;
   flag5 at 0 range 5 .. 5;
   flag6 at 0 range 6 .. 6;
   flag7 at 0 range 7 .. 7;
   flag8 at 0 range 8 .. 8;
   flag9 at 0 range 9 .. 9;
   flag10 at 0 range 10 .. 10;
   flag11 at 0 range 11 .. 11;
   flag12 at 0 range 12 .. 12;
   flag13 at 0 range 13 .. 13;
   flag14 at 0 range 14 .. 14;
   CriticalError at 0 range 15 .. 15;
end record;



function Init_Interface(
   Mechanism1_Present : Boolean;
   Mechanism2_Present : Boolean;
   Force_Init : Boolean
) return API_RetBitfield;









type HDR_types is(
   GenericDevice,
   PCI_PCI_bridge,
   PCI_CardBus_bridge
) with Size => 8;
for HDR_types use(
   GenericDevice => 0,
   PCI_PCI_bridge => 1,
   PCI_CardBus_bridge => 2
);


type VendorID_t is mod 2**16 with Size=>16;
type DeviceID_t is mod 2**16 with Size=>16;
type RevisionID_t is mod 2**8 with Size=>8;
type InterfaceID_t is mod 2**8 with Size=>8;
type Subclass_t is mod 2**8 with Size=>8;
type ClassCode_t is mod 2**8 with Size=>8;
type CacheDwordsSize_t is mod 2**8 with Size=>8; 
type LatencyTimer_t is mod 2**8 with Size=>8;


type BIST_ResltCode is new Integer range 0 .. 15 with Size=>4;
type SelfTest_reg is record
   ResultCode : BIST_ResltCode;
   Zeroed : Integer range 0..0;
   Do_SelfTest : Boolean;
   CanDo_SelfTest : Boolean;
end record with Size => 8;
for SelfTest_reg use record
   ResultCode at 0 range 0 .. 3;
   Zeroed at 0 range 4 .. 5;
   Do_SelfTest at 0 range 6 .. 6;
   CanDo_SelfTest at 0 range 7 .. 7;
end record;



type ParityError_mode_t is(
   NotSet_PERR_Pin,
   Set_PERR_Pin
);
for ParityError_mode_t use(
   NotSet_PERR_Pin => 0,
   Set_PERR_Pin=>1
);

type Command_reg is record
   Use_PMIO : Boolean;
   Use_MMIO : Boolean;
   CanBe_BusMaster : Boolean;
   Monitor_SpecCycles : Boolean;
   Allow_MemWriteInvalidate : Boolean;
   VGA_palette_snoop : Boolean;
   ParityErr_mode : ParityError_mode_t;
   Zeroed : Boolean range False..False;
   SERR_Enabled : Boolean;
   Fast_Transactions_Enabled : Boolean;
   Disable_Interrupt : Boolean;
   Reserved : Integer range 0 .. 0;
end record with Size =>16;
for Command_reg use record
   Use_PMIO at 0 range 0 .. 0;
   Use_MMIO at 0 range 1 .. 1;
   CanBe_BusMaster at 0 range 2 .. 2;
   Monitor_SpecCycles at 0 range 3 .. 3;
   Allow_MemWriteInvalidate at 0 range 4 .. 4;
   VGA_palette_snoop at 0 range 5 .. 5;
   ParityErr_mode at 0 range 6 .. 6;
   Zeroed at 0 range 7 .. 7;
   SERR_Enabled at 0 range 8 .. 8;
   Fast_Transactions_Enabled at 0 range 9 .. 9;
   Disable_Interrupt at 0 range 10 .. 10;
   Reserved at 0 range 11 .. 15;
end record;



type Devsel_timings_t is(
   Fast_responce,
   Medium_responce,
   Slow_responce
) with Size=>2;
for Devsel_timings_t use(
   Fast_responce =>0,
   Medium_responce=>1,
   Slow_responce=>2
);

type Status_reg is record
   Reserved1 : Integer range 0..0;
   InterruptStatus : Boolean;
   CapabilityList_present : Boolean;
   CanRun_66MHZ : Boolean;
   Reserved2 : Boolean;
   Fast_Transactions_Capable : Boolean;
   Masters_parity_error : Boolean;
   DevSelect_timings : Devsel_timings_t;
   Wrote_TargetAbort : Boolean;
   Read_TargetsAbort : Boolean;
   Read_MastersAbort : Boolean;
   Wrote_SysError : Boolean;
   Parity_error : Boolean;
end record with Size => 16;
for Status_reg use record
   Reserved1 at 0 range 0 .. 2;
   InterruptStatus at 0 range 3 .. 3;
   CapabilityList_present at 0 range 4 .. 4;
   CanRun_66MHZ at 0 range 5 .. 5;
   Reserved2 at 0 range 6 .. 6;
   Fast_Transactions_Capable at 0 range 7 .. 7;
   Masters_parity_error at 0 range 8 .. 8;
   DevSelect_timings at 0 range 9 .. 10;
   Wrote_TargetAbort at 0 range 11 .. 11;
   Read_TargetsAbort at 0 range 12 .. 12;
   Read_MastersAbort at 0 range 13 .. 13;
   Wrote_SysError at 0 range 14 .. 14;
   Parity_error at 0 range 15 .. 15;
end record;







type CommonRegs_r is record
   VendorID : VendorID_t;
   DeviceID : DeviceID_t;
   Command : Command_reg;
   Status : Status_reg;
   RevisionID : RevisionID_t;
   ProgInterface : InterfaceID_t;
   SubClass : Subclass_t;
   ClassCode : ClassCode_t;
   CacheLineSize : CacheDwordsSize_t;
   LatencyTime : LatencyTimer_t;
   HeaderType : HDR_types;
   SelfTest : SelfTest_reg;
end record with Size => 128;
for CommonRegs_r use record
   VendorID at 0 range 0 .. 15;
   DeviceID at 0 range 16 .. 31;

   Command at 4 range 0 .. 15;
   Status at 4 range 16 .. 31;

   RevisionID at 8 range 0 .. 7;
   ProgInterface at 8 range 8 .. 15;
   SubClass at 8 range 16 .. 23;
   ClassCode at 8 range 24 .. 31;

   CacheLineSize at 12 range 0 .. 7;
   LatencyTime at 12 range 8 .. 15;
   HeaderType at 12 range 16 .. 23;
   SelfTest at 12 range 24 .. 31;
end record;
type CommonRegs_r_PTR is access all CommonRegs_r;






type MMIO_Address_Types is(
   Is_Address32,
   Is_Address64
);
for MMIO_Address_Types use(
   Is_Address32=>0,
   Is_Address64=>2
);

type MMIO_BarAddressField is mod 2**28 with Size=>28;
type PMIO_BarAddressField is mod 2**14 with Size=>14;

type BAR_reg(Is_PMIO:Boolean)is record
case Is_PMIO is
   when True =>
      Zeroed1 : Integer range 0..0;
      Port : PMIO_BarAddressField;
      Zeroed2 : Integer range 0..0;
   when False=>
      Address_Width : MMIO_Address_Types;
      MMIO_CanPrefetch : Boolean;
      Address : MMIO_BarAddressField;
end case;
end record with Size => 32;
for BAR_reg use record
   Is_PMIO at 0 range 0 .. 0;
   
   Zeroed1 at 0 range 1 .. 1;
   Port at 0 range 2 .. 15;
   Zeroed2 at 0 range 16 .. 15;

   Address_Width at 0 range 1 .. 2;
   MMIO_CanPrefetch at 0 range 3 .. 3;
   Address at 0 range 4 .. 31;
end record;
type BAR_reg_PTR is access all BAR_reg;

function CVT_PortToBAR(Port:IA32_Types.Port_t)return BAR_reg;
function CVT_AddressToBAR(Address:System.Address ; Address_bitness:MMIO_Address_Types)return BAR_reg;


type Interrupt_Pins_t is(
   NO_Interrupt,
   INT_A,
   INT_B,
   INT_C,
   INT_D
);
for Interrupt_Pins_t use(
   NO_Interrupt => 0,
   INT_A => 1,
   INT_B => 2,
   INT_C => 3,
   INT_D => 4
);

type DeviceSpecific_reg is record
   BAR0 : BAR_reg;
   BAR1 : BAR_reg;
   BAR2 : BAR_reg;
   BAR3 : BAR_reg;
   BAR4 : BAR_reg;
   BAR5 : BAR_reg;
   CardBusInfo_PTR : Syste.Address;
   Mobo_VendorID : Subsys_VendorID_t;
   Mobo_ID : Interfaces.Unsigned_16;
   ROM_Address : System.Address;
   CapabilityList_Offset : Interfaces.Unsigned_8;
   Reserved : Integer range 0..0;
   Interrupt_Line : Interfaces.Unsigned_8;
   Interrupt_Pin : Interrupt_Pins_t;
   Device_ControlBUS_MinTime_025us : Interfaces.Unsigned_8;
   Device_ControlBUS_Period_025us : Interfaces.Unsigned_8;
end record with Size => 384;
for DeviceSpecific_reg use record
   BAR0 at 0 range 0 .. 31;
   BAR1 at 4 range 0 .. 31;
   BAR2 at 8 range 0 .. 31;
   BAR3 at 12 range 0 .. 31;
   BAR4 at 16 range 0 .. 31;
   BAR5 at 20 range 0 .. 31;
   CardBusInfo_PTR at 24 range 0 .. 31;
   Mobo_VendorID at 28 range 0 .. 15;
   Mobo_ID at 28 range 16 .. 31;
   ROM_Address at 32 range 0 .. 31;
   CapabilityList_Offset at 36 range 0 .. 7;
   Reserved at 36 range 8 .. 63;
   Interrupt_Line at 44 range 0 .. 7;
   Interrupt_Pin at 44 range 8 .. 15;
   Device_ControlBUS_MinTime_025us at 44 range 16 .. 23;
   Device_ControlBUS_Period_025us at 44 range 24 .. 31;
end record;



type PCIBridge_IO_Low_r is record
   Low_Constant : Integer range 1..1;
   Address_12_15 : Interfaces.Unsigned_8 range 0..15;
end record with Size=>8;
for PCIBridge_IO_Low_r use record
   Low_Constant at 0 range 0 .. 3;
   Address_12_15 at 0 range 4 .. 7;
end record;

type PCIBridge_IO_Highreg_t is mod 2**16 with Size=>16;

type API_PCIBridge_IO_regFused is record
   Low : PCIBridge_IO_Low_r;
   High : PCIBridge_IO_Highreg_t;
end record with Size=>24;
for API_PCIBridge_IO_regFused use record
   Low at 0 range 0 .. 7;
   High at 0 range 8 .. 23;
end record;


type PCI_PCI_IO_LowBase_reg is new PCIBridge_IO_Low_r;
type PCI_PCI_IO_HighBase_reg is new PCIBridge_IO_Highreg_t;

type PCI_PCI_IO_LowLimit_reg is new PCIBridge_IO_Low_r;
type PCI_PCI_IO_HighLimit_reg is new PCIBridge_IO_Highreg_t;


type PCI_PCI_Specific_reg is record
   BAR0 : BAR_reg;
   BAR1 : BAR_reg;
   Connects_THE : Bus_Indx;
   Connects_TO  : Bus_Indx;
   ConnectsTO_LastBus : Bus_Indx;
   IO_BaseLow : PCI_PCI_IO_LowBase_reg;
   IO_LimitLow : PCI_PCI_IO_LowLimit_reg;
   
end record;






function Get_CommonConfSpace(
   RegisterOffset : Reg_Indx;
   FunctionIndex : Fun_Indx;
   DeviceNumber : Dev_Indx;
   BusNUmber : Bus_Indx;
   ConfigStoragePTR : CommonRegs_r_PTR
) return API_RetBitfield;

private
end PCI_Bus.ConfSpace;
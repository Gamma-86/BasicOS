#ifndef KERNEL_INSPECT_BOOT_H_SENTRY
#define KERNEL_INSPECT_BOOT_H_SENTRY
#include <stdint.h>

enum RAMMap_MemoryType{
    Available_RAM = 1,
    ReservedBySomething_RAM = 2,
    ACPI_RAM = 3,
    RAM_ForHibernation = 4,
    Bad_RAM_type = 5,

    EFI_Loader_Code = 6,
    EFI_Loader_Data = 7,
    
    EFI_Boot_Code = 8,
    EFI_Boot_Data = 9,

    EFI_Runtime_Code = 10,
    EFI_Runtime_Data = 11,

    ACPI_Reclaim_RAM = 12,
    ACPI_NVS = 13,

    MMIO_RAM_Type = 14,
    PMIO_Port_Type = 15,

    MotherBoard_Code = 16,
    EEPROM_RAM = 17,

    Normal_RAM_END = 18
};
struct RAMMap_DescriptorEntry
{
    uint64_t Physical_Address;
    uint64_t Virtual_Address;
    uint64_t Size;
    enum RAMMap_MemoryType Type;
    uint32_t Flag_atributes;
};
extern struct RAMMap_DescriptorEntry* RAMMap_DescriptorsArray;





#endif
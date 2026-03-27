%ifndef MULTRIBOOT_STRUCTURES_NASM_SENTRY
%define MULTRIBOOT_STRUCTURES_NASM_SENTRY

struc MB2Info_MainHead
    .Total_size resd 1
    .Reserved   resd 1
endstruc
struc MB2Info_TagHead
    .Type resd 1
    .Size resd 1
endstruc



%define MB2Info_BasicRam_type 4
%define MB2Info_BasicRam_size 16
struc MB2Info_BasicRAMInfo
    .Type   resd 1
    .Size   resd 1
    .RAMlow_size resd 1
    .RAMhigh_size resd 1
endstruc



%define MB2Info_CMDline_type 1
struc MB2Info_CMDline
    .Type   resd 1
    .Size   resd 1
    .Argument_string resb 1
endstruc



%define MB2Info_Module_type 3
struc MB2Info_Module
    .Type  resd 1
    .Size  resd 1
    .Start resd 1    ;This
    .End   resd 1    ;and this are physical addresses
    .Name_string resb 1
endstruc



%define MB2Info_RAMmap_type 6
%define RAMmap_type_FreeRAM 1
%define RAMmap_type_ACPI 3
%define RAMmap_type_Hibernation 4
struc MB2Info_RAMMap
    .Type resd 1,
    .Size resd 1
    .Entry_size resd 1
    .Entry_version resd 1
    .Entries_start resb 1
endstruc
struc RAMMap_entry
    .Address resq 1
    .Length    resq 1
    .Type    resd 1
    .Reserved resd 1
endstruc



%define MB2Info_LoaderName_type 2
struc MB2Info_LoaderName
    .Type resb 4
    .Size resb 4
    .Name_string resb 1
endstruc



%define MB2Info_APM_type 10
%define MB2Info_APMI_size 28
struc MB2Info_APM
    .Type   resb 4
    .Size   resb 4
    .Version resb 2
    .Cseg   resb 2
    .Offset resb 4
    .Cseg16 resb 2
    .Dseg   resb 2
    .Flags resb 2
    .Cseg_len resb 2
    .Cseg16_len resb 2
    .Dseg_len  resb 2
endstruc



%define MB2Info_VBE_type 7
%define MB2Info_VBE_size 784
struc   MB2Info_VBIOS
    .Type    resb 4
    .Size    resb 4
    .VBEMode resb 2
    .VBEBIOS_386Interface_segment resb 2
    .VBEBIOS_386Interface_offset  resb 2
    .VBEBIOS_386Interface_length  resb 2
    .VBE_control_info resb 512
    .VBE_mode_info resb 256
endstruc





%define MB2Info_VRAM_type 8
struc MB2Info_VRAM
    .Type    resb 4
    .Size    resb 4
    .Address resb 8
    .Pitch   resb 4
    .Width   resb 4
    .Height  resb 4
    .BitsPerPixel resb 1
    .VRAM_type resb 1
    .Reserved resb 1
    .ColourInfo_start resb 1
endstruc

    %define VRAM_IndexedMode 0
    %define VRAM_RGBMode 1
    %define VRAM_EGAMode 2
    struc VRAM_palette_info
        .Amount_of_colours resb 4
        .Colours_array resb 1
    endstruc
        struc palette_colour_RGB
            .Red resb 1
            .Green resb 1
            .Blue resb 1
        endstruc
    struc RGBInfo
        .Red_position resb 1
        .Red_bitness  resb 1
        .Green_position resb 1
        .Green_bitness resb 1
        .Blue_position resb 1
        .Blue_bitness  resb 1 
    endstruc





%define MB2Info_UEFI32table_type 11
%define MB2Info_UEFI32table_fullsize 12
struc MB2Info_UEFI32table
    .Type resb 4
    .Size resb 4
    .Pointer resb 4
endstruc



%define MB2Info_UEFI64table_type 12
%define MB2Info_UEFI64table_fullsize 16
struc MB2Info_UEFI64table
    .Type resb 4
    .Size resb 4
    .Pointer resb 8
endstruc



%define MB2Info_SMBIOS_type 13
struc MB2Info_SMBIOS
    .Type resb 4
    .Size resb 4
    .Major resb 1
    .minor resb 1
    .Reserved resb 6
    .Tables resb 1
endstruc



%define MB2Info_ACPIv1_type 14
struc MB2Info_ACPIv1
    .Type resb 4
    .Size resb 4
    .RSDPcopy resb 1
endstruc



%define MB2Info_ACPIv2_type 15
struc MB2Info_ACPIv2
    .Type resb 4
    .Size resb 4
    .RSDPcopy resb 1
endstruc



%define MB2Info_DHCP_ACK_type 16
struc MB2Info_DHCP_ACK_network
    .Type resb 4
    .Size resb 4
    .DHCP_ACK resb 1
endstruc


%define MB2Info_UEFI_RAM_MAP_type 17
struc MB2Info_UEFI_RAM_MAP
    .Type resb 4
    .Size resb 4
    .DescriptorSize resb 4
    .DescriptorVersion resb 4
    .Map resb 1
endstruc



%define MB2Info_UEFIBootActive_type 18
struc MB2Info_UEFIBootActive
    .Type resb 4
    .Size resb 4
endstruc



%define MB2Info_UEFI32handle_type 19
struc MB2Info_UEFI32handle
    .Type resb 4
    .Size resb 4
    .pointer resb 4
endstruc



%define MB2Info_UEFI64handle_type 20
struc MB2Info_UEFI64handle
    .Type resb 4
    .Size resb 4
    .Pointer resb 8
endstruc



%define MB2Info_BaseAddress_type 21
struc MB2Info_BaseAddress
    .type resb 4
    .size resb 4
    .address resb 4
endstruc





%endif
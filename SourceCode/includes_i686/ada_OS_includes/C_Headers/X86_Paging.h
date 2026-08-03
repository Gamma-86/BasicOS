#ifndef X86_PAGING_H_SENTRY
#define X86_PAGING_H_SENTRY

#include <stdint.h>


#define X86_PageSize_Normal 4096;
#define X86_PageSize_Big_NoPAE 0x400000;
#define X86_PageSize_Big_PAE   0x200000;


#define X86_PagesTable_Size 0x800
#define X86_DirectoriesTable_Size 0x800;


typedef uint32_t  Page_Table_Entry;
typedef uint32_t  Directory_Table_Entry;

void* X86_Paging_Extract_TableEntry_Address(Page_Table_Entry* The_Entry_PTR);
Page_Table_Entry* X86_Paging_Extract_DirEntry_Address(Directory_Table_Entry* The_Entry_PTR);




enum PagingEntry_General_Flags_Bits{
    EntryFlag_Is_Present = 0,
    EntryFlag_Is_Writable= 1,
    EntryFlag_Is_SuperVisor=2,
    EntryFlag_Is_WriteThrough=3,
    EntryFlag_Cache_Disabled =4,
    EntryFlag_WasAccessed = 5,
};

#endif
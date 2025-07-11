#include <efi.h>
#include <efilib.h>

#include "bootloader.h"

EFI_STATUS
EFIAPI
efi_main (EFI_HANDLE ImageHandle, EFI_SYSTEM_TABLE *SystemTable)
{ 
  EFI_LOADED_IMAGE *loaded_image = NULL;                  /* image interface */
  EFI_GUID lipGuid = EFI_LOADED_IMAGE_PROTOCOL_GUID;      /* image interface GUID */
  //EFI_FILE_IO_INTERFACE *IOVolume;                        /* file system interface */
  //EFI_GUID fsGuid = EFI_SIMPLE_FILE_SYSTEM_PROTOCOL_GUID; /* file system interface GUID */
  //EFI_FILE_HANDLE Volume;/
  EFI_STATUS status;

  InitializeLib(ImageHandle, SystemTable);

  status = uefi_call_wrapper(BS->HandleProtocol, 3, ImageHandle, &lipGuid, (void **) &loaded_image);

  Print(L"Image loaded at: 0x%lx\n", (uint64_t)loaded_image->ImageBase);
  // Write image base and marker for GDB
  volatile uint64_t *marker_ptr = (uint64_t *)0x10000;
  volatile uint64_t *image_base_ptr = (uint64_t *)0x10008;
  *image_base_ptr = (uint64_t)loaded_image->ImageBase;  // Store ImageBase
  *marker_ptr = 0xDEADBEEF;   // Set marker

  Print(L"Hello, world!\n");

  status = uefi_call_wrapper(SystemTable->ConOut->OutputString,
                                        2,
                                        SystemTable->ConOut,
                                        L"Hello, World!\n");
  return status;
}

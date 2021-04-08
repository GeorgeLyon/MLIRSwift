#ifndef MLIRSwiftSupport_h
#define MLIRSwiftSupport_h

#include "llvm-c/Core.h"
#include "mlir-c/Support.h"

#ifdef __cplusplus
extern "C" {
#endif

// Opaque Type Declarations

#define DEFINE_C_API_STRUCT(name, storage)                                     \
  struct name {                                                                \
    storage *ptr;                                                              \
  };                                                                           \
  typedef struct name name

DEFINE_C_API_STRUCT(LLVMDWARFContainerRef, void);

#undef DEFINE_C_API_STRUCT

// DWARF

LLVMDWARFContainerRef LLVMDWARFContainerCreate(const char * path);

void LLVMDWARFContainerDestroy(LLVMDWARFContainerRef c);

uint LLVMDWARFContainerGetNumErrors(LLVMDWARFContainerRef c);

uint LLVMDWARFContainerGetError(LLVMDWARFContainerRef c, uint i);

bool LLVMDWARFContainerHasContexts(LLVMDWARFContainerRef c);

typedef void (*LLVMSourceLocationCallback)(MlirStringRef, uint32_t, uint32_t, void *);
void LLVMDWARFContainerLookup(LLVMDWARFContainerRef c, LLVMSourceLocationCallback, uint64_t address, void *userData);

#ifdef __cplusplus
}
#endif

#endif /* MLIRSwiftSupport_h */

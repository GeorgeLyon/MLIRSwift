
#include "MLIRSwiftSupport.h"

#include "mlir/CAPI/Support.h"

#include "llvm/DebugInfo/DIContext.h"
#include "llvm/DebugInfo/DWARF/DWARFContext.h"
#include "llvm/Object/Archive.h"
#include "llvm/Object/MachOUniversal.h"
#include "llvm/Object/ObjectFile.h"

using namespace llvm;
using namespace llvm::object;

const char *message() {
    return "Hello, World!";
}

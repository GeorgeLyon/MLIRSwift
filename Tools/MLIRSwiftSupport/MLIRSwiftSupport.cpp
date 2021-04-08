
#include "MLIRSwiftSupport.h"

#include "mlir/CAPI/Support.h"
#include "mlir/CAPI/Wrap.h"

#include "llvm/DebugInfo/DIContext.h"
#include "llvm/DebugInfo/DWARF/DWARFContext.h"
#include "llvm/Object/Archive.h"
#include "llvm/Object/MachOUniversal.h"
#include "llvm/Object/ObjectFile.h"

using namespace llvm;
using namespace llvm::object;

/// DWARF

/// This code is adapted from llvm-dwarfdump.cpp in LLVM
struct DWARFContainer {
    std::vector<std::pair<StringRef, std::error_code>> nonfatalErrors;
    std::vector<std::unique_ptr<DWARFContext>> contexts;
};

DEFINE_C_API_PTR_METHODS(LLVMDWARFContainerRef, DWARFContainer)

/// Create is defined below

void LLVMDWARFContainerDestroy(LLVMDWARFContainerRef c) {
    delete unwrap(c);
}

void LLVMDWARFContainerLookup(LLVMDWARFContainerRef c, 
                             LLVMSourceLocationCallback callback,
                             uint64_t address, void* userData) {
    for (auto &context : unwrap(c)->contexts) {
        // TODO: it is neccessary to set proper SectionIndex here.
        // object::SectionedAddress::UndefSection works for only absolute addresses.
        if (DILineInfo LineInfo = context->getLineInfoForAddress(
                {address, object::SectionedAddress::UndefSection})) 
        {
            callback(wrap(LineInfo.FileName), LineInfo.Line, LineInfo.Column, userData);
        }
    }
}

static uint32_t getCPUType(MachOObjectFile &MachO) {
  if (MachO.is64Bit())
    return MachO.getHeader64().cputype;
  else
    return MachO.getHeader().cputype;
}

static bool filterArch(ObjectFile &Obj, std::string Arch) {
  if (Arch == "any") return true;
  
  if (auto *MachO = dyn_cast<MachOObjectFile>(&Obj)) {
    // Match architecture number.
    unsigned Value;
    if (!StringRef(Arch).getAsInteger(0, Value))
    if (Value == getCPUType(*MachO))
        return true;

    // Match as name.
    if (MachO->getArchTriple().getArchName() == Triple(Arch).getArchName())
    return true;
  }
  return false;
}

static bool error(StringRef Prefix, std::error_code EC, 
                  std::vector<std::pair<StringRef, std::error_code>> &errors) {
  if (!EC)
    return false;
  errors.push_back({Prefix, EC});
  return true;
}

static bool handleBuffer(StringRef Filename, MemoryBufferRef Buffer, std::string architecture,
                         std::vector<std::unique_ptr<DWARFContext>> &contexts,
                         std::vector<std::pair<StringRef, std::error_code>> &errors);

static bool handleArchive(StringRef Filename, Archive &Arch, std::string architecture,
                         std::vector<std::unique_ptr<DWARFContext>> &contexts,
                         std::vector<std::pair<StringRef, std::error_code>> &errors) {
  bool Result = true;
  Error Err = Error::success();
  for (auto Child : Arch.children(Err)) {
    auto BuffOrErr = Child.getMemoryBufferRef();
    if (error(Filename, errorToErrorCode(BuffOrErr.takeError()), errors)) return false;
    auto NameOrErr = Child.getName();
    if (error(Filename, errorToErrorCode(NameOrErr.takeError()), errors)) return false;
    std::string Name = (Filename + "(" + NameOrErr.get() + ")").str();
    Result &= handleBuffer(Name, BuffOrErr.get(), architecture, contexts, errors);
  }
  if (error(Filename, errorToErrorCode(std::move(Err)), errors)) return false;
  return Result;
}

static bool handleBuffer(StringRef Filename, MemoryBufferRef Buffer, std::string architecture,
                         std::vector<std::unique_ptr<DWARFContext>> &contexts,
                         std::vector<std::pair<StringRef, std::error_code>> &errors) {
  Expected<std::unique_ptr<Binary>> BinOrErr = object::createBinary(Buffer);
  if (error(Filename, errorToErrorCode(BinOrErr.takeError()), errors)) return false;

  bool Result = true;
  auto RecoverableErrorHandler = [&](Error E) {
    Result &= error(Filename, errorToErrorCode(std::move(E)), errors);
  };
  if (auto *Obj = dyn_cast<ObjectFile>(BinOrErr->get())) {
    if (filterArch(*Obj, architecture)) {
      auto context = DWARFContext::create(*Obj, nullptr, "", RecoverableErrorHandler);
      contexts.push_back(std::move(context));
    }
  }
  else if (auto *Fat = dyn_cast<MachOUniversalBinary>(BinOrErr->get()))
    for (auto &ObjForArch : Fat->objects()) {
      std::string ObjName =
          (Filename + "(" + ObjForArch.getArchFlagName() + ")").str();
      if (auto MachOOrErr = ObjForArch.getAsObjectFile()) {
        auto &Obj = **MachOOrErr;
        if (filterArch(Obj, architecture)) {
          auto context = DWARFContext::create(Obj, nullptr, "", RecoverableErrorHandler);
          contexts.push_back(std::move(context));
        }
        continue;
      } else
        consumeError(MachOOrErr.takeError());
      if (auto ArchiveOrErr = ObjForArch.getAsArchive()) {
        if (error(ObjName, errorToErrorCode(ArchiveOrErr.takeError()), errors)) return false;
        if (!handleArchive(ObjName, *ArchiveOrErr.get(), architecture, contexts, errors))
          Result = false;
        continue;
      } else
        consumeError(ArchiveOrErr.takeError());
    }
  else if (auto *Arch = dyn_cast<Archive>(BinOrErr->get()))
    Result = handleArchive(Filename, *Arch, architecture, contexts, errors);
  return Result;
}

static bool handleFile(StringRef Filename, std::string architecture,
                       std::vector<std::unique_ptr<DWARFContext>> &contexts,
                       std::vector<std::pair<StringRef, std::error_code>> &errors) {
  ErrorOr<std::unique_ptr<MemoryBuffer>> BuffOrErr =
  MemoryBuffer::getFileOrSTDIN(Filename);
  if (error(Filename, BuffOrErr.getError(), errors)) return false;
  std::unique_ptr<MemoryBuffer> Buffer = std::move(BuffOrErr.get());
  return handleBuffer(Filename, *Buffer, architecture, contexts, errors);
}

/// If the input path is a .dSYM bundle (as created by the dsymutil tool),
/// replace it with individual entries for each of the object files inside the
/// bundle otherwise return the input path.
static std::vector<std::string> expandBundle(const std::string &InputPath,
                                             std::vector<std::pair<StringRef, std::error_code>> &errors) {
  std::vector<std::string> BundlePaths;
  SmallString<256> BundlePath(InputPath);
  // Normalize input path. This is necessary to accept `bundle.dSYM/`.
  sys::path::remove_dots(BundlePath);
  // Manually open up the bundle to avoid introducing additional dependencies.
  if (sys::fs::is_directory(BundlePath) &&
      sys::path::extension(BundlePath) == ".dSYM") {
    std::error_code EC;
    sys::path::append(BundlePath, "Contents", "Resources", "DWARF");
    for (sys::fs::directory_iterator Dir(BundlePath, EC), DirEnd;
         Dir != DirEnd && !EC; Dir.increment(EC)) {
      const std::string &Path = Dir->path();
      sys::fs::file_status Status;
      EC = sys::fs::status(Path, Status);
      if (error(Path, EC, errors)) continue;
      switch (Status.type()) {
      case sys::fs::file_type::regular_file:
      case sys::fs::file_type::symlink_file:
      case sys::fs::file_type::type_unknown:
        BundlePaths.push_back(Path);
        break;
      default: /*ignore*/;
      }
    }
    // error(BundlePath, EC); This is present in the LLVM code but is unnecessary
  }
  if (!BundlePaths.size())
    BundlePaths.push_back(InputPath);
  return BundlePaths;
}

LLVMDWARFContainerRef LLVMDWARFContainerCreate(const char * path) {
  auto container = new DWARFContainer();
  for (auto Object : expandBundle(path, container->nonfatalErrors))
    /// We can implement architecture filtering later
    handleFile(Object, "any", container->contexts, container->nonfatalErrors);
  return wrap(container);
}

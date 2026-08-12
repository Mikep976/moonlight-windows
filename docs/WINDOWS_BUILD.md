# Windows build guide

This fork keeps the existing Moonlight Qt Windows build pipeline and treats both x64 and ARM64 as first-class targets.

## CI baseline

The existing GitHub Actions workflow uses:

- Windows Server 2025 runners
- Qt 6.11.1
- MSVC 2022 x64 Qt
- Qt's `win64_msvc2022_arm64_cross_compiled` package for ARM64
- `scripts\build-arch.bat Release x64`
- `scripts\build-arch.bat Release arm64`

Do not remove either Windows architecture from CI when changing the UI, renderer, input stack, packaging, or dependencies.

## Local prerequisites

For Windows development, install Visual Studio 2022 with the C++ desktop toolchain and a compatible Qt 6 MSVC kit. The build script locates Visual Studio with the repository's `vswhere.exe` and selects the appropriate native or cross-compiling toolchain automatically.

Clone the repository with submodules:

```powershell
git clone --recurse-submodules https://github.com/Mikep976/moonlight-windows.git
cd moonlight-windows
```

Fetch the Windows dependencies from the repository root:

```powershell
powershell ./setup-deps.ps1
```

## Build x64

Run from a Qt command prompt, or otherwise make sure the matching Qt `bin` directory containing `qmake` is on `PATH`:

```cmd
scripts\build-arch.bat Release x64
```

The script determines the actual target architecture from the Qt kit on `PATH`, initializes the Visual Studio toolchain, compiles Moonlight, deploys Qt dependencies, collects symbols, and builds the Windows package.

## Build ARM64

Use the Qt 6 MSVC ARM64 cross-compiled kit on `PATH`, then run:

```cmd
scripts\build-arch.bat Release arm64
```

The build script detects the `_arm64` Qt path and configures the matching MSVC cross-compilation environment.

## Output

Release deployment folders are created under `build/`, including architecture-specific deploy and symbols directories. GitHub Actions uploads the x64 and ARM64 deployment folders as separate artifacts.

## Modernization rule

A Windows-facing change is not considered validated until both x64 and ARM64 builds pass. Performance-sensitive changes should additionally be tested on real hardware before merge; CI success only proves the code builds and packages.

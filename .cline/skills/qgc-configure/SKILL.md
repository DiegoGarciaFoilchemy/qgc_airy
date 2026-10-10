---
name: qgc-configure
description: Configure the QGroundControl CMake build using the Qt 6.8.3 qt-cmake wrapper, Ninja generator, and Debug build type. Use when setting up a fresh build directory, re-configuring after CMakeLists.txt or dependency changes, or when a new build/ directory is needed.
---

# Configure QGroundControl Build

Run the Qt CMake wrapper to configure the project from the repository root:

```bash
~/Qt/6.8.3/gcc_64/bin/qt-cmake -B build -G Ninja -DCMAKE_BUILD_TYPE=Debug
```

## Notes

- Uses the Qt 6.8.3 `gcc_64` `qt-cmake` wrapper installed under `~/Qt/6.8.3/`. Adjust this path if your Qt version/install location differs.
- Generator: **Ninja** (single-config).
- Build type: **Debug**.
- Must be run from the repository root so the `build/` directory is created in the right place.
- After configuration completes, build the project with the `qgc-build` skill.

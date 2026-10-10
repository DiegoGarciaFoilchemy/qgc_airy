---
name: qgc-build
description: Build the QGroundControl project with CMake/Ninja in Debug configuration. Use when compiling the project after configuration or code changes, or when the user asks to build or compile QGroundControl.
---

# Build QGroundControl

Build the project from the repository root:

```bash
cmake --build build --config Debug
```

## Notes

- Assumes the `build/` directory has already been configured (see the `qgc-configure` skill).
- The project uses the **Ninja** single-config generator, so `--config Debug` matches the configured `CMAKE_BUILD_TYPE=Debug`.
- Run from the repository root.
- On success, the binary is produced at `build/Debug/QGroundControl` (run it with the `qgc-run` skill).

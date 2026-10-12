---
name: qgc-run
description: Run the QGroundControl application from the build directory using the xcb Qt platform plugin. Use when the user wants to launch, start, or run QGroundControl for testing.
---

# Run QGroundControl

Launch QGroundControl from the repository root:

```bash
QT_QPA_PLATFORM=xcb QT_LINUX_ACCESSIBILITY_ALWAYS_ON=1 ./build/Debug/QGroundControl
```

## Notes

- `QT_QPA_PLATFORM=xcb` forces the X11/xcb platform plugin, which is useful on Linux when both Wayland and X11 are available and xcb is desired.
- `QT_LINUX_ACCESSIBILITY_ALWAYS_ON=1` forces Qt accessibility on so an X11 on-screen keyboard (e.g. `onboard`) can detect focus and show automatically.
- The binary is built to `build/Debug/QGroundControl`.
- Requires a successful build first (see the `qgc-build` skill).

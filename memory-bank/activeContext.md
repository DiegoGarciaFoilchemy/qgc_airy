# Active Context

## Current focus

The first removal pass is complete and verified. The build passes with zero warnings, and the application starts.

## Recent changes

First removal pass, 2026-11-13: see `progress.md` for the measured result.

## Active decisions

- Keep the PX4 plugin. It is the only firmware plugin while ArduPilot is disabled.
- Keep English and Spanish. Add a locale to `QGC_LANGUAGES` to restore one.
- Remove in passes. Resources first, then small subsystems, then maps, then mission planning.
- Set the option in the CMake cache as well as in `CustomOptions.cmake`. An existing cache value overrides the new default.

## Next steps

1. Start pass two: video, analyze tools, ADSB, Follow Me, joystick, camera and gimbal.
2. Measure the binary again after pass two.
3. Confirm the language and feature questions with the crew.

## Open questions

- Does the Gerris crew use the analyze tools, the joystick or a camera?
- Does the crew need any language other than English and Spanish?
- Does the map ever show on a secondary screen?

## Patterns and preferences

- Edit the build options first. Use the existing `#ifdef` guards.
- Keep the Gerris pages untouched.
- Measure before and after each pass with the object `size` method described in `techContext.md`.

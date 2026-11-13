# Active Context

## Current focus

Pass one and part of pass two are complete and verified. Follow Me and ADSB are gone. The analyze tools stay, because the crew uses them.

## Recent changes

- Pass one: 3D viewer off, fonts trimmed, translations limited to Spanish, ArduPilot images dropped. See `progress.md`.
- Pass two, part one: Follow Me and ADSB removed.
- Maps switched off at startup: the hidden `PlanView` and its `FlightMap` are gone, so no tile cache and no tile requests.

## Active decisions

- Keep the analyze tools: MAVLink inspector, MAVLink console, log download and geotag.
- Keep the component information download. The Gerris firmware supplies parameter metadata through `COMPONENT_INFORMATION`, so the FTP download and `QGCCompInfoFileDownloadCache` stay.
- Keep Mock Link and PX4 log transfer. The crew uses both, and log transfer needs `FTPManager`.
- Keep `src/UI/toolbar`. The live bar uses `FlightModeIndicator` and `MainStatusIndicator`.
- Keep the PX4 plugin. It is the only firmware plugin while ArduPilot is disabled.
- Keep English and Spanish.
- Remove in passes. Resources first, then small subsystems, then maps, then mission planning.
- Set the option in the CMake cache as well as in `CustomOptions.cmake`. An existing cache value overrides the new default.

## Next steps

1. Optionally delete `src/MissionManager` and `PlanViewSettings`, which are inert now.
2. Run a full functional test on the ship computer: links, parameters, setup pages, Gerris pages.
3. Review the remaining Qt modules in the deployment for more savings.

## Open questions

- Does the Gerris crew use the analyze tools, the joystick or a camera?
- Does the crew need any language other than English and Spanish?
- Does the map ever show on a secondary screen?

## Patterns and preferences

- Edit the build options first. Use the existing `#ifdef` guards.
- Keep the Gerris pages untouched.
- Measure before and after each pass with the object `size` method described in `techContext.md`.

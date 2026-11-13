# Product Context

## Why this project exists

The Gerris is a foiling boat. The crew needs one screen for vessel state, power train, foil and rudder control. Standard QGroundControl is built for drones. It carries maps, mission planning, video and 3D views that the boat does not use.

## Problems it solves

- One operator view for the boat.
- Direct access to the ACU state, the battery state and the warnings.
- A smaller and faster build for the ship computer.

## How it works

The application starts into a three page swipe view. The pages are `Page1`, `Page4` and `Page3` in `src/FlightDisplay`. The pages read Gerris fact groups from the active vehicle. The operator changes modes and setpoints through facts and MAVLink commands.

## User experience goals

- A dark screen that is readable at night.
- Large, clear state labels.
- No map, no mission, no video on the main screen.
- English and Spanish only.

## Known constraints

- The system runs on Linux without Wayland.
- The autopilot speaks a custom MAVLink dialect from `mavlinkAiry_C`.

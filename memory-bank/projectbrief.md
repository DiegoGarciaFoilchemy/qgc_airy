# Project Brief

This repository is a fork of QGroundControl, a ground control station for MAVLink vehicles. The fork serves the Gerris foiling boat.

The fork keeps vehicle telemetry, parameter editing, setup pages, link management and the custom Gerris pages. The fork does not use mission planning, maps, the 3D viewer, video or the ArduPilot plugin.

## Goals

- Show Gerris boat telemetry on custom pages.
- Control the boat, the ACUs, the foils and the rudder.
- Keep the build lean by removing unused QGroundControl features.
- Ship a Linux desktop build.

## Scope

In scope: MAVLink links, vehicle facts, Gerris fact groups, custom pages, setup pages, links, settings.

Out of scope: mission planning, maps, 3D viewer, video, ArduPilot support, Android and iOS builds.

## Source of truth

The branch `01-LTS_Gerris` is the delivery branch. The remote `upstream` points to mavlink/qgroundcontrol. The remote `origin` points to DiegoGarciaFoilchemy/qgc_airy.

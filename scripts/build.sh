#!/usr/bin/env bash
set -euo pipefail

# Wrapper build script: run configure only when build isn't configured
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="$ROOT/build"
QT_CMAKE="${HOME}/Qt/6.8.3/gcc_64/bin/qt-cmake"
CONFIGURE_NEEDED=0

if [ ! -f "$BUILD_DIR/CMakeCache.txt" ]; then
  CONFIGURE_NEEDED=1
else
  CACHE_MTIME=$(stat -c %Y "$BUILD_DIR/CMakeCache.txt")
  # check top-level CMakeLists and .cmake files under repo (depth 3)
  while IFS= read -r file; do
    [ -e "$file" ] || continue
    if [ "$(stat -c %Y "$file")" -gt "$CACHE_MTIME" ]; then
      CONFIGURE_NEEDED=1
      break
    fi
  done < <(find "$ROOT" -maxdepth 3 -type f \( -name 'CMakeLists.txt' -o -name '*.cmake' \))
fi

if [ "$CONFIGURE_NEEDED" -eq 1 ]; then
  echo "Running configure..."
  "$QT_CMAKE" -B "$BUILD_DIR" -G Ninja -DCMAKE_BUILD_TYPE=Debug
else
  echo "Configure up-to-date; skipping."
fi

cmake --build "$BUILD_DIR" --config Debug

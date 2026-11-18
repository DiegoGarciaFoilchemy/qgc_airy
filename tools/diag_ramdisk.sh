#!/bin/sh

# Show what fills the RAM disk while QGroundControl runs.
# Run the script on the appliance while the application slows down, then run it
# again a minute later and compare the numbers.

set -u

echo "===== RAM disks ====="
df -h -t tmpfs 2>/dev/null || df -h

echo
echo "===== Resident memory of QGroundControl ====="
PID=$(pidof QGroundControl 2>/dev/null | awk '{print $1}')
if [ -n "${PID}" ]; then
    grep -E 'VmRSS|VmSwap|VmSize' /proc/"${PID}"/status
    echo "Open files with a size:"
    ls -l /proc/"${PID}"/fd 2>/dev/null | grep -c . || true
else
    echo "QGroundControl is not running"
fi

echo
echo "===== Application folders ====="
for DIR in \
    "${HOME}/.config/QGroundControl" \
    "${HOME}/.local/share/QGroundControl" \
    "${HOME}/.cache/QGroundControl" \
    "${HOME}/Documents/QGroundControl" \
    /tmp
do
    if [ -d "${DIR}" ]; then
        du -sh "${DIR}" 2>/dev/null
    fi
done

echo
echo "===== Largest files ====="
du -ah "${HOME}" /tmp 2>/dev/null | sort -rh | head -20

echo
echo "===== Temporary MAVLink logs ====="
ls -l /tmp/*.mavlink 2>/dev/null || echo "none"

echo
echo "===== Saved telemetry logs ====="
find "${HOME}" -name '*.tlog' -type f 2>/dev/null | wc -l
find "${HOME}" -name '*.tlog' -type f 2>/dev/null | head -5

echo
echo "===== Files changed in the last five minutes ====="
find "${HOME}" /tmp -type f -mmin -5 2>/dev/null | head -20

#!/system/bin/sh

SYSFS=/sys/devices/platform/10010000.kp/keycodetype

for i in $(seq 1 30); do
    if [ -e "$SYSFS" ]; then
        echo 2 > "$SYSFS"
        exit 0
    fi
    sleep 1
done

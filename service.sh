#!/system/bin/sh
# One35 No System Buttons - service.sh
# Runs on boot, applies the saved mode (default 2)

MODDIR=${0%/*}
SYSFS=/sys/devices/platform/10010000.kp/keycodetype
STATE="$MODDIR/keycodetype.state"

# Read saved value, default to 2
TARGET=$(cat "$STATE" 2>/dev/null)
case "$TARGET" in
    0|1|2) ;;
    *) TARGET=2 ;;
esac

# Wait up to 30 seconds for node to become writable
WAITED=0
until [ -w "$SYSFS" ] || [ $WAITED -ge 30 ]; do
    sleep 1
    WAITED=$((WAITED + 1))
done

[ -w "$SYSFS" ] && echo $TARGET > "$SYSFS"

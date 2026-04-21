#!/system/bin/sh
# One35 No System Buttons - action.sh

MODDIR=${0%/*}
SYSFS=/sys/devices/platform/10010000.kp/keycodetype
STATE="$MODDIR/keycodetype.state"

label() {
    case "$1" in
        0) echo "Android Select (A)" ;;
        1) echo "Android Select (A) and Back (B)" ;;
        2) echo "No Android system buttons" ;;
        *) echo "Unknown" ;;
    esac
}

# Read current saved value, default to 2
CURRENT=$(cat "$STATE" 2>/dev/null | tr -d '[:space:]')
case "$CURRENT" in
    0|1|2) ;;
    *) CURRENT=2 ;;
esac

# Cycle to next
NEXT=$(( (CURRENT + 1) % 3 ))

# Save
echo $NEXT > "$STATE"

# Apply and verify
# Node returns "type=N" so strip the "type=" prefix
if [ -w "$SYSFS" ]; then
    echo $NEXT > "$SYSFS"
    RAW=$(cat "$SYSFS" 2>/dev/null | tr -d '[:space:]')
    VERIFY="${RAW#type=}"
    if [ "$VERIFY" -eq "$NEXT" ] 2>/dev/null; then
        echo "- Mode: $(label $NEXT)"
        echo "- SUCCESS: Change will survive reboot"
    else
        echo "- Mode: $(label $NEXT)"
        echo "- FAILED: Node is currently $VERIFY"
    fi
else
    echo "- Mode: $(label $NEXT)"
    echo "- FAILED: Node not writable"
fi

#!/bin/bash
# Usage: notify.sh <message> <sound>
# Only sends notification if user has been idle for IDLE_THRESHOLD seconds.

IDLE_THRESHOLD=12

idle_time=$(ioreg -c IOHIDSystem | awk '/HIDIdleTime/ {print int($NF/1000000000); exit}')

if [ "${idle_time:-0}" -ge "$IDLE_THRESHOLD" ]; then
    osascript -e "display notification \"$1\" with title \"Claude Code\" sound name \"$2\""
fi

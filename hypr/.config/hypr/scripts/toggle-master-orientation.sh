#!/bin/bash

# Get current workspace ID
wsid=$(hyprctl activeworkspace -j | grep '"id":' | awk '{print $2}' | tr -d ,)

# Get current layout for the workspace (master layout must be active)
layout=$(hyprctl activeworkspace -j | grep '"layout":' | awk -F'"' '{print $4}')

# Only proceed if layout is master
if [ "$layout" != "master" ]; then
  hyprctl dispatch layoutmsg master
  sleep 0.1
fi

# Use a simple toggle state file
STATE_FILE="/tmp/hypr_master_orientation_$wsid"

if [ ! -f "$STATE_FILE" ]; then
  echo "center" > "$STATE_FILE"
fi

CURRENT=$(cat "$STATE_FILE")

# Cycle through center -> left -> right -> center...
case "$CURRENT" in
  center)
    NEW=left
    ;;
  left)
    NEW=right
    ;;
  *)
    NEW=center
    ;;
esac

# Save new state
echo "$NEW" > "$STATE_FILE"

# Send the change to Hyprland
hyprctl dispatch layoutmsg orientation "$NEW"


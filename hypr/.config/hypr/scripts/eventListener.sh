#!/usr/bin/env bash

function getWindowCount {
  echo $(hyprctl activeworkspace | grep -E "windows: [0-9]+" | awk '{print $2}')
}

function changeSlaveCountForCenterMaster {
  windowCount=$(getWindowCount)
  echo "windowCount: $windowCount"
  if [[ $windowCount > 2 ]]; then
    hyprctl keyword master:slave_count_for_center_master 0
    hyprctl keyword master:mfact 0.6
    echo "change slave_count_for_center_master to 0"
  elif [[ $windowCount < 3 ]]; then
    hyprctl keyword master:slave_count_for_center_master 2
    hyprctl keyword master:mfact 0.5
    echo "change slave_count_for_center_master to 2"
  fi
}

function handle {
  command=$(echo $1 | awk -F '>>' '{print $1}')
  echo $command
  if [[ $command == "openwindow" || $command == "closewindow" ]]; then
    changeSlaveCountForCenterMaster
  fi
}

# run before listening to socket
changeSlaveCountForCenterMaster

socat - "UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do handle "$line"; done

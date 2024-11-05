#!/bin/bash

# W I N D O W  T I T L E

# Get the title of the currently focused window
WINDOW_TITLE=$(aerospace list-windows | jq -r '.[] | select(.focused == true) | .title')

# If the title is empty, fallback to the application name
if [[ -z $WINDOW_TITLE ]]; then
  WINDOW_TITLE=$(aerospace list-windows | jq -r '.[] | select(.focused == true) | .app')
fi

# Truncate if the window title is too long
if [[ ${#WINDOW_TITLE} -gt 50 ]]; then
  WINDOW_TITLE=$(echo "$WINDOW_TITLE" | cut -c 1-50)
  sketchybar -m --set title label="│ $WINDOW_TITLE…"
  exit 0
fi

# Set the window title in sketchybar
sketchybar -m --set title label="│ $WINDOW_TITLE"


#!/bin/bash

# Front app configuration
FRONT_APP=(
  icon.color=$PEACH
  label.color=$WHITE
  background.color=$NORD_BG1
  background.corner_radius=5
  background.height=25
  background.padding_left=5
  background.padding_right=5
  padding_left=30
  padding_right=-6
  script="$PLUGIN_DIR/front_app.sh"
)

# Add the front_app item
sketchybar --animate elastic 15 \
  --add item front_app left \
  --set front_app "${FRONT_APP[@]}" \
  --subscribe front_app front_app_switched space_change


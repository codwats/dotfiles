#!/bin/bash

# Colors
INACTIVE_COLOR="$NORD_BG1" # Translucent white for inactive
ACTIVE_COLOR="$NORD_BG2"   # Solid white for active

# Dimensions
SPACE_WIDTH=11
SPACE_HEIGHT=11
SPACE_MARGIN=5       # Margin between space indicators
BACKGROUND_PADDING=8 # Padding inside background container

# Common settings for all spaces
SPACE=(
  update_freq=5
  background.height=$SPACE_HEIGHT
  background.drawing=on
  background.color=$INACTIVE_COLOR
  background.corner_radius=$(($SPACE_HEIGHT / 2))
  background.padding_right=0 # Remove padding right since we're using margins
  icon.drawing=off
  label.drawing=off
  script="$PLUGIN_DIR/space.sh"
)

SPACES_BAR=(
  update_freq=5
  background.color=$TRANSPARENT
  background.corner_radius=$(($SPACE_HEIGHT / 2))
  background.height=25
  background.padding_left=5
  background.padding_right=5
)

# sketchybar --add event aerospace_workspace_change
#
# for sid in $(aerospace list-workspaces --all); do
#   sketchybar --add item space.$sid left \
#     --subscribe space.$sid aerospace_workspace_change \
#     --set space.$sid \
#     background.color=0x44ffffff \
#     background.corner_radius=5 \
#     background.height=20 \
#     background.drawing=on \
#     label="$sid" \
#     click_script="aerospace workspace $sid" \
#     script="$CONFIG_DIR/plugins/aerospace.sh $sid"
# done

#!/bin/bash

# Function to create space indicators
function create_space_indicators() {
  # First, remove all existing space-related items in sketchybar
  sketchybar --remove '/space\..*/' 2>/dev/null || true
  sketchybar --remove '/space_margin\..*/' 2>/dev/null || true
  sketchybar --remove '/spaces_bracket/' 2>/dev/null || true

  # Get all workspace IDs
  SPACES=$(aerospace list-workspaces --all)

  # Initialize an array to store all items for the bracket
  ALL_ITEMS=()

  # Loop through each workspace ID
  for sid in $SPACES; do
    # Create a space indicator in sketchybar for each workspace
    sketchybar --add item space.$sid left \
      --set space.$sid label="Space $sid" \
      background.color=0x44ffffff \
      background.corner_radius=5 \
      background.height=20 \
      click_script="aerospace workspace $sid" \
      width=$SPACE_WIDTH

    # Add this space indicator to the list of all items
    ALL_ITEMS+=(space.$sid)

    # Optionally, add a margin if not the last item
    if [[ "$sid" != "${SPACES##* }" ]]; then
      sketchybar --add item space_margin.$sid left \
        --set space_margin.$sid width=$SPACE_MARGIN \
        background.drawing=off
      ALL_ITEMS+=(space_margin.$sid)
    fi
  done

  # Create a bracket in sketchybar with all space items
  [ ${#ALL_ITEMS[@]} -gt 0 ] &&
    sketchybar --add bracket spaces_bracket "${ALL_ITEMS[@]}" \
      --set spaces_bracket "${SPACES_BAR[@]}"
}

# Function to handle workspace changes
function workspace_change_handler() {
  create_space_indicators
}

# Initial creation of space indicators
create_space_indicators

# Subscribe to workspace changes in sketchybar
sketchybar --add event aerospace_workspace_change
sketchybar --subscribe space aerospace_workspace_change workspace_change_handler

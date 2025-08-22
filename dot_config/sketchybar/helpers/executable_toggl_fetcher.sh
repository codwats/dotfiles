#!/bin/bash

# Configuration
API_TOKEN="04b258296de9c8048333ed31fff3f6d5"

# Format time
format_duration() {
  local seconds=$1
  local hours=$((seconds / 3600))
  local minutes=$(((seconds % 3600) / 60))
  local secs=$((seconds % 60))
  printf "%02d:%02d:%02d" $hours $minutes $secs
}

# Command argument processing
if [ "$1" = "stop" ]; then
  # Get current timer ID
  timer_info=$(curl -s -u "$API_TOKEN:api_token" "https://api.track.toggl.com/api/v9/me/time_entries/current")
  timer_id=$(echo "$timer_info" | grep -o '"id":[^,}]*' | sed 's/"id"://')

  if [ -n "$timer_id" ] && [ "$timer_id" != "null" ]; then
    # Stop the timer
    curl -s -u "$API_TOKEN:api_token" -X PATCH "https://api.track.toggl.com/api/v9/time_entries/$timer_id/stop" >/dev/null
    echo "stopped"
    exit 0
  else
    echo "no_timer"
    exit 0
  fi
fi

# Get current timer
current_timer=$(curl -s -u "$API_TOKEN:api_token" "https://api.track.toggl.com/api/v9/me/time_entries/current")

# Check if there's an active timer
if [ "$current_timer" = "null" ] || [ -z "$current_timer" ]; then
  echo "no_timer"
  exit 0
fi

# Extract data using simple pattern matching
description=$(echo "$current_timer" | grep -o '"description":"[^"]*"' | sed 's/"description":"//;s/"//')
project_id=$(echo "$current_timer" | grep -o '"project_id":[^,}]*' | sed 's/"project_id"://')
duration=$(echo "$current_timer" | grep -o '"duration":[^,}]*' | sed 's/"duration"://')
workspace_id=$(echo "$current_timer" | grep -o '"workspace_id":[^,}]*' | sed 's/"workspace_id"://')

# Better tag extraction - completely different approach
tag=""
# Step 1: Extract just the tags array portion
tags_array=$(echo "$current_timer" | sed -n 's/.*"tags":\[\([^]]*\)\].*/\1/p')
# Step 2: If we have tags, extract the first one without any extra text
if [ -n "$tags_array" ]; then
  # Remove outer quotes and get first tag
  tag=$(echo "$tags_array" | sed 's/^"//;s/"$//;s/",".*//;s/"//g')
fi

# Display name priority: tag > description > "Unnamed"
display_name=""
if [ -n "$tag" ]; then
  display_name="$tag"
elif [ -n "$description" ]; then
  display_name="$description"
else
  display_name="Unnamed timer"
fi

# Get project name if project_id exists and isn't null
project_name=""
if [ -n "$project_id" ] && [ "$project_id" != "null" ]; then
  project_data=$(curl -s -u "$API_TOKEN:api_token" "https://api.track.toggl.com/api/v9/workspaces/$workspace_id/projects/$project_id")
  project_name=$(echo "$project_data" | grep -o '"name":"[^"]*"' | sed 's/"name":"//;s/"//')
fi

# Calculate elapsed time for running timer
if [ "$duration" -lt 0 ]; then
  current_time=$(date +%s)
  start_time=$((-duration))
  elapsed=$((current_time - start_time))
  elapsed_formatted=$(format_duration $elapsed)

  # Assemble final output
  echo "running|$display_name|$project_name|$elapsed_formatted"
else
  echo "no_timer"
fi

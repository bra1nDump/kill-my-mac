#!/bin/bash

# Get the user's home directory
USER_HOME=$(eval echo ~$USER)

# Get the current directory
PROJECT_DIR=$(pwd)

# Plist name
PLIST_NAME="com.bra1ndump.shutdown-during-sleep-hours.plist"

# Ensure a soft link is present
ln -sf "$PROJECT_DIR/$PLIST_NAME" "$USER_HOME/Library/LaunchAgents/$PLIST_NAME"

# Unload and load the plist - this will restart the agent
launchctl unload "$USER_HOME/Library/LaunchAgents/$PLIST_NAME"
launchctl load "$USER_HOME/Library/LaunchAgents/$PLIST_NAME"
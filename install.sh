#!/bin/bash

# Get the user's home directory
USER_HOME=$(eval echo ~$USER)

# Get the current directory
# TODO: Getting project directory will be harder when running this as part of brew install
PROJECT_DIR=$(pwd)
BUILD_DIR="$PROJECT_DIR/build"

# Create the build directory if it doesn't exist
mkdir -p $BUILD_DIR

# Plist name
PLIST_NAME="com.bra1ndump.kill-my-mac.plist"
LAUCH_AGENT_TEMPLATE="$PROJECT_DIR/templates/$PLIST_NAME"

# Pre-process the plist
LAUCH_AGENT="$BUILD_DIR/$PLIST_NAME"
cat $LAUCH_AGENT_TEMPLATE | sed "s|{{PROJECT_DIR}}|$PROJECT_DIR|g" > $LAUCH_AGENT

# Validate plist
plutil -lint $LAUCH_AGENT

# Ensure a soft link is present
ln -sf $LAUCH_AGENT "$USER_HOME/Library/LaunchAgents/$PLIST_NAME"

# Unload and load the plist - this will restart the agent
launchctl unload "$USER_HOME/Library/LaunchAgents/$PLIST_NAME" || true
launchctl load "$USER_HOME/Library/LaunchAgents/$PLIST_NAME"

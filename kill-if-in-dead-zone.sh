#!/bin/sh

echo "Checking if in dead zone. Current time:" $(date +"%H:%M:%S") 

# Check if in dead zone
dead_zone_hour=0
dead_zone_minute=0

# $((some string)) used to convert string to integer 
# by using the string as part of an arithmetic operation
let current_hour=$(date +"%H")
let current_minute=$(date +"%M")

echo "Current hour:" $current_hour
echo "Current minute:" $current_minute

if [ $current_hour -eq $dead_zone_hour ] \
    && [ $current_minute -eq $dead_zone_minute ]; \
then
    say you are an intellectual athlete and you fucker have to go to sleep, I am shutting this shit down for your own good

    osascript -e 'tell application "System Events" to shut down'
fi
  

# 
# osascript -e beep
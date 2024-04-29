#!/bin/sh

echo "Local time zone is:" $(date +"%Z")
echo "Checking if in dead zone. Current time:" $(date +"%H:%M:%S")

echo "Checking if computer is asleep - if so, do nothing"
sleep_wake_events=$(pmset -g log | grep -e " Sleep  " -e " Wake  ")
# Example output:       
# 2024-04-29 13:03:49 -0700 Sleep                 Entering Sleep state due to 'Clamshell Sleep' ...
# 2024-04-29 13:05:06 -0700 Wake                  Wake from Deep Idle [CDNVA] : due to SMC.     ...

# Check if the last event is a sleep event
if [[ $(echo "$sleep_wake_events" | tail -n 1 | grep "Sleep" ) != "" ]]; then
    echo "Computer is asleep. Human is being good. Not attempting to shut down."
    exit 0
fi

# Define dead zone start and end
dead_zone_start_hour=0
dead_zone_start_minute=0
dead_zone_end_hour=6
dead_zone_end_minute=0

# Calculate dead zone start and end in minutes from midnight
dead_zone_start_minutes=$((dead_zone_start_hour * 60 + dead_zone_start_minute))
dead_zone_end_minutes=$((dead_zone_end_hour * 60 + dead_zone_end_minute))

# Get current hour and minute, and calculate total minutes from midnight
current_hour=$(date +"%H")
current_minute=$(date +"%M")
current_minutes=$((current_hour * 60 + current_minute))

echo "Current hour:" $current_hour
echo "Current minute:" $current_minute
echo "Total minutes from midnight:" $current_minutes

######## Utilities ########

# Function to check if two values are nearly equal within a given proximity
is_near() {
    local value1=$1
    local value2=$2
    local proximity=$3
    # Absolute difference
    local diff=$((value1 > value2 ? value1 - value2 : value2 - value1))

    # When no return is used, status code from the last command is used
    # test <expression> is the same as [ <expression> ]
    # when the test succeeds, 0 status code is returned from the command
    test $diff -le $proximity
}

# Warning message 1 hour before the dead zone
warning_one_hour_before=$((dead_zone_start_minutes - 60))
if is_near $current_minutes $warning_one_hour_before 0; then
    echo "1 hour before dead zone"
    say "Warning: The dead zone starts in one hour. Prepare to finish up any pending tasks."
fi

# Warning message 10 minutes before the dead zone suggesting to wrap it up for real now
warning_ten_minutes_before=$((dead_zone_start_minutes - 10))
if is_near $current_minutes $warning_ten_minutes_before 0; then
    echo "10 minutes before dead zone"
    say "Warning: The dead zone starts in 10 minutes. Wrap up your work now!"
fi

# Check if in dead zone
if [ $current_minutes -ge $dead_zone_start_minutes ] \
    && [ $current_minutes -lt $dead_zone_end_minutes ]; \
then
    say "Hey man, its me from both yesterday and tomrorow - GO TO SLEEP! I am shutting this down for your own good."
    sleep 10 # Give time to save work

    osascript -e 'tell application "System Events" to shut down'
fi

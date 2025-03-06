#!/bin/bash

SLEEP_TIME=0.5

# Function to get user input
get_user_input() {
    read -p "$1: " value
    echo "$value"
}

# Get folder name and number of screenshots from user
FOLDER_NAME=$(get_user_input "Enter folder name for screenshots")
NUM_SCREENSHOTS=$(get_user_input "Enter number of screenshots")

# Create a folder to save the screenshots
FOLDER="screenshots/$FOLDER_NAME"
mkdir -p "$FOLDER"
mkdir -p "non-ocr"

# Ask about screen rotation
echo "Do you want to rotate the screen to the left?"
echo "1. Yes"
echo "2. No"

while true; do
    ROTATION_CHOICE=$(get_user_input "Enter your choice (1 or 2)")
    case $ROTATION_CHOICE in
        1)
            echo "Rotating screen to the left..."
            SCREEN=$(xrandr | grep " connected primary" | cut -f1 -d " ")
            xrandr --output $SCREEN --rotate left
            sleep 2
            break
            ;;
        2)
            echo "No screen rotation will be applied."
            break
            ;;
        *)
            echo "Invalid input. Please enter 1 or 2."
            ;;
    esac
done

# Use slop to select the area for screenshots
echo "Please select the area for screenshots"
echo "Press Enter when ready to select"
read -p ""

# Switch to the desired window
xdotool key alt+Tab
sleep $SLEEP_TIME

# Press F11 to prepare for area selection
# echo "Pressing F11. Please wait..."
sleep 2
xdotool key F11
sleep 2
# Selecting area
GEOMETRY=$(slop -f "%x %y %w %h")
read X Y WIDTH HEIGHT <<< $GEOMETRY

# Switch back to terminal
sleep $SLEEP_TIME
xdotool key alt+Tab
sleep $SLEEP_TIME

# Ask user about navigation method
echo "How would you like to navigate between pages?"
echo "1. Right arrow key"
echo "2. Mouse click (single area)"
echo "3. Mouse click (two areas with a delay)"

while true; do
    NAV_METHOD=$(get_user_input "Enter your choice (1, 2, or 3)")
    case $NAV_METHOD in
        1)
            echo "You chose right arrow key navigation."
            break
            ;;
        2)
            echo "You chose single mouse click navigation."
            echo "Please select the area for the clickable button"
            echo "Press Enter when ready to select"
            read -p ""
            CLICK_GEOMETRY=$(slop -f "%x %y %w %h")
            read CLICK_X CLICK_Y CLICK_W CLICK_H <<< $CLICK_GEOMETRY
            CLICK_CENTER_X=$((CLICK_X + CLICK_W/2))
            CLICK_CENTER_Y=$((CLICK_Y + CLICK_H/2))
            break
            ;;
        3)
            echo "You chose double mouse click navigation."
            echo "Please select the first area to click"
            echo "Press Enter when ready to select"
            read -p ""
            FIRST_CLICK_GEOMETRY=$(slop -f "%x %y %w %h")
            read FIRST_CLICK_X FIRST_CLICK_Y FIRST_CLICK_W FIRST_CLICK_H <<< $FIRST_CLICK_GEOMETRY
            FIRST_CLICK_CENTER_X=$((FIRST_CLICK_X + FIRST_CLICK_W/2))
            FIRST_CLICK_CENTER_Y=$((FIRST_CLICK_Y + FIRST_CLICK_H/2))

            echo "Please select the second area to click"
            echo "Press Enter when ready to select"
            read -p ""
            SECOND_CLICK_GEOMETRY=$(slop -f "%x %y %w %h")
            read SECOND_CLICK_X SECOND_CLICK_Y SECOND_CLICK_W SECOND_CLICK_H <<< $SECOND_CLICK_GEOMETRY
            SECOND_CLICK_CENTER_X=$((SECOND_CLICK_X + SECOND_CLICK_W/2))
            SECOND_CLICK_CENTER_Y=$((SECOND_CLICK_Y + SECOND_CLICK_H/2))
            break
            ;;
        *)
            echo "Invalid input. Please enter 1, 2, or 3."
            ;;
    esac
done

# Switch to the desired window
xdotool key alt+Tab
sleep $SLEEP_TIME

# Loop for the specified number of screenshots
for i in $(seq 1 $NUM_SCREENSHOTS)
do
    sleep 0.1
    # Take a screenshot of the specific area and save it in the created folder
    scrot -a $X,$Y,$WIDTH,$HEIGHT "$FOLDER/$i.png"
    sleep $SLEEP_TIME

    # Navigate to next page
    if [ "$NAV_METHOD" = "1" ]; then
        xdotool key Right
    elif [ "$NAV_METHOD" = "2" ]; then
        xdotool mousemove $CLICK_CENTER_X $CLICK_CENTER_Y click 1
    elif [ "$NAV_METHOD" = "3" ]; then
        # Click first area
        xdotool mousemove $FIRST_CLICK_CENTER_X $FIRST_CLICK_CENTER_Y click 1
        sleep 1
        # Click second area
        xdotool mousemove $SECOND_CLICK_CENTER_X $SECOND_CLICK_CENTER_Y click 1
    fi
    sleep $SLEEP_TIME
done

sleep 2
xdotool key F11
sleep 2

# Switch back to terminal
sleep $SLEEP_TIME
xdotool key alt+Tab
sleep $SLEEP_TIME

# Rotate screen back to normal if it was rotated
if [ "$ROTATION_CHOICE" = "1" ]; then
    echo "Rotating screen back to normal orientation..."
    sleep $SLEEP_TIME
    xrandr --output $SCREEN --rotate normal
fi

# Convert images to PDF
echo "Converting images to PDF..."
cd "$FOLDER" || exit
magick $(ls -v *.png) "../../non-ocr/$FOLDER_NAME.pdf"

echo "PDF created successfully: $FOLDER_NAME.pdf"

# Optional: Clean up individual image files
read -p "Do you want to delete the individual PNG files? (y/n): " DELETE_PNGS
if [[ $DELETE_PNGS =~ ^[Yy]$ ]]; then
    rm -r "$FOLDER/"
    echo "PNG files deleted."
fi

echo "Script completed successfully!"

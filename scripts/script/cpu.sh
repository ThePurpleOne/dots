#!/bin/bash

# Function to calculate and display resource usage
calculate_usage() {
    PROGRAM_NAME=$1

    # Calculate the sum of RAM usage for the specified program
    SUM_OF_RAM=$(ps aux | awk '{print $6/1024 " MB\t\t" $11}' | grep "$PROGRAM_NAME" | awk '{sum += $1} END {print sum}')

    # Calculate the sum of CPU usage for the specified program
    SUM_OF_CPU=$(ps aux | awk '{print $3 "\t" $11}' | grep "$PROGRAM_NAME" | awk '{sum += $1} END {print sum}')

    # Print the results
    echo "RAM $PROGRAM_NAME: $SUM_OF_RAM MB"
    echo "CPU $PROGRAM_NAME: $SUM_OF_CPU%"
}

# Check if fzf is installed
if ! command -v fzf &> /dev/null; then
    echo "Error: fzf is not installed. Please install fzf to use the interactive selection."
    exit 1
fi

# Check if a program name is provided
if [ -z "$1" ]; then
    # Use fzf to select a program
    SELECTED_PROGRAM=$(ps aux | awk '{print $11}' | tail -n +2 | sort | uniq | fzf --height=40% --reverse)
    if [ -n "$SELECTED_PROGRAM" ]; then
        calculate_usage "$SELECTED_PROGRAM"
    else
        echo "No program selected."
    fi
else
    # Use the provided program name
    calculate_usage "$1"
fi

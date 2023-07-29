#!/bin/bash

clear
# Function to handle 'Randomize HEX'
randomize_hex() {
    read -p "How many files to create? " num_files
    if ! [[ "$num_files" =~ ^[0-9]+$ ]]; then
        echo "Invalid input. Please enter a positive integer."
        exit 1
    fi

    bash hex.sh "$num_files"
}

# Function to handle 'Randomize pattern'
randomize_pattern() {
    read -p "How many files to create? " num_files
    if ! [[ "$num_files" =~ ^[0-9]+$ ]]; then
        echo "Invalid input. Please enter a positive integer."
        exit 1
    fi

    python3 pattern.py "$num_files"
}

# Main menu
while true; do
    echo "Please select an option:"
    echo "1. Randomize HEX"
    echo "2. Randomize pattern"
    echo "3. Quit"

    read -p "Enter your choice (1/2/3): " choice

    case $choice in
        1)
            randomize_hex
            ;;
        2)
            randomize_pattern
            ;;
        3)
            echo "Exiting."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac
done

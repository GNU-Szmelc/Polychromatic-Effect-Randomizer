#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <num_files>"
    exit 1
fi

num_files="$1"
source_directory="source"
output_directory="effects"

# Function to generate a random hexadecimal color value
generate_random_color() {
    echo -n "#"
    cat /dev/urandom | tr -dc '0-9a-f' | head -c 6
    echo
}

# Function to extract the "name" value from the base file
get_base_file_name() {
    name_line=$(sed -n '2p' "$1")
    base_name=$(echo "$name_line" | grep -oE '"name": "([^"]+)"' | sed 's/"name": "\(.*\)"/\1/')
    echo "$base_name"
}

# Create the output directory if it doesn't exist
mkdir -p "$output_directory"

# Process each JSON file in the source directory
for input_file in "$source_directory"/*.json; do
    # Check if the file exists and is a regular file
    if [ -f "$input_file" ]; then
        # Extract the base file name
        base_file_name=$(get_base_file_name "$input_file")

        # Generate new randomized files
        for ((i = 1; i <= num_files; i++)); do
            output_file="${output_directory}/${base_file_name}_${i}.json"
            cp "$input_file" "$output_file"

            # Extract hex color values using grep and sed
            hex_colors=$(grep -Eo '"#[0-9a-fA-F]{6}"' "$output_file" | sed 's/"//g')

            # Update the JSON file with random hex color values
            for color in $hex_colors; do
                random_color=$(generate_random_color)
                sed -i "s/$color/$random_color/g" "$output_file"
            done

            # Set the proper name in the "name" field
            sed -i "2s/.*/    \"name\": \"${base_file_name}_${i}\",/" "$output_file"

            echo "Hex color values randomized successfully in '$output_file'."
        done
    fi
done

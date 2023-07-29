import os
import sys
import re
import random

def main(num_files):
    # Check if the 'source' folder exists
    if not os.path.exists('source'):
        print("The 'source' folder does not exist.")
        sys.exit(1)

    # Get the list of files in the 'source' folder
    files = os.listdir('source')
    json_files = [f for f in files if f.endswith('.json')]

    # Process each JSON file
    for filename in json_files:
        with open(os.path.join('source', filename), 'r') as f:
            content = f.read()

        pattern = r'"(\d)":\s*"#([0-9a-fA-F]{6})"'
        content = re.sub(pattern, lambda match: f'"{random.randint(0, 5)}": "{match.group(2)}"', content)

        # Create the 'effects' folder if it doesn't exist
        if not os.path.exists('effects'):
            os.makedirs('effects')

        # Write the modified content to the original file
        with open(os.path.join('source', filename), 'w') as f:
            f.write(content)

        # Create new files with modified content
        for i in range(num_files):
            new_filename = os.path.join('effects', f'new_file_{i + 1}_{filename}')
            with open(new_filename, 'w') as new_file:
                new_file.write(content)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 script.py <num_files>")
        sys.exit(1)

    main(int(sys.argv[1]))

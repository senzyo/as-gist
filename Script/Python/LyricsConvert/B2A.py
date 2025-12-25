# https://senzyo.net/2023-8/

import os

def convert_format_B_to_A(input_path, output_path):
    with open(input_path, 'r', encoding='utf-8') as input_file:
        lines = input_file.readlines()

    output_lines = []
    i = 0
    while i < len(lines):
        line = lines[i].strip()
        if '[' in line:
            timestamp = line.split(']')[0] + ']'
            if i + 1 < len(lines) and '[' in lines[i + 1]:
                next_line_timestamp = lines[i + 1].split(']')[0] + ']'
                if timestamp == next_line_timestamp:
                    lyrics_original = line.split(']')[1].strip()
                    lyrics_translation = lines[i + 1].split(']')[1].strip()
                    output_lines.append(f"{timestamp}{lyrics_original} / {lyrics_translation}")
                    i += 1  # Skip the next line as it has been processed
                else:
                    output_lines.append(line)
            else:
                output_lines.append(line)
        else:
            output_lines.append(line)
        i += 1

    # Remove the last empty line if it exists
    if output_lines and not output_lines[-1]:
        output_lines.pop()

    # Create output directory if it doesn't exist
    output_directory = os.path.join(output_path, 'Format-A')
    os.makedirs(output_directory, exist_ok=True)

    # Write the output to a new file in Format-A directory
    output_file_path = os.path.join(output_directory, os.path.basename(input_path))
    with open(output_file_path, 'w', encoding='utf-8') as output_file:
        output_file.write('\n'.join(output_lines))

if __name__ == "__main__":
    input_directory = "./Input"
    output_directory = "./Output"

    # Iterate through all .lrc files in the input directory
    for file_name in os.listdir(input_directory):
        if file_name.endswith(".lrc"):
            input_file_path = os.path.join(input_directory, file_name)
            convert_format_B_to_A(input_file_path, output_directory)

print("Conversion completed.")

#!/bin/bash

# Get the input file path from Nautilus
input_file="$1"

# Determine if the input file is an audio or video file
file_extension="${input_file##*.}"
if [[ "$file_extension" == "mp3" || "$file_extension" == "wav" || "$file_extension" == "ogg" ]]; then
    output_extension="mp3"
else
    output_extension="mp4"
fi

# Ask user for start time in seconds
start_time=$(zenity --entry --title "Start Time" --text "Enter the start time in seconds:")

# Ask user for end time in seconds
end_time=$(zenity --entry --title "End Time" --text "Enter the end time in seconds:")

# Calculate the duration in seconds
duration=$(echo "$end_time - $start_time" | bc)

# Convert the duration to the "HH:MM:SS" format expected by ffmpeg
duration_string=$(date -u -d @${duration} +%T)

# Get the directory path and base filename of the input file
input_dir="$(dirname "$input_file")"
input_filename="$(basename "$input_file")"

# Remove the file extension from the base filename
input_filename_without_ext="${input_filename%.*}"

# Construct the output file path using the input file directory, base filename, and output extension
output_file="$input_dir/$input_filename_without_ext-$start_time-$duration_string.$output_extension"

# Use ffmpeg to cut the segment from the input file and save it to the output file
ffmpeg -ss "$start_time" -i "$input_file" -t "$duration" -c copy "$output_file"

# Print a message when the process is finished
if [ $? -eq 0 ]; then
    zenity --info --title "Process finished" --text "The video segment has been saved to:\n$output_file"
else
    zenity --error --title "Process failed" --text "There was an error while processing the video segment."
fi


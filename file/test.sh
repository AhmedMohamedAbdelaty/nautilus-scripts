#!/bin/bash
# Nautilus script to convert audio to video using FFmpeg

# Check if FFmpeg is installed
if ! command -v ffmpeg &> /dev/null
then
    zenity --error --text="FFmpeg is not installed. Please install FFmpeg and try again."
    exit
fi

# Get selected file(s)
IFS=$'\n'
selected_files=($NAUTILUS_SCRIPT_SELECTED_FILE_PATHS)

for input_audio in "${selected_files[@]}"; do
    # Check if input audio file exists
    if [ ! -f "$input_audio" ]
    then
        zenity --error --text="Input audio file '${input_audio}' does not exist. Please enter a valid file path and try again."
        exit
    fi

    # Get output video file path in the same directory as input audio file
    output_video=$(dirname "$input_audio")/$(basename "$input_audio" | cut -f 1 -d '.').mp4

    # Extract thumbnail from input audio file
    thumbnail=$(ffmpeg -i "$input_audio" -filter:v "scale=640:-1" -vframes 1 -q:v 2 "$output_video.jpg" 2>&1 | grep -oP "(?<=thumbnail:).*(?=')")

    # Convert audio file to video
    ffmpeg -loop 1 -i "$output_video.jpg" -i "$input_audio" -c:v libx264 -preset fast -tune stillimage -c:a copy -shortest "$output_video"

    # Remove thumbnail image file
    rm "$output_video.jpg"

    zenity --info --text="Video conversion for '${input_audio}' completed successfully!"
done

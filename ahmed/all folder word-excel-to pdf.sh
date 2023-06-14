#!/bin/bash

# Get the input folder path from the first argument 
folder_path="$1"

# Use the selected folder as the output folder if none was specified
output_folder="$folder_path"  

# Check if the folder exists
if [ ! -d "$folder_path" ]; then
    zenity --error --text="$folder_path is not a directory"
    exit 1
fi  

# Convert all the PowerPoint, Word, and Excel documents in the folder to PDF
find "$folder_path" -type f \( -iname "*.ppt*" -o -iname "*.doc*" -o -iname "*.xls*" \) -execdir libreoffice --headless --convert-to pdf --outdir "$output_folder" {} +  

# Show a pop-up message when the conversion is complete
zenity --info --text="Conversion complete!"


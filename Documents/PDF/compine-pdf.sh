#!/bin/bash

# compine files to pdf
IFS=$'\n'
selected_files=($NAUTILUS_SCRIPT_SELECTED_FILE_PATHS)
unset IFS

# if the seleceted file is a directory, then use the files in the directory
if [ -d "${selected_files[0]}" ]; then
    selected_files=("${selected_files[0]}"/*)
fi

# convert to pdf using pdfunite
pdfunite "${selected_files[@]}" "merged.pdf"

# a pop-up message to show the result or show the error message
if [ $? -eq 0 ]; then
    notify-send "Success" "Files are combined successfully"
else
    notify-send "Error" "Files are not combined successfully"
fi


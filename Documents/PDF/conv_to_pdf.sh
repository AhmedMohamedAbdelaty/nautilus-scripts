#!/bin/bash
# Nautilus script to convert all the PowerPoint, Word, and Excel documents in the folder to PDF.
# Place this script in $HOME/.local/share/nautilus/scripts or /usr/share/nautilus/scripts for system-wide use.

IFS="
"
n_files=`echo -n "$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS" | egrep -i "\.(ppt|pps|pptx|ppsx|doc|docx|xls|xlsx)\$"`
output_folder=`echo -n "$n_files" | sed "s/\(.*\)\/.*/\1\/PDFs/"`
mkdir -p "$output_folder"

for file in $n_files; do
    libreoffice --headless --convert-to pdf --outdir "$output_folder" "$file"
done

notify-send "Documents converted successfully" "Output folder: $output_folder" -i document-export

#!/bin/bash

# Language selection
while true; do
    echo "Select the language for OCR:"
    echo "1. English"
    echo "2. Spanish"
    echo "3. Spanish + English"
    read -p "Enter your choice (1, 2, or 3): " lang_choice
    case $lang_choice in
        1)
            lang_option="eng"
            break
            ;;
        2)
            lang_option="spa"
            break
            ;;
        3)
            lang_option="spa+eng"
            break
            ;;
        *)
            echo "Invalid choice. Please enter 1 for English, 2 for Spanish, or 3 for Spanish + English."
            echo
            ;;
    esac
done

while true; do
    echo "Redo/Force OCR?"
    echo "1. yes"
    echo "2. no"
    read -p "Enter your choice (1 or 2): " redo_choice
    case $redo_choice in
        1)
            redo_option="--redo-ocr"
            break
            ;;
        2)
            redo_option=""
            break
            ;;
        *)
            echo "Enter your choice (1 or 2): "
            echo
            ;;
    esac
done

# Check if input directory exists
if [ ! -d "non-ocr" ]; then
    echo "Error: 'non-ocr' directory not found."
    exit 1
fi

# Create the output directory
mkdir -p ocr

# Loop through all PDF files in the non-ocr directory
find "non-ocr" -type f -iname "*.pdf" | while read -r file; do
    # Get the filename without the path
    filename=$(basename "$file")
    
    # Create the output filename
    output_file="ocr/${filename}"
    
    # Construct the ocrmypdf command as an array
    cmd=(ocrmypdf --output-type pdf --optimize 0 --language "$lang_option")
    
    # Add redo option if selected
    if [ -n "$redo_option" ]; then
        cmd+=("$redo_option")
    fi
    
    # Add input and output files
    cmd+=("$file" "$output_file")
    
    # Run ocrmypdf command
    echo "Running: ${cmd[*]}"
    "${cmd[@]}"

    echo "Processed: $filename"
done

echo "All PDFs have been processed."

# Screenshot and OCR Automation Tools

This repository contains two Bash scripts for automating the process of taking screenshots and converting them to searchable PDFs with OCR (Optical Character Recognition).

## Overview

- `auto-ss.sh`: Automates screenshot capturing from applications, supports various navigation methods, and compiles screenshots into a PDF.
- `ocr-all.sh`: Processes non-OCR PDFs to create searchable PDFs with text recognition in multiple languages.

## Requirements

### System Dependencies

- **Linux** with X Window System
- **Bash** shell (version 4.0+)
- **ImageMagick** (`magick` command) for image processing and PDF creation
- **scrot** for screenshot capture
- **xdotool** for keyboard/mouse automation
- **slop** for area selection
- **xrandr** for screen rotation
- **ocrmypdf** for OCR processing
- **Tesseract OCR** (with language packs for English and Spanish)

### Directory Structure

The scripts expect/create the following directory structure:
```
.
├── auto-ss.sh
├── ocr-all.sh
├── screenshots/
│   └── [folder_name]/
│       ├── 1.png
│       ├── 2.png
│       └── ...
├── non-ocr/
│   └── [folder_name].pdf
└── ocr/
    └── [folder_name].pdf
```

## Installation

1. Install required dependencies:

```bash
# For Debian/Ubuntu-based systems
sudo apt-get update
sudo apt-get install imagemagick scrot xdotool slop x11-xserver-utils ocrmypdf tesseract-ocr tesseract-ocr-eng tesseract-ocr-spa
```

2. Make the scripts executable:

```bash
chmod +x auto-ss.sh ocr-all.sh
```

## Usage

### Screenshot Automation (`auto-ss.sh`)

This script automates taking multiple screenshots from an application and combines them into a PDF.

```bash
./auto-ss.sh
```

1. You will be prompted to:
   - Enter a folder name to store the screenshots
   - Specify the number of screenshots to take
   - Choose whether to rotate the screen (useful for portrait-oriented content)

2. Select the area to screenshot:
   - Press Enter when prompted
   - The script will switch to your target window
   - Press F11 if needed to maximize the window
   - Use the mouse to select the screenshot area

3. Choose a navigation method:
   - Right arrow key navigation
   - Single mouse click (select the area to click)
   - Double mouse click (select two areas to click in sequence)

4. The script will:
   - Take the specified number of screenshots
   - Navigate between pages automatically
   - Compile the screenshots into a PDF in the `non-ocr` directory
   - Optionally delete the individual PNG files

### OCR Processing (`ocr-all.sh`)

This script processes PDFs in the `non-ocr` directory to create searchable PDFs with OCR.

```bash
./ocr-all.sh
```

1. You will be prompted to:
   - Select the OCR language (English, Spanish, or both)
   - Choose whether to redo OCR for already processed files

2. The script will:
   - Process all PDFs in the `non-ocr` directory
   - Apply OCR with the selected language
   - Save the resulting searchable PDFs in the `ocr` directory

## Tips for Best Results

1. **For Screenshots**:
   - Ensure consistent lighting and screen clarity
   - Allow sufficient time between screenshots (adjust SLEEP_TIME if needed)
   - For web content, consider using full-screen mode (F11)

2. **For OCR**:
   - Use higher resolution screenshots for better OCR results
   - For multilingual content, select the appropriate language option
   - The OCR process may take time for large documents

## Troubleshooting

- If screenshots aren't capturing correctly, try increasing the sleep times
- If navigation isn't working, ensure the correct window is in focus
- If OCR results are poor, try adjusting the resolution or using the `--redo-ocr` option

## License

These scripts are provided as-is with no warranty. Feel free to modify them for your needs.

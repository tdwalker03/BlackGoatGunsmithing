#!/bin/bash

# Thumbnail Generation Script for Black Goat Gunsmithing Gallery
# This script creates 300x300px thumbnails for faster gallery loading
# Original images are kept for the lightbox viewer

echo "=========================================="
echo "Thumbnail Generation Script"
echo "=========================================="
echo ""

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo "ERROR: ImageMagick 'convert' command is not installed!"
    echo ""
    echo "To install ImageMagick:"
    echo "  Ubuntu/Debian: sudo apt-get install imagemagick"
    echo "  macOS:         brew install imagemagick"
    echo "  Windows:       Download from https://imagemagick.org/script/download.php"
    echo ""
    exit 1
fi

# Set the portfolio directory
PORTFOLIO_DIR="assets/img/portfolio"
THUMB_DIR="$PORTFOLIO_DIR/thumbs"

# Check if portfolio directory exists
if [ ! -d "$PORTFOLIO_DIR" ]; then
    echo "ERROR: Portfolio directory not found at $PORTFOLIO_DIR"
    exit 1
fi

# Create thumbs directory if it doesn't exist
if [ ! -d "$THUMB_DIR" ]; then
    echo "Creating thumbnails directory: $THUMB_DIR"
    mkdir -p "$THUMB_DIR"
    echo ""
fi

echo "Generating 300x300px thumbnails..."
echo "Source: $PORTFOLIO_DIR"
echo "Output: $THUMB_DIR"
echo ""

# Counter for generated thumbnails
count=0

# Process all jpg and JPG files
for file in "$PORTFOLIO_DIR"/*.jpg "$PORTFOLIO_DIR"/*.JPG "$PORTFOLIO_DIR"/*.jpeg "$PORTFOLIO_DIR"/*.JPEG; do
    # Check if file exists
    if [ -f "$file" ]; then
        filename=$(basename "$file")

        # Skip if already in thumbs directory
        if [[ "$file" == *"/thumbs/"* ]]; then
            continue
        fi

        output="$THUMB_DIR/$filename"

        echo "Processing: $filename"

        # Generate thumbnail: resize to 300x300, crop center, optimize quality
        convert "$file" \
            -resize 300x300^ \
            -gravity center \
            -extent 300x300 \
            -quality 85 \
            "$output"

        if [ $? -eq 0 ]; then
            # Get file sizes
            original_size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
            thumb_size=$(stat -f%z "$output" 2>/dev/null || stat -c%s "$output" 2>/dev/null)

            # Calculate size reduction
            if [ ! -z "$original_size" ] && [ ! -z "$thumb_size" ]; then
                original_kb=$(echo "scale=1; $original_size / 1024" | bc)
                thumb_kb=$(echo "scale=1; $thumb_size / 1024" | bc)
                echo "  ✓ Created thumbnail: ${original_kb}KB -> ${thumb_kb}KB"
            else
                echo "  ✓ Created thumbnail"
            fi

            count=$((count + 1))
        else
            echo "  ✗ Failed to create thumbnail for $filename"
        fi
        echo ""
    fi
done

echo "=========================================="
echo "Thumbnail Generation Complete!"
echo "Generated $count thumbnails"
echo "=========================================="
echo ""
echo "Thumbnails saved to: $THUMB_DIR"
echo ""
echo "To use thumbnails in your gallery:"
echo "1. Update image src paths to use thumbs folder"
echo "2. Keep lightbox using full-size images"
echo ""
echo "Example HTML update:"
echo '<div class="gallery-item" data-category="ar cerakote">'
echo '  <img'
echo '    src="assets/img/portfolio/thumbs/1.jpg"'
echo '    data-full="assets/img/portfolio/1.jpg"'
echo '    alt="..."'
echo '    loading="lazy"'
echo '    onclick="openLightbox(this.getAttribute('"'"'data-full'"'"'))"'
echo '  />'
echo '</div>'
echo ""
echo "This loads small thumbnails in the grid but shows full-size in lightbox!"
echo ""

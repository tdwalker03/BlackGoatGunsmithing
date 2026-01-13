#!/bin/bash

# WebP Conversion Script for Black Goat Gunsmithing Gallery
# This script converts all JPG/JPEG images in the portfolio folder to WebP format
# WebP provides 25-35% smaller file sizes with comparable quality

echo "=========================================="
echo "WebP Conversion Script"
echo "=========================================="
echo ""

# Check if cwebp is installed
if ! command -v cwebp &> /dev/null; then
    echo "ERROR: cwebp is not installed!"
    echo ""
    echo "To install cwebp:"
    echo "  Ubuntu/Debian: sudo apt-get install webp"
    echo "  macOS:         brew install webp"
    echo "  Windows:       Download from https://developers.google.com/speed/webp/download"
    echo ""
    exit 1
fi

# Set the portfolio directory
PORTFOLIO_DIR="assets/img/portfolio"

# Check if directory exists
if [ ! -d "$PORTFOLIO_DIR" ]; then
    echo "ERROR: Portfolio directory not found at $PORTFOLIO_DIR"
    exit 1
fi

echo "Converting images in: $PORTFOLIO_DIR"
echo ""

# Counter for converted images
count=0

# Convert all jpg and JPG files
for file in "$PORTFOLIO_DIR"/*.jpg "$PORTFOLIO_DIR"/*.JPG "$PORTFOLIO_DIR"/*.jpeg "$PORTFOLIO_DIR"/*.JPEG; do
    # Check if file exists (in case no files match the pattern)
    if [ -f "$file" ]; then
        # Get the filename without extension
        filename=$(basename "$file")
        name="${filename%.*}"

        # Output file path
        output="$PORTFOLIO_DIR/${name}.webp"

        # Convert to WebP with quality 85 (good balance of size and quality)
        echo "Converting: $filename -> ${name}.webp"
        cwebp -q 85 "$file" -o "$output" > /dev/null 2>&1

        if [ $? -eq 0 ]; then
            # Get file sizes for comparison
            original_size=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
            webp_size=$(stat -f%z "$output" 2>/dev/null || stat -c%s "$output" 2>/dev/null)

            # Calculate size reduction
            reduction=$(echo "scale=1; (($original_size - $webp_size) / $original_size) * 100" | bc 2>/dev/null || echo "?")

            echo "  ✓ Success! Size reduction: ${reduction}%"
            count=$((count + 1))
        else
            echo "  ✗ Failed to convert $filename"
        fi
        echo ""
    fi
done

echo "=========================================="
echo "Conversion Complete!"
echo "Converted $count images to WebP format"
echo "=========================================="
echo ""
echo "Next steps:"
echo "1. Update your HTML to use WebP images with JPG fallbacks"
echo "2. See the example in the script comments below"
echo ""
echo "Example HTML with fallback:"
echo '<picture>'
echo '  <source srcset="assets/img/portfolio/1.webp" type="image/webp">'
echo '  <img src="assets/img/portfolio/1.jpg" alt="..." loading="lazy">'
echo '</picture>'
echo ""

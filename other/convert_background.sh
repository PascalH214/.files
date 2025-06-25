#!/bin/bash

# Usage: ./convert_background.sh 5120 1440 "#FF00FF"

INPUT="background.svg"
WIDTH="$1"
HEIGHT="$2"
NEW_COLOR="$3"

if [ $# -ne 3 ]; then
  echo "Usage: $0 width height new_color"
  echo "Example: $0 5120 1440 \"#FF00FF\""
  exit 1
fi

BASENAME=$(basename "$INPUT" .svg)
OUTPUT_PATH="../hypr/.config"
MODIFIED_SVG="${OUTPUT_PATH}/${BASENAME}.svg"
OUTPUT_PNG="${OUTPUT_PATH}/${BASENAME}.png"

# Ensure output path exists
mkdir -p "$OUTPUT_PATH"

# Copy and modify SVG
cp "$INPUT" "$MODIFIED_SVG"

# Replace black with given color (both hex and keyword)
sed -i "s/#000000/${NEW_COLOR}/g" "$MODIFIED_SVG"
sed -i "s/\bblack\b/${NEW_COLOR}/g" "$MODIFIED_SVG"

# Set width and height attributes in the SVG (metadata only)
sed -i -E "s/width=\"[0-9.]+\"/width=\"${WIDTH}\"/" "$MODIFIED_SVG"
sed -i -E "s/height=\"[0-9.]+\"/height=\"${HEIGHT}\"/" "$MODIFIED_SVG"

# Scale SVG contents visually and convert to PNG (forced resize)
magick -density 300 "$MODIFIED_SVG" -resize "${WIDTH}x${HEIGHT}!" "$OUTPUT_PNG"

echo "✅ Created PNG: $OUTPUT_PNG (scaled to ${WIDTH}x${HEIGHT}, color ${NEW_COLOR})"


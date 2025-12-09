#!/bin/bash

# Directory containing tar files
IMAGE_DIR="$HOME/sample-app/docker-images"

# Loop through all tar files
for tarfile in "$IMAGE_DIR"/*.tar; do
    echo "Found tar file: $tarfile"

    # Prompt user for confirmation
    read -p "Do you want to load this image? (y/n): " choice

    if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
        echo "Loading image from $tarfile..."
        IMAGE_NAME=$(docker load -i "$tarfile" )

        echo "Image $IMAGE_NAME loaded successfully."
    else
        echo "Skipping $tarfile"
    fi
done

echo "All images processed."

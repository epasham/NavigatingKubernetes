#!/bin/bash


# Usage: ./push_images.sh <keyword>
# Example: ./push_images.sh sample-app

# Keyword to filter tags
KEYWORD=$1
if [ -z "$KEYWORD" ]; then
    echo "Usage: $0 <keyword>"
    exit 1
fi

# Get all images matching the keyword in the repo name
IMAGES=$(docker images --format "{{.Repository}}:{{.Tag}}" | grep "$KEYWORD")

if [ -z "$IMAGES" ]; then
    echo "No images found with keyword '$KEYWORD'."
    exit 0
fi

echo "Found the following images with keyword '$KEYWORD':"
echo "$IMAGES"
echo

# Loop through each image and push to registry
for IMAGE in $IMAGES; do
    echo "Processing image: $IMAGE"

    # Prompt user for confirmation
    read -p "Do you want to load and push this image? (y/n): " choice

    if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
        echo "Pushing image to ACR"
        docker push "$IMAGE"

        echo "Image $IMAGE pushed successfully."
    else
        echo "Skipping $tarfile"
    fi
done

echo "All images processed."

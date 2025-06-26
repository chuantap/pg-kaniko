#!/bin/bash

# Build the image locally
docker build -t whatismyip:latest .

# Save the image to a tar file
docker save whatismyip:latest -o whatismyip-image.tar

echo "Image saved as whatismyip-image.tar"
echo "To load the image later, use: docker load -i whatismyip-image.tar" 
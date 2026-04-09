#!/bin/bash

set -e

CONTAINER_NAME="Floppy"

echo "📥 Pulling latest code..."
git pull

echo "🛑 Stopping existing container (if running)..."
sudo docker stop $CONTAINER_NAME 2>/dev/null || true

echo "🧹 Removing old container..."
sudo docker rm $CONTAINER_NAME 2>/dev/null || true

echo "🏗️ Building Docker image (verbose)..."
IMAGE_ID=$(sudo docker build . | tee /dev/tty | tail -n 1 | awk '{print $3}')

echo "🚀 Starting new container..."
sudo docker run -d \
  --name $CONTAINER_NAME \
  --restart unless-stopped \
  $IMAGE_ID

echo "🧽 Cleaning up dangling images..."
sudo docker image prune -f

echo "📜 Showing logs..."
sudo docker logs -f $CONTAINER_NAME

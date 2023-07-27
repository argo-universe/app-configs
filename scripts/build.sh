#!/usr/bin/env bash

set -e

# Check if required variables are set
if [[ -z "$DOCKER_USERNAME" || -z "$DOCKER_PASSWORD" || -z "$IMAGE_NAME" || -z "$IMAGE_TAG" ]]; then
  echo "Error: Required environment variables not set."
  exit 1
fi

# Docker login
docker login -u "$DOCKER_USERNAME" -p "$DOCKER_PASSWORD"

# Build Docker image
DOCKER_IMAGE="$DOCKER_USERNAME/$IMAGE_NAME:$IMAGE_TAG"
docker build -t "$DOCKER_IMAGE" .

# Install Trivy if not already installed
if ! command -v trivy &>/dev/null; then
  TRIVY_LATEST_RELEASE=$(curl -s https://api.github.com/repos/aquasecurity/trivy/releases/latest | grep "browser_download_url.*_Linux-64bit.deb" | cut -d '"' -f 4 | head -n 1)
  curl -L "$TRIVY_LATEST_RELEASE" -o trivy.deb
  sudo dpkg -i trivy.deb
fi

# Scan the Docker image using Trivy
trivy image --exit-code 1 --no-progress "$DOCKER_IMAGE" || true

# Push Docker image
docker push "$DOCKER_IMAGE"
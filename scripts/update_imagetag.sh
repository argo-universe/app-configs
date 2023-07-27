#!/bin/bash

# This script updates the image tag of a frontend app and pushes the changes to Git.
git clone https://${{ secrets.GIT_PAT }}@github.com/argo-universe/app-configs.git

# Change directory to the root of the repository
cd app-configs

# Find the app directory
APP_DIRECTORY=$(find . -type d -name "$APP_NAME")

# Configure git
git config --global user.email "no-reply@argo-universe.com"
git config --global user.name "Mr. GitOps"

# Update the image tag in the values file
sed -i -e "s/imageTag: .*/imageTag: $IMAGE_TAG/g" "apps/$APP_NAME/$ENV/values.yaml"

# Display the updated values file
cat "apps/$APP_NAME/$ENV/values.yaml"

# Add the changes to git
git add .
git commit -m "Mr. GitOps updated $APP_NAME to version $IMAGE_TAG"

# Push the changes to git
git push
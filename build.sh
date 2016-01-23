#!/bin/bash

###################
# Run this script to build a Docker image from the git tree.
###################

#### Configuration ####
IMAGE_NAME="hervenicol/apache"
IMAGE_TAG="2.4"
#### End configuration ####

docker build --force-rm=true -t "$IMAGE_NAME":"$IMAGE_TAG" .


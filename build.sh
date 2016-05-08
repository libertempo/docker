#!/bin/bash
echo "Removing old images"
docker rmi libertempo
echo "Building dockerfile..."

docker build -t "libertempo" .

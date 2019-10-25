#!/bin/bash

GIT_VERSION=$(cat .gitversion.json)

MAJOR=$(echo $GIT_VERSION | jq .Major)
MINOR=$(echo $GIT_VERSION | jq .Minor)
PATCH=$(($(echo $GIT_VERSION | jq .Patch) - 1))

echo "$MAJOR.$MINOR.$PATCH" > .gitversion.txt

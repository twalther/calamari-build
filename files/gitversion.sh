#!/bin/bash

GIT_VERSION=$(git tag | egrep "^[0-9]{1,2}\.[0-9]+\.[0-9]+$" | sort -r | head -1)

echo "$GIT_VERSION" > .gitversion.txt

echo "GIT_VERSION: $GIT_VERSION"
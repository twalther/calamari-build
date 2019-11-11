#!/bin/bash

if ! [ -n "$GIT_VERSION" ]; then
	GIT_VERSION=$(git tag | egrep "^[0-9]{1,2}\.[0-9]+\.[0-9]+$" | sort -V -r | head -1)
fi

echo "$GIT_VERSION" > .gitversion.txt

echo "GIT_VERSION: $GIT_VERSION"
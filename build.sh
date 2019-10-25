#!/bin/bash

if [ -d "Calamari" ]; then
	cd Calamari
	git pull
	cd ..
else
	git clone https://github.com/OctopusDeploy/Calamari.git
fi

docker build \
	-t \
	calamari-build \
	.

docker run \
	--rm \
	--name calamari-build \
	--mount type=bind,source="$(pwd)"/artifacts,target=/artifacts \
	calamari-build

cd artifacts

GIT_VERSION=$(cat .gitversion.txt)

rm .gitversion.txt

tar -cvzf calamari-rhel.6-x64-$GIT_VERSION.tar.gz *

if ! [ -d "../artifacts-history" ]; then
	mkdir ../artifacts-history
fi

cp calamari-rhel.6-x64-$GIT_VERSION.tar.gz ../artifacts-history

echo "Created artifacts/calamari-rhel.6-x64-$GIT_VERSION.tar.gz"
echo "Saved to artifacts-history/calamari-rhel.6-x64-$GIT_VERSION.tar.gz"
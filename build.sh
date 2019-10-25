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

docker rm \
	calamari-build

docker create \
	--name calamari-build \
	calamari-build \
	/bin/bash

rm -rf artifacts

docker cp calamari-build:/artifacts ./

cd artifacts

export GIT_VERSION=$(cat .gitversion.txt)

rm .gitversion.txt

tar -cvzf calamari-rhel.6-x64-$GIT_VERSION.tar.gz *

if ! [ -d "../artifacts-history" ]; then
	mkdir ../artifacts-history
fi

cp calamari-rhel.6-x64-$GIT_VERSION.tar.gz ../artifacts-history

echo "Created artifacts/calamari-rhel.6-x64-$GIT_VERSION.tar.gz"
echo "Copied to artifacts-history/calamari-rhel.6-x64-$GIT_VERSION.tar.gz"
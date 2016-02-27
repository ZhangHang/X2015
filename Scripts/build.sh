#!/bin/sh

DIR=$(cd "$(dirname "$0")"; pwd)
cd $DIR
cd ..

# fetch third-party frameworks
#
# make sure you have cathage installed
# https://github.com/Carthage/Carthage
carthage update --platform iOS

# update submodules
#
# makr sure you have git installed
# https://git-scm.com
git submodule init
git submodule update --recursive
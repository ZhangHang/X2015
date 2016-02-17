#!/bin/sh

DIR=$(cd "$(dirname "$0")"; pwd)
cd $DIR
cd ..
carthage update --platform iOS

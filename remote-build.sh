#!/bin/bash

# check that the script is running from the project dir
if [[ ! -f $PWD/remote-build.sh ]]; then
    echo "No remote-build.sh in current dir."
    exit 1
fi

# check for host in the '.buildhost' file
BUILD_HOST=$(cat .buildhost 2>/dev/null)
if [ -z $BUILD_HOST ]; then
    echo "Host not specified"
    exit 1
fi

# split host into three parts:
# - optional 'rsync://'
# - mandatory host or IP or alias from .ssh/config
# - optional SSH port
IFS=":"
read a b c <<< "$BUILD_HOST"

if [[ -n $c ]]; then
    HOST=${b##*/}
    PORT=$c
elif [[ -n $b ]]; then
    if [[ $b =~ ^[0-9]+$ ]]; then
        PORT=$b
        HOST=$a
    else
        HOST=${b##*/}
    fi
elif [[ -n $a ]]; then
    HOST=$a
else
    echo "Unable to parse host"
    exit 1
fi

if [[ -n $PORT ]]; then
    PORT="-p$PORT"
fi

# save build arguments to '.buildargs' file
ARGS="$@"
if [ -z $ARGS ]; then
    ARGS=$(cat .buildargs 2>/dev/null)
else
    echo "$ARGS" >> .buildargs
fi

PROJECT=${PWD##*/}
BUILD_DIR=build/$PROJECT
BUILD_CMD="./build.sh"

# rsync to the build server and build
rsync -avr --exclude='tags' --exclude='remote-build.sh' . "$BUILD_HOST":"$BUILD_DIR"
ssh $PORT $HOST "cd $BUILD_DIR; $BUILD_CMD $ARGS"

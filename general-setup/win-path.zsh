#!/bin/bash
# set -x
LXSS_PATH="$(/mnt/c/Windows/System32/cmd.exe /C echo %LOCALAPPDATA% | tr -d '\f\n\r')\\lxss"

# Show help
if [[ "$1" == "--help" ]] ; then
    echo "$0 [--help] [absolute or relative path]"
    exit
fi

# Use PWD if no argumen is passed
# Resolve links and canonicalize the path
DIR=$(readlink -f "${1:-$PWD}")

 MOUNT_POINT="$(cd $DIR; df --output=source . | sed '1d' | tr -d '\n\r')"
MOUNT_PREFIX="$(cd $DIR; df --output=target . | sed '1d' | tr -d '\n\r')"

# Strip MOUNT_PREFIX
# Replace / with \
REL_DIR=$(echo "$DIR" | sed "s:^$MOUNT_PREFIX::" | sed s:^[/]:: | tr '/' '\\')

if [[ "$REL_DIR" == "" ]] ; then
    SUFFIX="$MOUNT_POINT"
else
    SUFFIX="$MOUNT_POINT\\$REL_DIR"
fi

if [[ "$MOUNT_POINT" =~ .: ]] ; then
    # If this is drive mount
    echo "$SUFFIX"
else
    echo "$LXSS_PATH\\$SUFFIX"
fi
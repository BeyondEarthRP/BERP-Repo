#!/bin/bash
if [ -z $SOURCE ]; then
    SOURCE=~/REPO
fi

while read -r line <&3; do
    if [ ! -z "$line" ]; then
        nano $line
        echo $line
        echo ""
    fi
done 3< <( find ${SOURCE} -name "config.lua" -type f )

#!/bin/bash
SCRIPT=$(echo $0 | rev | cut -f1 -d/ | rev)
SCRIPT_ROOT=`dirname "$(readlink -f "$0")"`
SCRIPT_FULLPATH=$SCRIPT_ROOT/$SCRIPT

if [ -z $1 ]; then
  echo "1) Go to: "
  echo ""
  echo "    https://github.com/TomGrobbe/vMenu/releases"
  echo ""
  echo "2) Select a release"
  echo "3) type: ./upgrade-fivem %link_to_release%"
  echo ""
else
    tempDir=$SCRIPT_ROOT/tmp
    if [ -d $tempDir ]; then
        rm -rf $tempDir
    fi
    mkdir $tempDir
    cd $tempDir
    wget $1
    zipFile=$(echo $1 | rev | cut -f1 -d/ | rev)
    if [ -f $tempDir/$zipFile ]; then
        build=$(echo $1 | rev | cut -f2 -d/ | rev)
        echo $build > $SCRIPT_ROOT/__VER__
        mv -f $tempDir/$zipFile $SCRIPT_ROOT/vMenu-$build.zip
    fi
    cd ~
    rm -rf $tempDir
fi

#example
#https://github.com/TomGrobbe/vMenu/releases/download/v3.1.3/vMenu-v3.1.3.zip


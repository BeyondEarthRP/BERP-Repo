#!/bin/bash
SCRIPT_ROOT=`dirname "$(readlink -f "$0")"`

cat $SCRIPT_ROOT/__VER__

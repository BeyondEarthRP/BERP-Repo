#!/bin/sh
grep --include=config.lua -rnw '/home/fivem/ESX/' -e "Config.Locale"
echo 
echo 
echo 
echo "|||||||||||||||||||||||||||||||||||"
echo "files with en_ or en- ::"
find . -name en_\*
find . -name en-\*



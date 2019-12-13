#!/bin/sh
LOGO="SplatEarth.png"

Pass=`date +%s | sha256sum | base64 | head -c 64 ; echo`
DateStamp=`date +"@%B#%Y"`

sed "s/#rcon_password CHANGE_ME/rcon_password \"${Pass}${DateStamp}\"/" /home/fivem/REPO/server.cfg > /opt/FXServer/server-data/server.cfg
#cp -rfup /home/fivem/REPO/server.cfg /opt/FXServer/server-data/server.cfg
cp -rfup /home/fivem/REPO/__\[LOGOS\]__/$LOGO /opt/FXServer/server-data/BERP-Logo.png
mkdir /opt/FXServer/server-data/resources/[esx]
mkdir /opt/FXServer/server-data/resources/[esx]/[ui]
mkdir /opt/FXServer/server-data/resources/[essential]

/home/fivem/REPO/__rebuild.sh

#!/bin/sh
LOGO="SplatEarth.png"

Pass=`date +%s | sha256sum | base64 | head -c 64 ; echo`
DateStamp=`date +"@%B#%Y"`

##########--LOADING SCREEN--#############################
#cp -rfup /home/fivem/REPO/__\[LOADING-SCREENS\]__/loqscript-material_load-loadingscreen /opt/FXServer/server-data/resources/
#cp -rfup /home/fivem/REPO/__\[LOADING-SCREENS\]__/fivem-gta-loading /opt/FXServer/server-data/resources/
cp -rfup /home/fivem/REPO/__\[LOADING-SCREENS\]__/cyberload /opt/FXServer/server-data/resources/
#########################################################

sed "s/#rcon_password CHANGE_ME/rcon_password \"${Pass}${DateStamp}\"/" /home/fivem/REPO/server.cfg > /opt/FXServer/server-data/server.cfg
#cp -rfup /home/fivem/REPO/server.cfg /opt/FXServer/server-data/server.cfg
cp -rfup /home/fivem/REPO/__\[LOGOS\]__/$LOGO /opt/FXServer/server-data/BERP-Logo.png
cp -rfup /home/fivem/REPO/fivem-resource-base/* /opt/FXServer/server-data/resources/
cp -rfup /home/fivem/REPO/es_ui /opt/FXServer/server-data/resources/
cp -rfup /home/fivem/REPO/essentialmode /opt/FXServer/server-data/resources/
cp -rfup /home/fivem/REPO/mysql-async /opt/FXServer/server-data/resources/
cp -rfup /home/fivem/REPO/esplugin_mysql /opt/FXServer/server-data/resources/
cp -rfup /home/fivem/REPO/async /opt/FXServer/server-data/resources/
mkdir /opt/FXServer/server-data/resources/[esx]
mkdir /opt/FXServer/server-data/resources/[esx]/[ui]
mkdir /opt/FXServer/server-data/resources/[essential]
cp -rfup /home/fivem/REPO/[esx]/[ui]/esx_menu_default /opt/FXServer/server-data/resources/[esx]/[ui]/
cp -rfup /home/fivem/REPO/[esx]/[ui]/esx_menu_dialog /opt/FXServer/server-data/resources/[esx]/[ui]/
cp -rfup /home/fivem/REPO/[esx]/[ui]/esx_menu_list /opt/FXServer/server-data/resources/[esx]/[ui]/
cp -rfup /home/fivem/REPO/[essential]/es_extended /opt/FXServer/server-data/resources/[essential]/
cp -rfup /home/fivem/REPO/cron /opt/FXServer/server-data/resources/
cp -rfup /home/fivem/REPO/es_admin2 /opt/FXServer/server-data/resources/
cp -rfup /home/fivem/REPO/skinchanger /opt/FXServer/server-data/resources/
cp -rfup /home/fivem/REPO/GcPhoneForESX/resources/* /opt/FXServer/server-data/resources/
cp -rfup /home/fivem/REPO/bob74_ipl /opt/FXServer/server-data/resources/
cp -rfup /home/fivem/REPO/instance /opt/FXServer/server-data/resources/[esx]/
cp -rfup /home/fivem/REPO/[plugins] /opt/FXServer/server-data/resources/
cp -rfup /home/fivem/REPO/FiveM-RealisticVehicles/[vehicles] /opt/FXServer/server-data/resources/
cp -rfup /home/fivem/REPO/Calm-AI /opt/FXServer/server-data/resources/
cp -rfup /home/fivem/REPO/Hot-Female-Ped-Pack/ped_pack /opt/FXServer/server-data/resources/
cp -rfup /home/fivem/REPO/[esx]/esx_basicneeds /opt/FXServer/server-data/resources/[esx]/
cp -rfup /home/fivem/REPO/[esx]/esx_status /opt/FXServer/server-data/resources/[esx]/
cp -rfup /home/fivem/REPO/[esx]/esx_society /opt/FXServer/server-data/resources/[esx]/
cp -rfup /home/fivem/REPO/[esx]/esx_shops /opt/FXServer/server-data/resources/[esx]/
cp -rfup /home/fivem/REPO/[esx]/esx_addonaccount /opt/FXServer/server-data/resources/[esx]/
cp -rfup /home/fivem/REPO/[esx]/esx_billing /opt/FXServer/server-data/resources/[esx]/
cp -rfup /home/fivem/REPO/[esx]/esx_voice /opt/FXServer/server-data/resources/
cp -rfup /home/fivem/REPO/[esx]/esx_animations /opt/FXServer/server-data/resources/[esx]/
cp -rfup /home/fivem/REPO/[esx]/esx_policejob /opt/FXServer/server-data/resources/[esx]/
cp -rfup /home/fivem/REPO/[esx]/esx_datastore /opt/FXServer/server-data/resources/[esx]/
cp -rfup /home/fivem/REPO/[esx]/esx_license /opt/FXServer/server-data/resources/[esx]/
cp -rfup /home/fivem/REPO/[esx]/esx_identity /opt/FXServer/server-data/resources/[esx]/
cp -rfup /home/fivem/REPO/[esx]/esx_skin /opt/FXServer/server-data/resources/[esx]/
cp -rfup /home/fivem/REPO/[esx]/esx_addoninventory /opt/FXServer/server-data/resources/[esx]/
cp -rfup /home/fivem/REPO/[esx]/esx_ambulancejob  /opt/FXServer/server-data/resources/[esx]/
cp -rfup /home/fivem/REPO/[esx]/esx_mechanicjob  /opt/FXServer/server-data/resources/[esx]/
cp -rfup /home/fivem/REPO/[esx]/esx_taxijob  /opt/FXServer/server-data/resources/[esx]/
cp -rfup /home/fivem/REPO/[esx]/esx_vehicleshop  /opt/FXServer/server-data/resources/[esx]/
cp -rfup /home/fivem/REPO/[esx]/esx_aiomenu  /opt/FXServer/server-data/resources/[esx]/
cp -rfup /home/fivem/REPO/[esx]/esx_locksystem  /opt/FXServer/server-data/resources/[esx]/
cp -rfup /home/fivem/REPO/[esx]/esx_jobs  /opt/FXServer/server-data/resources/[esx]/
cp -rfup /home/fivem/REPO/[esx]/esx_joblisting  /opt/FXServer/server-data/resources/[esx]/
cp -rfup /home/fivem/REPO/[esx]/esx_accessories  /opt/FXServer/server-data/resources/[esx]/
cp -rfup /home/fivem/REPO/[esx]/esx_property /opt/FXServer/server-data/resources/[esx]/
cp -rfup /home/fivem/REPO/[esx]/esx_clotheshop /opt/FXServer/server-data/resources/[esx]/
cp -rfup /home/fivem/REPO/[esx]/esx_advancedgarage /opt/FXServer/server-data/resources/[esx]/
cp -rfup /home/fivem/REPO/[esx]/esx_holdup /opt/FXServer/server-data/resources/[esx]/
cp -rfup /home/fivem/REPO/[esx]/esx_drugs /opt/FXServer/server-data/resources/[esx]/
cp -rfup /home/fivem/REPO/[esx]/esx_atm /opt/FXServer/server-data/resources/[esx]/
cp -rfup /home/fivem/REPO/[esx]/esx_service /opt/FXServer/server-data/resources/[esx]/


#!/bin/bash
if [ -z "$__RUNTIME__" ] ;
then
	if [ -z "$BUILD" ] ;
	then
	  THIS_SCRIPT_ROOT=$(dirname $(readlink -f "$0")) ;
	  BUILDCHECK=()
	  BUILDCHECK+=( $(readlink -f "${THIS_SCRIPT_ROOT:?}/../../build") ) || true
	  BUILDCHECK+=( $(readlink -f "${THIS_SCRIPT_ROOT:?}/../build") )    || true
	  BUILDCHECK+=( $(readlink -f "${THIS_SCRIPT_ROOT:?}/build") )       || true
	  BUILDCHECK+=( $(readlink -f "${THIS_SCRIPT_ROOT:?}") )             || true
	  unset THIS_SCRIPT_ROOT ;
	  for cf in "${BUILDCHECK[@]}" ;
	  do
	    if [ -d "${cf:?}" ] && [ -f "${cf:?}/build-env.sh" ] ;
	    then
	        BUILD="${cf:?}"
	    fi
	  done
	fi
	[[ -z "$BUILD" ]] && echo "Build folder undefined. Failed." && exit 1
	#-----------------------------------------------------------------------------------------------------------------------------------
	if [ -z "$APPMAIN" ] ;
	then
	  APPMAIN="SERVER_CONFIG"
	  . "$BUILD/just-a-banner.sh" BELCHER
	  . "$BUILD/build-env.sh" EXECUTE
	elif [ -z "$__RUNTIME__" ] ;
	then
	        echo "Runtime not loaded... I'VE FAILED!"
	        exit 1
	fi
	[[ -z "${SOURCE:?}" ]] &&  echo "Source undefined... " && exit 1
	. "$BUILD/build-env.sh" RUNTIME
	[[ -n "$__INVALID_CONFIG__" ]] && echo "You'll need to run the quick configure before this will work..." && exit 1
fi
####################################################################################################################################
####################################################################################################################################
[[ -z "${SOURCE:?}" ]] && echo "Source location is undefined. Failed." && exit 1
####################################################################################################################################
####################################################################################################################################
#----------------------------------------------------------------------------------------------------------------------------------
# YOU PROBABLY SHOULD NOT CHANGE ANY OF THIS--- IF YOU DO... GOOD LUCK! IT IS ALL UP TO YOU NOW... YOU CAN DO IT, I BELIEVE IN YOU.
#----------------------------------------------------------------------------------------------------------------------------------

directory_to_store_built_cfg_files="configs"   	# you could probably change this without issues
belch_co2="${SOURCE:?}/belch.co2"		# this too, right side of the `/` only though (i say probably, but it is not tested).

[[ ! -f "${belch_co2}" ]] && echo "Belch requires co2 file to operate.."  && exit 1

# but this stuff.... not so sure.
BUILTS="${directory_to_store_built_cfg_files:?}"

SERVER_CONFIGURATION_FILE="server.cfg"
SERVER_HEADER_CONFIGURATION_FILENAME="belch.header"
SERVER_AUTOBUILT_CONFIGURATION_FILENAME="belch.config"
SERVER_IP_PORTBIND_CONFIGURATION_FILENAME="belch.ipbind"
SERVER_FOOTER_CONFIGURATION_FILENAME="belch.footer"

# BELCH CONFIGURATION FILE = belch.configtype

SERVER_CONFIG="${SOURCE:?}/${SERVER_CONFIGURATION_FILE:?}"
       HEADER="${SOURCE:?}/${SERVER_HEADER_CONFIGURATION_FILENAME:?}"
       ABUILT="${SERVER_AUTOBUILT_CONFIGURATION_FILENAME:?}"
       IPBIND="${SOURCE:?}/${SERVER_IP_PORTBIND_CONFIGURATION_FILENAME:?}"
       FOOTER="${SOURCE:?}/${SERVER_FOOTER_CONFIGURATION_FILENAME:?}"
####################################################################################################################################
precheck_and_tidy() {
# PRE-CLEANING FOR THE REBUILD
	if [ "$APPMAIN" != "SERVER_CONFIG" ] ;
	then
		[[ -f "$SERVER_CONFIG" ]] && rm -f "${SERVER_CONFIG:?}" 2>/dev/null
                [[ -f "$SOURCE/$ABUILT" ]] && rm -f "${SOURCE:?}/${ABUILT:?}" 2>/dev/null
		[[ -d "${SOURCE:?}/${BUILTS:?}" ]] && rm -rf "${SOURCE:?}/${BUILTS:?}" 2>/dev/null
	fi
	while [ -f "${SERVER_CONFIG:?}" ] || [ -f "${SOURCE:?}/${ABUILT:?}" ] ;
	do
		[[ -n "$CONFIG_TIMESTAMP" ]] && echo -e "\\n\\e[91mYou have a current server.cfg built on ${CONFIG_TIMESTAMP:?}.\\e[0m"
		[[ -z "$CONFIG_TIMESTAMP" ]] && echo -e "\\n\\e[91mYou have a current server.cfg built.\\e[0m"
		color lightYellow - bold
		echo -e -n "\\nThese files are pretty much ephemeral anyway, since they very easy to rebuild."
		echo -e -n "\\nYour database may be a different story though.  So be careful here."
		echo -e -n "\\nOnce we begin, we will import the SQL Dumps and move the resource files (overwritting)\n"
		color - - clearAll

		color white - bold
		echo -e "\\n\\tWill dispose of:"
		[[ -f "$SERVER_CONFIG" ]] && echo -e "\\t  $SERVER_CONFIG"
		[[ -f "$SOURCE/$ABUILT" ]] && echo -e "\\t  $SOURCE/$ABUILT"
		[[ -d "${SOURCE:?}/${BUILTS:?}" ]] && echo -e "\\t  $SOURCE/$BUILTS (DIRECTORY)"
		echo ""
		color - - clearAll

		PROMPT="Would you like to rebuild the server.cfg and associated build scripts?"
		pluck_fig "__CLEANUP__" 10
		if [ "$__CLEANUP__" == "true" ]
		then
			[[ -f "$SERVER_CONFIG" ]] && rm -f "${SERVER_CONFIG:?}" 2>/dev/null
			[[ -f "$SOURCE/$ABUILT" ]] && rm -f "${SOURCE:?}/${ABUILT:?}" 2>/dev/null
			[[ -d "${SOURCE:?}/${BUILTS:?}" ]] && rm -rf "${SOURCE:?}/${BUILTS:?}" 2>/dev/null

		        if [ ! -f "$SERVER_CONFIG" ] && [ ! -f "$SOURCE/$ABUILT" ]
		        then
		                color green - bold
		                echo -e "\\nPrevious build attempt has been removed...\\n"
		                color - - clearAll
		        else
		                color red - bold
		                echo -e "\\nClean-up attempt has failed.\\n"
		                color - - clearAll
		        fi
		else
			echo -e "\\nPrevious built scripts must be removed before we can continue.  Exiting.\\n"
			exit 1
		fi
	done
}

write_config() {
	_today="$(date '+%d/%m/%Y %H:%M:%S')"
        if [ -n "${_today:?}" ] ;
        then
		unset _revision
		can_config _contents
		_revision=$(echo "${_contents:?}" | jq --arg today "${_today:?}" '.sys.config.timestamp=$today')
	else
		echo "\\e[91m\\e[1mfailed while updating config timestamp.  exiting.\\e[0m"
		exit 1
	fi
	[[ -n "$_revision" ]] && commit "_revision"
	CONFIG_TIMESTAMP="${_today:?}"

	echo -e "#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#"  > "${SERVER_CONFIG:?}.wip"
	echo -e "#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#" >> "${SERVER_CONFIG:?}.wip"
	echo -e "#> B.E.R.P Belcher FiveM+ESX Configuration Generator           " >> "${SERVER_CONFIG:?}.wip"
	echo -e "#> Created by: Beyond Earth Roleplay (BERP)                    " >> "${SERVER_CONFIG:?}.wip"
	echo -e "#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#" >> "${SERVER_CONFIG:?}.wip"
	echo -e "#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#" >> "${SERVER_CONFIG:?}.wip"
	echo -e "#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#" >> "${SERVER_CONFIG:?}.wip"
	echo -e "#> SERVER NAME: ${SERVER_NAME:?}                               " >> "${SERVER_CONFIG:?}.wip"
	echo -e "#>  BUILD DATE: ${CONFIG_TIMESTAMP:?}                          " >> "${SERVER_CONFIG:?}.wip"
	echo -e "#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~#" >> "${SERVER_CONFIG:?}.wip"
	echo -e "#@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@#\\n" >> "${SERVER_CONFIG:?}.wip"

	local _feed ; _feed=0
	while read -r line <&3
	do
		[[ -n "$line" ]] && echo "$line" 				  >> "${SERVER_CONFIG:?}.wip"
		(( _feed ++ ))
	done 3< <( cat "${HEADER:?}" )

        [[ "${_feed:?}" -gt 0 ]] && echo -e -n "\\n"				  >> "${SERVER_CONFIG:?}.wip"   # CHECK CONTENT WAS WRITTEN, IF SO- NEWLINE
	unset _feed ;

	local _feed ; _feed=0
	while read -r line <&3
	do
		[[ -n "$line" ]] && echo "$line" 				  >> "${SERVER_CONFIG:?}.wip"
		(( _feed ++ ))
	done 3< <( cat "${IPBIND:?}" )

        [[ "${_feed:?}" -gt 0 ]] && echo -e -n "\\n"				  >> "${SERVER_CONFIG:?}.wip"   # CHECK CONTENT WAS WRITTEN, IF SO- NEWLINE
	unset _feed ;

	local _feed ; _feed=0
	while read -r line <&3
	do
		[[ -n "$line" ]] && echo "$line" 				  >> "${SERVER_CONFIG:?}.wip"
		(( _feed ++ ))
	done 3< <( cat "${SOURCE:?}/${ABUILT:?}" )

        [[ "${_feed:?}" -gt 0 ]] && echo -e -n "\\n"				  >> "${SERVER_CONFIG:?}.wip"   # CHECK CONTENT WAS WRITTEN, IF SO- NEWLINE
	unset _feed ;

	if [ "${#_FIGZ[@]}" -gt 0 ] ;
	then
		echo -e "##############################################################" >> "${SERVER_CONFIG:?}.wip"
		echo -e "# EXTERNAL CONFIGURATION FILES                                " >> "${SERVER_CONFIG:?}.wip"
		echo -e "##############################################################" >> "${SERVER_CONFIG:?}.wip"
		local _feed ; _feed=0
		for serverCfg in "${_FIGZ[@]}"
		do
			echo "exec $serverCfg" >> "${SERVER_CONFIG:?}.wip"
			(( _feed ++ ))
		done
		[[ "${_feed:?}" -gt 0 ]] && echo -e -n "\\n"				  >> "${SERVER_CONFIG:?}.wip"   # CHECK CONTENT WAS WRITTEN, IF SO- NEWLINE
		unset _feed ;
	fi

	while read -r line <&3
	do
		[[ -n "$line" ]]  && echo "$line" 					>> "${SERVER_CONFIG:?}.wip"
	done 3< <( cat "${FOOTER:?}" )
	echo -e "\\n${CFGTAG:?}"							>> "${SERVER_CONFIG:?}.wip"

	STAGED_CONFIG="$(cat ${SERVER_CONFIG:?}.wip)"

	PROMPT="Would you like to review the server.cfg before saving?"
	pluck_fig "__REVIEW__" 10 false
	if [ "$__REVIEW__" == "true" ] ;
	then
		unset __CONTINUE__
		while [ -z "$__CONTINUE__" ];
		do
			cat "${SERVER_CONFIG:?}.wip" | less
			PROMPT="Ready to continue?"
			pluck_fig "__CONTINUE__" 11 false
			[[ "$__CONTINUE__" != "true" ]] && unset __CONTINUE__
		done
	fi

	if [ -n "${__FAILED__}" ] || [ -z "${STAGED_CONFIG}" ] ;
	then
	  echo "Failed while pushing belch configuration..."
	  exit 1
	else
		mv -f "${SERVER_CONFIG:?}.wip" "${SERVER_CONFIG:?}"
	fi
}

check_for_mysql

if [ -z "$DB_ROOT_PASSWORD" ]
then
	echo -e "\\nIF YOU SEE THIS, SOMETHING IS NOT RIGHT...\\n"
	echo "Enter password for MySQL:"
	read -r DB_ROOT_PASSWORD
fi

precheck_and_tidy

cd "${SOURCE:?}" || exit 1   # ACCESS SOURCE OR DIE TRYING
[[ ! -d "$fBUILTS" ]] && mkdir "${SOURCE:?}/${BUILTS:?}" 2>/dev/null
[[ ! -f "$HEADER" ]] && touch "${HEADER:?}" 2>/dev/null
[[ ! -f "$IPBIND" ]] && touch "${IPBIND:?}" 2>/dev/null
[[ ! -f "$FOOTER" ]] && touch "${FOOTER:?}" 2>/dev/null

# SOME MORE VARIABLE DEFINITIONS
CFGTAG="####>>>> GENERATED BY: B.E.R.P Belcher FiveM Config & DB Generator (A Beyond Earth Creation)"

declare -a _FIGZ
OUT_CFG="${SOURCE:?}/${ABUILT:?}"
needTag=0

while read -r line <&3
do
	if [ -n "$line" ] ;
	then
		CONF_TYPE=$(echo "$line" | cut -f1 -d:)             # OBTAIN OR DIE
		DATA=$(echo "$line" | rev | cut -f1 -d: | rev)      # OBTAIN OR DIE

		if [ "${CONF_TYPE:?}" == "CONFIG" ]                 # DEATH  (OR IN 2 LINES- DEATH)
		then
			echo "${DATA:?}"									>> "${OUT_CFG:?}"

			echo -e "\\e[0m\\e[2K\\t\\x1B[92mADDED \\x1B[0m\\e[97m\\xe2\\x86\\x92 $DATA\\e[0m"

			[[ "$OUT_CFG" != $(echo "$SOURCE/$ABUILT") ]] && needTag=1

        	elif [ "${CONF_TYPE:?}" == "MYSQL" ] ;
		then
			FILE="${DATA/<RESOURCES>/${SOURCE:?}}"

			#nano $FILE   #<- to edit the files first

			echo -e -n "\\e[0m\\e[2K\\t\\x1B[93mIMPORTING: \\x1B[4m$FILE\\x1B[0m\\n"

			printf "\\x1B[97m\\x1B[44m\\x1B[K\\r"
			mysql -u root -p"$DB_ROOT_PASSWORD" essentialmode < "${FILE:?}"
			if [ "$?" == "1" ] ;
			then
				printf "\\n\\n\\x1B[0m\\x1B[91m\\e[4A\\e[2K\\r\\tIMPORT FAILED \\x1B[0m\\e[97m\\xe2\\x86\\x92 \\x1B[4m$FILE\\e[0m\\e[3B"
				printf "\\n\\n\\x1B[93m\\x1B[1m\\x1B[41m\\xE2\\x86\\x91 \\xE2\\x86\\x91 \\xE2\\x86\\x91 \\xE2\\x86\\x91 ERROR REPORTED BY MYSQL WHILE ATTEMPTING TO IMPORT '$(echo $FILE | rev | cut -f1 -d/ | rev)'.\\x1B[K\\x1B[0m\\n"
			else
				printf "\\n\\n\\x1B[0m\\x1B[92m\\e[3A\\e[2K\\r\\tSUCCESSFULLY IMPORTED \\x1B[0m\\e[97m\\xe2\\x86\\x92 \\x1B[4m$FILE\\e[0m\\n"
			fi


	        elif [ "${CONF_TYPE:?}" == "HEADER" ] ;
		then # MAIN HEADER / TITLE

			# EXAMPLE:
			# HEADER:HEADER INFORMATION%FILENAME

			if [ "$needTag" != 0 ] ;
			then
		                # CLOSING OUT PREVIOUS CONFIG
        	        	echo -e "\\n${CFGTAG:?}" 							>> "${OUT_CFG:?}"
			else
        	        	if [ "${OUT_CFG:?}" != "${SOURCE:?}/${ABUILT:?}" ]
				then
					color red - bold
					echo "deleting empty file: ${OUT_CFG:?}"
					rm -f "${OUT_CFG:?}"
					color - - clearAll
		                fi
			fi

			# STARTING A NEW CONFIG
			HEADER_INFO=$( echo "$DATA" | cut -f1 -d% )
			HEADER_FILE=$( echo "$DATA" | rev | cut -f1 -d% | rev )
			OUT_CFG="${SOURCE:?}/${BUILTS:?}/${HEADER_FILE:?}.cfg"
			EXEC_CFG="${BUILTS:?}/${HEADER_FILE:?}.cfg"
			needTag=0

			touch "${OUT_CFG:?}"
			_FIGZ+=( "${EXEC_CFG:?}" )

			color yellow - bold
			echo -e -n "\\e[0m\\e[2K\\n\\e[0m\\e[2K\\t#########################################################################\\n\\t"
			color yellow darkGray bold
			echo -e    "\\e[0m\\e[2K# $HEADER_INFO \\xe2\\x86\\x92 ${OUT_CFG:?}\\e[0m"
			color yellow - bold
			echo -e    "\\e[0m\\e[2K\\t#########################################################################"
			color - - clearAll

			echo -e "#######################################" 					 > "${OUT_CFG:?}" # STARTS A NEW CONFIG
			echo -e "# $HEADER_INFO" 									>> "${OUT_CFG:?}"
			echo -e "#######################################" 						>> "${OUT_CFG:?}"
	        elif [ "${CONF_TYPE:?}" == "######" ]
		then #SUBHEADER

			# EXAMPLE:
			# SUBHEADER:PUT YOUR HEADER HERE

			color cyan - bold
			echo -e "\\e[0m\\e[2K\\n\\e[0m\\e[2K\\t#||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
			echo -e    "\\e[0m\\e[2K\\t#|> $DATA \\xe2\\x86\\x92 ${OUT_CFG:?}"
			echo -e    "\\e[0m\\e[2K\\t#||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||"
			color - - clearAll

			echo -e "\\n\\n#||||||||||||||||||||||||||||||||||||||" 					>> "${OUT_CFG:?}"
			echo "#|> $DATA" 									>> "${OUT_CFG:?}"
			echo "#||||||||||||||||||||||||||||||||||||||" 						>> "${OUT_CFG:?}"
		fi
       	fi
done 3< <(cat "${belch_co2:?}")

if [ "$needTag" -ne 0 ] ;
then
    # CLOSING OUT PREVIOUS CONFIG
    echo -e "\\n$CFGTAG" 											>> "${OUT_CFG:?}"
else
	if [ "$OUT_CFG" != $(echo "$SOURCE/$ABUILT") ] ;
	then
		rm -f "${OUT_CFG:?}"
	fi
fi

write_config

if [ "$APPMAIN" == "SERVER_CONFIG" ] ;
then
	PROMPT="Did you want to personalize and redeploy the server.cfg now?"
	pluck_fig "__PERSONALIZE__" 10

	. "$BUILD/build-config.sh" DEPLOY
	[[ "$__PERSONALIZE__" == "true" ]] && personalize
fi

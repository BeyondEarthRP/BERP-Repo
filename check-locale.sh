#!/bin/bash
fnd="0"
skp="0"
see="0"
echo ""
en="english"
fr="french"
while read line;
do
	line=${line%$'\r'}
	let fnd++
	export fnd
	file="$(echo $line | cut -f1 -d= | cut -f1 -d:)"
	lang="$(echo $line | rev | cut -f1 -d= | rev | cut -c3-4)"
	if [ ! -z $1 ];
	then
		if [ "$lang" != "$1" ];
		then
			echo -n "[$lang]"
			echo -n " "
			echo $file
			let see++
			export see
		else
			let skp++
			export skp
		fi
	else
	        echo -n "[$lang]"
		echo -n " "
		echo $file
		let see++
		export see
	fi
done < <(grep --include=config.lua -rnw '.' -e "Config.Locale")
if [ "$see" != "0" ]; then
	echo ""
fi
echo "found: $fnd"
echo "shown: $see"
echo "skipped: $skp"

if [ "$see" == "0" ] && [ "$fnd" == "$skp" ] && [ "$fnd" != "0" ];
then
	echo ""
	if [ ! -z ${!1} ]; then
		echo "all configs are in ${!1}."
	else
		echo "all configs are in [$1]"
	fi
elif [ "$see" == "0" ] && [ "$fnd" == "0" ];
then
   echo "something went wrong.  found $found entries"
fi
echo ""



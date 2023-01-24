#!/usr/bin/env bash
#
# Author	: KrazyNez
# Date		: Jan 24, 2023
# Version	: 0.05
#
#
# PRO/ME Example: ms0:/seplugins/brightness/brightness.prx 1
# ARK-4  Example: pops, ms0:/seplugins/cdda_enabler.prx, 1
#

read -p $'\n\n!!! READ THIS !!!\n\nI am not responsible if you destroy your plugins files, nor will I be able to fix them.\n\nThis is very much so Alpha software and treat it as so.\n\nIt does support converting POPS, GAME and VSH (.txt) files. \n\nPress enter to continue...'

/usr/bin/lsblk

read -p $'\n\nPlease select your PSP/Memory stick drive location ( i.e /mnt/PSP ): ' location

read -p "Is '$location' correct? y/n: " userInput

if [[ ! $userInput =~ ^(y|Y)$ ]]; then
	printf "\nGood Bye!!!\n\n"
	exit 0;
fi

SEPLUGINS_LOC="$location/seplugins"

if [ ! -d $SEPLUGINS_LOC ]; then
	printf "\nERR: Hmmmmm can't seem to find the seplugins folder on the root of your PSP\n\nBailing out!\n\n"
	exit 1;
fi


# Globals
GAME_TXT_EXISIT="false"
POPS_TXT_EXISIT="false"
VSH_TXT_EXISIT="false"
GAME_TXT=''
POPS_TXT=''
VSH_TXT=''

pushd $SEPLUGINS_LOC >/dev/null

for i in $SEPLUGINS_LOC/*; do
	j=$(basename $i)
	if [ ${j,,} == "game.txt" ]; then
		GAME_TXT="$j"
		GAME_TXT_EXISIT="true"
	fi
	if [ ${j,,} == "pops.txt" ]; then
		POPS_TXT="$j"
		POPS_TXT_EXISIT="true"
	fi
	if [ ${j,,} == "vsh.txt" ]; then
		VSH_TXT="$j"
		VSH_TXT_EXISIT="true"
	fi
	if [ ${j,,} == "plugins.txt" ]; then
		printf "\nLooks like there already is a plugins.txt. Located : $SEPLUGINS_LOC\n\n"
		read -p "Would you like to override it? y/n: " override_it
	
		if [[ $override_it =~ ^(n|N)$ ]]; then
			printf "\n\nSorry I can't go any further. Good Bye...\n\n"
			exit 0;
		else
			rm $SEPLUGINS_LOC/${j,,}
		fi
	fi


done

# PRO/ME Example: ms0:/seplugins/brightness/brightness.prx 1
# ARK-4  Example: pops, ms0:/seplugins/cdda_enabler.prx, 1

if [[ $GAME_TXT_EXISIT == "true" && `awk '{print $1}' game.txt | head -n 1` != "game," ]]; then
	if [ `awk -F: '{print $1}' $SEPLUGINS_LOC/$GAME_TXT` == "ef0" ]; then
		sed -e "s/prx /prx, /g" -e "s/ef0/game, ef0/g" $SEPLUGINS_LOC/$GAME_TXT >> $SEPLUGINS_LOC/plugins.txt
	else
		sed -e "s/prx /prx, /g" -e "s/ms0/game, ms0/g" $SEPLUGINS_LOC/$GAME_TXT >> $SEPLUGINS_LOC/plugins.txt
	fi
fi

if [[ $POPS_TXT_EXISIT == "true" && `awk '{print $1}' pops.txt | head -n 1` != "pops," ]]; then
	if [ `awk -F: '{print $1}' $SEPLUGINS_LOC/$POPS_TXT` == "ef0" ]; then
		sed -e "s/prx /prx, /g" -e "s/ef0/pops, ef0/g" $SEPLUGINS_LOC/$POPS_TXT >> $SEPLUGINS_LOC/plugins.txt
	else
		sed -e "s/prx /prx, /g" -e "s/ms0/pops, ms0/g" $SEPLUGINS_LOC/$POPS_TXT >> $SEPLUGINS_LOC/plugins.txt
	fi
fi

if [[ $VSH_TXT_EXISIT == "true" && `awk '{print $1}' vsh.txt | head -n 1` != "vsh," ]]; then
	if [ `awk -F: '{print $1}' $SEPLUGINS_LOC/$VSH_TXT` == "ef0" ]; then
		sed -e "s/prx /prx, /g" -e "s/ef0/vsh, ef0/g" $SEPLUGINS_LOC/$VSH_TXT >> $SEPLUGINS_LOC/plugins.txt
	else
		sed -e "s/prx /prx, /g" -e "s/ms0/vsh, ms0/g" $SEPLUGINS_LOC/$VSH_TXT >> $SEPLUGINS_LOC/plugins.txt
	fi
fi

printf "\nConvertion Complete.\n\nplugins.txt located: $SEPLUGINS_LOC/plugins.txt\n\n"

popd >/dev/null

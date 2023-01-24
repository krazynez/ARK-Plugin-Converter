#!/usr/bin/env bash
#
# Author	: KrazyNez
# Date		: Jan 24, 2023
# Version	: 0.01
#
#
# PRO/ME Example: ms0:/seplugins/brightness/brightness.prx 1
# ARK-4  Example: pops, ms0:/seplugins/cdda_enabler.prx, 1
#

read -p $'\n\n!!! READ THIS !!!\n\nI am not responsible if you destroy your plugins files, nor will I be able to fix them.\n\nThis is very much so Alpha software and treat it as so. Right now this ONLY works for "ms0" I will implement "ef0" soon.\n\nIt does support converting POPS, GAME and VSH (.txt) files. \n\nPress enter to continue...'

/usr/bin/lsblk

read -p $'\n\nPlease select your PSP/Memory stick drive location ( i.e /mnt/PSP ): ' location

read -p "Is '$location' correct? y/n: " userInput

if [[ ! $userInput =~ ^(y|Y)$ ]]; then
	printf "\nGood Bye!!!\n\n"
	exit 0;
fi

SEPLUGINS_LOC="$location/seplugins"

if [[ ! -d $SEPLUGINS_LOC ]]; then
	printf "\nERR: Hmmmmm can't seem to find the seplugins folder on the root of your PSP\n\nBailing out!\n\n"
	exit 1;
fi


GAME_TXT_EXISIT="false"
POPS_TXT_EXISIT="false"
VSH_TXT_EXISIT="false"


pushd $SEPLUGINS_LOC >/dev/null

for i in $SEPLUGINS_LOC/*; do
	j=$(basename $i)
	if [ ${j,,} == "game.txt" ]; then
		GAME_TXT_EXISIT="true"
	fi
	if [ ${j,,} == "pops.txt" ]; then
		POPS_TXT_EXISIT="true"
	fi
	if [ ${j,,} == "vsh.txt" ]; then
		VSH_TXT_EXISIT="true"
	fi
done

# PRO/ME Example: ms0:/seplugins/brightness/brightness.prx 1
# ARK-4  Example: pops, ms0:/seplugins/cdda_enabler.prx, 1

if [[ $GAME_TXT_EXISIT == "true" && `awk '{print $1}' game.txt | head -n 1` != "game," ]]; then
	#TODO: Add ef0 support
	sed -e "s/prx /prx, /g" -e "s/ms0/game, ms0/g" $SEPLUGINS_LOC/game.txt >> $SEPLUGINS_LOC/plugins.txt
fi

if [[ $POPS_TXT_EXISIT == "true" && `awk '{print $1}' pops.txt | head -n 1` != "pops," ]]; then
	#TODO: Add ef0 support
	sed -e "s/prx /prx, /g" -e "s/ms0/pops, ms0/g" $SEPLUGINS_LOC/pops.txt >> $SEPLUGINS_LOC/plugins.txt
fi

if [[ $VSH_TXT_EXISIT == "true" && `awk '{print $1}' vsh.txt | head -n 1` != "vsh," ]]; then
	#TODO: Add ef0 support
	sed -e "s/prx /prx, /g" -e "s/ms0/vsh, ms0/g" $SEPLUGINS_LOC/vsh.txt >> $SEPLUGINS_LOC/plugins.txt
fi



popd >/dev/null

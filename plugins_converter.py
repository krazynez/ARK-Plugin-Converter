#!/usr/bin/env python3
import subprocess
import platform
import codecs
import glob
import sys
import os
#
# Author    : KrazyNez
# Date      : Jan 28, 2023
# Version   : 0.10
#
#
# PRO/ME Example: ms0:/seplugins/brightness/brightness.prx 1
# ARK-4  Example: pops, ms0:/seplugins/cdda_enabler.prx, 1
#

input('\n\n!!! READ THIS !!!\n\nI am not responsible if you destroy your plugins files, nor will I be able to fix them.\n\nThis is very much so Alpha software and treat it as so.\n\nIt does support converting POPS, GAME and VSH (.txt) files. \n\nPress enter to continue...')

if platform.system().lower() == 'linux':
    subprocess.run('/usr/bin/lsblk')
    location = input('\n\nPlease select your PSP/Memory stick drive location ( i.e /mnt/PSP ): ')
elif platform.system().lower() == 'windows':
    for drive in range(ord('D'), ord('Z')):
        if os.path.exists(chr(drive)+':'):
            if chr(drive)+':' == 'D:':
                print('Drive', chr(drive), 'exists (Probably not this one though, be careful)')
            else:
                print('Drive', chr(drive), 'exists')
    location = input('\n\nPlease select your PSP/Memory stick drive location ( i.e E:\PSP ): ')
else:
    print("Nope I do not want to try MacOS or some niche OS unless I have to.")
    sys.exit(1)


userInput = input(f"Is '{location}' correct? y/n: ")

if not userInput.lower() == 'y':
    print("\nGood Bye!!!\n\n")
    sys.exit();

if platform.system().lower() == 'linux':
    SEPLUGINS_LOC=f"{location}/seplugins"
else:
    SEPLUGINS_LOC=f"{location}\\seplugins"

if not os.path.isdir(SEPLUGINS_LOC): 
    print("\nERR: Hmmmmm can't seem to find the seplugins folder on the root of your PSP\n\nBailing out!\n\n")
    sys.exit(1)


# Globals
GAME_TXT_EXISTS=False
POPS_TXT_EXISTS=False
VSH_TXT_EXISTS=False
GAME_TXT=''
POPS_TXT=''
VSH_TXT=''

cwd = os.getcwd()

os.chdir(SEPLUGINS_LOC)

for i in glob.glob(f'{SEPLUGINS_LOC}/*'):
    if os.path.basename(i.lower()) == "game.txt":
        GAME_TXT=os.path.basename(i)
        GAME_TXT_EXISTS=True
    if os.path.basename(i.lower()) == "pops.txt":
        POPS_TXT=os.path.basename(i)
        POPS_TXT_EXISTS=True
    if os.path.basename(i.lower()) == "vsh.txt":
        VSH_TXT=os.path.basename(i)
        VSH_TXT_EXISTS=True

    if os.path.isfile("plugins.txt"):
        print(f"\nLooks like there already is a plugins.txt. Located : {SEPLUGINS_LOC}\n\n")
        override_it = input("Would you like to override it? y/n: ")
    
        if override_it.lower() == 'n':
            print("\n\nSorry I can't go any further. Good Bye...\n\n")
            sys.exit(0);
        else:
            os.rename(f'{SEPLUGINS_LOC}/plugins.txt', f'{SEPLUGINS_LOC}/plugins.txt.bak')
# PRO/ME Example: ms0:/seplugins/brightness/brightness.prx 1
# ARK-4  Example: pops, ms0:/seplugins/cdda_enabler.prx, 1


def file_checker(file_name=None):
    if file_name is None:
        print("Should not be here!")
        return
    # Validate UTF-8
    with open(file_name, 'rb') as check:
        valid = check.read()
        check.close()

    if valid.decode('utf-8')[:3] != 'ef0' and valid.decode('utf-8')[:3] != 'ms0':
        print(f"\n\nERR: Your '{file_name}' is not UTF-8! Please make sure it is saved at UTF-8\n")
        sys.exit(1)
    else:
        return



# GAME
if GAME_TXT_EXISTS: 

    with open(GAME_TXT) as game:
        FORMAT_CHK=game.readline()
        game.close()    

    if "game," in FORMAT_CHK:
        print(f"Looks like your already setup, but your {POPS_TXT} is setup like plugins.txt")
        sys.exit(1)

    # Check if vailid UTF-8 format
    file_checker(GAME_TXT)

    if "ef0" in FORMAT_CHK:
        with open(GAME_TXT) as game_in:
            with open("plugins.txt", "a") as game_out:
                for line in game_in:
                    game_out.write(line.replace('.prx ', '.prx, ').replace('ef0', 'game, ef0'))
                game_out.close()
            game_in.close()
    else:
        with open(GAME_TXT) as game_in:
            with open("plugins.txt", "a") as game_out:
                for line in game_in:
                    game_out.write(line.replace('.prx ', '.prx, ').replace('ms0', 'game, ms0'))
                game_out.close()
            game_in.close()

# POPS
if POPS_TXT_EXISTS:
    with open(POPS_TXT) as pops:
        FORMAT_CHK=pops.readline()
        pops.close()    

    if "pops," in FORMAT_CHK:
        print(f"Looks like your already setup, but your {POPS_TXT} is setup like plugins.txt")
        sys.exit(1)


    # Check if vailid UTF-8 format
    file_checker(POPS_TXT)

    if "ef0" in FORMAT_CHK:
        with open(POPS_TXT) as pops_in:
            with open("plugins.txt", "a") as pops_out:
                for line in pops_in:
                    pops_out.write(line.replace('.prx ', '.prx, ').replace('ef0', 'pops, ef0'))
                pops_out.close()
            pops_in.close()
    else:
        with open(POPS_TXT) as pops_in:
            with open("plugins.txt", "a") as pops_out:
                for line in pops_in:
                    pops_out.write(line.replace('.prx ', '.prx, ').replace('ms0', 'pops, ms0'))
                pops_out.close()
            pops_in.close()

# VSH
if VSH_TXT_EXISTS:
    with open(VSH_TXT) as vsh:
        FORMAT_CHK=vsh.readline()
        vsh.close()    

    if "vsh," in FORMAT_CHK:
        print(f"Looks like your already setup, but your {VSH_TXT} is setup like plugins.txt")
        sys.exit(1)

    # Check if vailid UTF-8 format
    file_checker(VSH_TXT)

    if "ef0" in FORMAT_CHK:
        with open(VSH_TXT) as vsh_in:
            with open("plugins.txt", "a") as vsh_out:
                for line in vsh_in:
                    vsh_out.write(line.replace('.prx ', '.prx, ').replace('ef0', 'vsh, ef0'))
                vsh_out.close()
            vsh_in.close()
    else:
        with open(VSH_TXT) as vsh_in:
            with open("plugins.txt", "a") as vsh_out:
                for line in vsh_in:
                    vsh_out.write(line.replace('.prx ', '.prx, ').replace('ms0', 'vsh, ms0'))
                vsh_out.close()
            vsh_in.close()


if platform.system().lower() == 'linux':
    print(f"\nConvertion Complete.\n\nplugins.txt located: {SEPLUGINS_LOC}/plugins.txt\n\n")
else:
    print(f"\nConvertion Complete.\n\nplugins.txt located: {SEPLUGINS_LOC}\\plugins.txt\n\n")

os.chdir(cwd)

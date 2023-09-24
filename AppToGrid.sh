#!/bin/bash

DESKTOP_DIR="/usr/share/applications/"
BIN_DIR="/usr/bin/"

# PS3="Select action [1-2]: "
# select action in Add Remove
# do
#     case $action in
#         "Add")
#             break;;
#         "Remove")
#             break;;
#         *)
#             echo "Invalid input.";;
#     esac
# done
action="Add"

if [ "$action" == "Add" ]
then
    while read -rp "Enter application name (name will be shown in app grid): " appName
    do
        if [ "$appName" == "" ] 
        then
            echo "Application name cannot be empty."
        else 
            break
        fi
    done

    while read -rp "Enter path to executable (full path with extension): " pathToExe
    do
        if [ ! -f "$pathToExe" ] 
        then
            echo "Executable not found."
        else 
            break
        fi
    done

    exeNameWithExtension=$(basename "$pathToExe")
    exeName="${exeNameWithExtension%.*}"
    while read -rp "Copy executable $exeNameWithExtension to $BIN_DIR [y/n]?  " res
    do
        if [ "$res" == "y" ]
        then
            echo "Copying executable $exeNameWithExtension to $BIN_DIR..."
            cp -i "$pathToExe" "$BIN_DIR"
            pathToExe="$BIN_DIR$exeNameWithExtension"
            break
        elif [ "$res" == "n"  ] 
        then
            break
        else 
            echo "Invalid answer."
        fi
    done

    echo "Adding permissions..."
    chmod +x "$pathToExe"

    echo "Adding desktop entry $exeName.desktop to grid at $DESKTOP_DIR..."
    echo "[Desktop Entry]
    Type=Application
    Terminal=false
    Exec='$pathToExe'
    Name=$appName
    Comment=$appName
    Keywords=$appName;" > "$exeName.desktop"

    mv -i "$exeName.desktop" "$DESKTOP_DIR$exeName.desktop"

elif [ "$action" == "Remove" ]
then
    while read -rp "Enter application name (name in grid): " appName
    do
        if [ "$appName" == "" ] 
        then
            echo "Application name cannot be empty."
        else 
            break
        fi
    done

    echo "Searching directories..."
    shopt -s nullglob
    desktopEntries=("$DESKTOP_DIR"*)
    for desktopEntry in "${desktopEntries[@]}"
    do
        if grep -q "Name=$appName" "desktopEntry"
        then
            exeName="$(basename "$desktopEntry" ".desktop")"
            break
        fi
    done

    filesFound=()
    if [ -f "$BIN_DIR$exeName" ] 
    then
        echo "Executable $exeName found in $BIN_DIR."
        filesFound+=("$BIN_DIR$exeName")
    fi
    if [ -f "$DESKTOP_DIR$exeName.desktop" ] 
    then
        echo "Desktop entry $exeName.dektop found in $DESKTOP_DIR."
        filesFound+=("$DESKTOP_DIR$exeName.desktop")
    fi

    if [ "${#filesFound[@]}" -gt 0 ]
    then
        while read -rp "Remove ${#filesFound[@]} files [y/n]?  " res
        do
            if [ "$res" == "y" ]
            then
                for file in "${!filesFound[@]}"
                do
                    echo "Removing $file..."
                    rm "$file"
                done
                break
            elif [ "$res" == "n"  ] 
            then
                break
            else 
                echo "Invalid answer."
            fi
        done
    else
        echo "Application not found."
    fi
fi

echo "Done."
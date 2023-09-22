#!/bin/bash

while read -rp "Enter application name (name will be shown in app grid): " appName
do
    if [ "$appName" == "" ] 
    then
        echo "Application name cannot be empty."
    else 
        break
    fi
done

while read -rp "Is it a terminal application (will open app in terminal) [y/n]? " terminalApp
do
    if [ "$terminalApp" == "y" || "$terminalApp" == "n" ] 
    then
        break
    else 
        echo "Invalid answer."
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

fileNameWithExtension=$(echo "$pathToExe" | sed "s/.*\///")
while read -rp "Copy executable $fileNameWithExtension to /usr/bin/ [y/n]?  " res
do
    if [ "$res" == "y" ]
    then
        echo "Copying executable $fileNameWithExtension to /usr/bin/..."
        cp -i "$pathToExe" "/usr/bin/"
        pathToExe="/usr/bin/$fileNameWithExtension"
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

# sh -c 'echo hello; $SHELL'
echo "Adding application entry $appName.desktop to grid at /usr/share/applications/..."
echo "[Desktop Entry]
Type=Application
Terminal=$terminalApp
Exec='$pathToExe'
Name=$appName
Comment=$appName
Keywords=$appName;" > "$appName.desktop"

mv -i "$appName.desktop" "/usr/share/applications/$appName.desktop"

echo "Done."
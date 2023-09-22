#!/bin/bash

read -rp "Enter application name (name will be shown in app grid): " appName

read -rp "Enter path to executable (full path with extension): " pathToExe

fileNameWithExtension=$(echo "$pathToExe" | sed "s/.*\///")
read -rp "Copy executable $fileNameWithExtension to /usr/bin/ [y/n]?  " res

if [ "$res" == "y" ]
then
    echo "Copying executable $fileNameWithExtension to /usr/bin/..."
    cp "$pathToExe" "/usr/bin/"
    pathToExe="/usr/bin/$fileNameWithExtension"
fi

echo "Adding application to grid at /usr/share/applications/$appName.desktop..."
echo "[Desktop Entry]
Type=Application
Terminal=false
Exec='$pathToExe'
Name=$appName
Comment=$appName
Keywords=$appName;" > "/usr/share/applications/$appName.desktop"

echo "Adding permissions..."
chmod +x "$pathToExe"
echo "Done."
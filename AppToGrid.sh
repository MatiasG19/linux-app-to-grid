#!/bin/bash

read -p "Enter application name (name will be shown in app grid): " appName

read -p "Enter path to executable (full path with extension): " pathToExe

fileNameWithExtension=$(echo "$pathToExe" | sed "s/.*\///")
read -p "Copy executable $fileNameWithExtension to /usr/bin/ [y/n]?  " res

if [ $res == "y" ]
then
echo "Copying executable $fileNameWithExtension to /usr/bin/..."
cp $pathToExe "/usr/bin/"
pathToExe="/usr/bin/$fileNameWithExtension"
fi

echo "[Desktop Entry]
Type=Application
Terminal=false
Exec='$pathToExe'
Name=$appName
Comment=$appName
Keywords=$appName;" > "/usr/share/applications/$appName.desktop"

echo "Application added to grid."
echo "/usr/share/applications/$appName.desktop"
echo "Adding permissions..."
chmod +x "$pathToExe"
echo "Permissions added."
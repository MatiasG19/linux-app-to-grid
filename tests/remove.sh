#!/bin/bash

##################################
# arrange
##################################
echo Arrage
appName="Test App"
exeNameWithExtension=myApp.sh
exeName=myApp

mkdir temp
echo "#!/bin/bash
echo Hello world!
" > ./temp/$exeNameWithExtension

# Create files
printf '%s\n' 1 "$appName" ./temp/$exeNameWithExtension y | sudo ./AppToGrid.sh

## Check if executable exists
if [ ! -f "/usr/bin/$exeNameWithExtension" ]; then
    echo "Failed to create desktop entry."
    exit 1
fi

# Check if desktop file exists
if [ ! -f "/usr/share/applications/$exeName.desktop" ]; then
    echo "Failed to create desktop entry."
    exit 1
fi

##################################
# act
##################################
echo Act
printf '%s\n' 2 "$appName" ./temp/$exeNameWithExtension y | sudo ./AppToGrid.sh

##################################
# assert
##################################
echo Assert

## Check if executable was removed
if [ -f "/usr/bin/$exeNameWithExtension" ]; then
    {  
        echo "Assert 1" 
        echo "Executable $exeNameWithExtension does still exist in /usr/bin/"
        echo
    } >> test.log
fi

# Check if desktop file was removed
if [ -f "/usr/share/applications/$exeName.desktop" ]; then
    {  
        echo "Assert 2" 
        echo "Desktop entry $exeName.desktop does still exist in /usr/share/applications/"
        echo
    } >> test.log
fi

## Fail test when logfile exists
if [ -f test.log ]; then
    cat test.log
    exit 1
fi
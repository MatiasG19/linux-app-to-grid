#!/bin/bash

echo "##################################"
echo "# Arrage"
echo "##################################"
appName="Test App"
exeNameWithExtension=myApp.sh
exeName=myApp

mkdir temp
echo "#!/bin/bash
echo Hello world!
" > ./temp/$exeNameWithExtension

# Create files
printf '%s\n' 1 "$appName" ./temp/$exeNameWithExtension y | sudo ../AppToGrid.sh
echo

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
echo

echo "##################################"
echo "# Act"
echo "##################################"
printf '%s\n' 2 "$appName" y | sudo ../AppToGrid.sh
echo

echo "##################################"
echo "# Assert"
echo "##################################"

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
    echo "Show test log:"
    cat test.log
    exit 1
fi
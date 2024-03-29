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
echo

echo "##################################"
echo "# Act"
echo "##################################"
printf '%s\n' 1 "$appName" ./temp/$exeNameWithExtension y | sudo ../AppToGrid.sh
echo

echo "##################################"
echo "# Assert"
echo "##################################"

## Check if executable exists
if [ ! -f "/usr/bin/$exeNameWithExtension" ]; then
    {  
        echo "Assert 1" 
        echo "Executable does not exist in /usr/bin/"
        echo
    } >> test.log
fi

## Check if desktop file exists
if [ ! -f "/usr/share/applications/$exeName.desktop" ]; then
    {
        echo "Assert 2"
        echo ".desktop file does not exist in /usr/share/applications/" 
        echo
    } >> test.log
fi

## Check .desktop file content
echo "[Desktop Entry]
Type=Application
Terminal=false
Exec='/usr/bin/$exeNameWithExtension'
Name=$appName
Comment=$appName
Keywords=$appName;" > test.desktop
diff "test.desktop" "/usr/share/applications/$exeName.desktop"
if [ "$?" -eq 1 ]
then
    {
        echo "Assert 3" 
        echo ".desktop file content does not match test data"
        diff -y "test.desktop" "/usr/share/applications/$exeName.desktop"
        echo
    } >> test.log
fi

## Check executable permissions
if [ ! "$(ls -l /usr/bin/$exeNameWithExtension | cut -c 10-10)" == "x" ]
then
    {
        echo "Assert 4" 
        echo "Executable has no execution permissions"
        ls -l /usr/bin/$exeNameWithExtension
        echo
    } >> test.log
fi

## Run test app
$exeNameWithExtension | grep -q "Hello world!"
if [ "$?" -eq 1 ]
then
    {
        echo "Assert 5" 
        echo "Output of $appName does not match expected output"
        diff <(bash $exeName) <(echo "Hello world!")
        echo
    } >> test.log
fi

## Fail test when logfile exists
if [ -f test.log ]; then
    echo "Show test log:"
    cat test.log
    exit 1
fi
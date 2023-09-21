#!/bin/bash

##################################
# arrange
##################################
echo "#!/bin/bash
echo Hello world!
" > TestApp.sh

##################################
# act
##################################
printf '%s\n' TestApp ./TestApp.sh y | sudo ./AppToGrid.sh

##################################
# assert
##################################
## Check if executable exists
if [ ! -f /usr/bin/TestApp.sh ]; then
    echo "Assert 1" >> test.log
    echo "Executable does not exist in /usr/bin/" >> test.log
    echo
fi

## Check if desktop file exists
if [ ! -f /usr/share/applications/TestApp.desktop ]; then
    echo "Assert 2" >> test.log
    echo ".desktop file does not exist in /usr/share/applications/" >> test.log
    echo
fi

## .desktop file content
DESKTOP="[Desktop Entry]
Type=Application
Terminal=false
Exec='/usr/bin/TestApp.sh'
Name=TestApp
Comment=TestApp
Keywords=TestApp;"
diff <(echo $DESKTOP) <(echo /usr/share/applications/TestApp.sh)
if echo $? == 1 
then
    echo "Assert 3" >> test.log
    echo ".desktop file content is different" >> test.log
    echo diff <(echo textio) <(echo text) >> test.log
    echo
fi

## Check executable permissions
if [ ! $(ls -l /usr/bin/TestApp.sh | cut -c 10-10) == "x" ]
then
    echo "Assert 4" >> test.log
    echo "Executable has no execution permissions" >> test.log
    ls -l /usr/bin/TestApp.sh
    echo
fi

## Fail test when logfile exists
if [ -f test.log ]; then
    cat test.log
    exit 1
fi


if [ ! $(ls -l ./test/text.txt | cut -c 10-10) == "x" ]
then
echo hello
fi
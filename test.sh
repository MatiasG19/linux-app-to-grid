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
echo "[Desktop Entry]
Type=Application
Terminal=false
Exec='/usr/bin/TestApp.sh'
Name=TestApp
Comment=TestApp
Keywords=TestApp;" > test.desktop
diff <(cat test.desktop) <(cat /usr/share/applications/TestApp.desktop)
if [ "$?" -eq 1 ] 
then
    {
        echo "Assert 3" 
        ".desktop file content is different"
        diff <(cat test.desktop) <(cat /usr/share/applications/TestApp.desktop)
    } >> test.log
    echo
fi

## Check executable permissions
if [ ! "$(ls -l /usr/bin/TestApp.sh | cut -c 10-10)" == "x" ]
then
    {
        echo "Assert 4" 
        echo "Executable has no execution permissions"
        ls -l /usr/bin/TestApp.sh
    } >> test.log
    echo
fi

## Run test app
TestApp.sh | grep "iHello world!" > /dev/null
if [ "$?" -eq 1 ]
then
    {
        echo "Assert 5" 
        echo "Output of TestApp does not match expected output"
        diff <(bash TestApp.sh) <(echo "Hello world!")
    } >> test.log
    echo
fi

## Fail test when logfile exists
if [ -f test.log ]; then
    cat test.log
    exit 1
fi
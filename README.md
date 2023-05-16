# App to grid

Simple command line tool to add applications to the app grid or list of your desktop environment.

![Appgrid](./Appgrid.png)

## How it works

App to grid creates a `.desktop` file in `/usr/share/applications` for your application, so you can access it from the app grid or list of your desktop environment.

Optionally it copies your binary to `/usr/bin`. That is useful for binaries like AppImages.

## Getting started

Enter `sudo ./AppToGrid.sh` into the terminal and follow the prompts.

> Always enter the full application name and extension when the source application path is prompted, e.g. `/path/to/myApp.AppImage`

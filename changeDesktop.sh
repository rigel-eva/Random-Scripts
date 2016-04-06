#!/bin/bash
#Usage: changeDesktop.sh /some/file/that/is/an/image/that/would/be/a/valid/desktop.oiloncanvas (optional: number_of_the_desktop_that_we_want_to_change_0_indexed.)
if [ -n "$2" ]; then
desktop=$2
else
desktop=0; #The Desktop that we are trying to change, 0 indexed with 0 being the first desktop created
fi
if [ -n "$1" ]; then
desktopLocation="$1"
else
desktopLocation="/Library/Desktop Pictures/Snow.jpg" #Where our Desktop is located
fi
sqlite3 ~/Library/Application\ Support/Dock/desktoppicture.db "update data set value='$desktopLocation' where value like '%.%' LIMIT $desktop,1;"
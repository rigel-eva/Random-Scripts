#!/bin/bash
#Usage: getDesktopLocation.sh desktop_number_you_want_to_get_zero_indexed
if [ -n "$1" ]; then
desktop=$1
else
desktop=0
fi
echo "$(sqlite3 ~/Library/Application\ Support/Dock/desktoppicture.db "select value from data where value like '%.%' LIMIT 1 OFFSET $desktop;")";
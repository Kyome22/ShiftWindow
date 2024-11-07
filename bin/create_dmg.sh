#!/bin/sh
## https://github.com/create-dmg/create-dmg

create-dmg \
--icon-size 128 \
--text-size 16 \
--icon "ShiftWindow.app" 200 150 \
--app-drop-link 450 150 \
--window-pos 200 200 \
--window-size 650 376 \
--background bin/dmg_background.png \
Installer.dmg $1

#!/bin/bash

SCRIPTPATH=$(dirname $0)

echo "$(date +"%b %e %H:%M:%S") tcarreira-sapo-laptop systemd-logind[xxx]: >>> Lunch Time" | tee -a /var/log/auth.log

cinnamon-screensaver-command -l

"${SCRIPTPATH}/waitreturnWindow.py"

echo "$(date +"%b %e %H:%M:%S") tcarreira-sapo-laptop systemd-logind[xxx]: <<< Lunch Time" | tee -a /var/log/auth.log
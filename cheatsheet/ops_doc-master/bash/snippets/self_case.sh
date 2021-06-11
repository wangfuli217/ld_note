#!/bin/sh
echo "Please input \"yes\" or \"no\""
read var
case "$var" in
[yY][eE][sS] ) echo "Your input is YES" ;;
[nN][oO]     ) echo "Your input is YES" ;;
*            ) echo "Input Error!"      ;;
esac
exit 0
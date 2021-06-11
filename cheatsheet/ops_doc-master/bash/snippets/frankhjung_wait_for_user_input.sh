====== Wait for user input ======

Bash snippet which prompts user for response

<file bash>
while true; do
    read -p "Do you wish to install this program?" yn
    case $yn in
        [Yy]* ) make install; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done
</file>

{{tag>bash prompt}}
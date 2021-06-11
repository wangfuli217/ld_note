The only script defined here is for completion: `etc/bash_completion.d/bash-utils-completion`.

Update it to add your modules'completion functions.

To load it during development, use:

    source etc/bash_completion.d/bash-utils-completion

To install it, use the `make` command (global install):

    cd /path/to/bash-utils
    make install DESTDIR=/install/path


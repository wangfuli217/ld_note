The final manpages files are generated from the `MANPAGE.X.md` markdown content
with the help of <http://github.com/e-picas/markdown-extended>.

To generate it, run:

        markdown-extended -f man -o man/bash-utils.X.man man/MANPAGE.X.md
        man man/bash-utils.X.man

Or use the `make` command:

    cd /path/to/bash-utils
    make manpages


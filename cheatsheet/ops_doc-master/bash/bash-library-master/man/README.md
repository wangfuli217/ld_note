The final `piwi-bash-library.man` file is generated from the `MANPAGE.md` markdown content
with the help of <http://github.com/piwi/markdown-extended>.

To generate it, run:

        ./modules/markdown-extended/bin/markdown-extended -f man -o man/piwi-bash-library.man man/MANPAGE.md
        man man/piwi-bash-library.man

Or use the script from the `build/` directory:

    ./build/make-manpage.sh


package.path (for modules written in Lua) and package.cpath (for modules written
in C) are the places where Lua looks for modules. They are semicolon-separated
lists, and each entry can have a ? in it that's replaced with the module name.
This is an example of what they look like:

> =package.path
> ./?.lua;/usr/local/share/lua/5.1/?.lua;/usr/local/share/lua/5.1/?/init.lua;/usr/local/lib/lua/5.1/?.lua;/usr/local/lib/lua/5.1/?/init.lua;/usr/share/lua/5.1/?.lua;/usr/share/lua/5.1/?/init.lua
> > =package.cpath
> > ./?.so;/usr/local/lib/lua/5.1/?.so;/usr/lib/x86_64-linux-gnu/lua/5.1/?.so;/usr/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/loadall.so

package.loaded is a table, where the already loaded modules are stored by name.
As mentioned before, this acts as a cache so that modules aren't loaded twice,
instead require first tries getting the module from this table, and if it's
false or nil, then it tries loading.

package.preload is a table of functions associated with module names. Before
searching the filesystem, require checks if package.preload has a matching key.
If so, the function is called and its result used as the return value of
require.



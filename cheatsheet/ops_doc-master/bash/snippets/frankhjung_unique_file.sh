====== Create a unique file name ======

This shows how to create a unique temporary file.

Since at least 2009 there has been the [[|mktemp(1)]] command.

<code bash>
$ mktemp temp-XXXX
temp-aQmM
</code>

If running on a really old system then you can still use this approach:

This will work with Bourne Shell. It is a combination of current program and
current process id.

<code bash>
# create a unique temporary file
tempfile=/tmp/${0##*/}.$$
debug "Using tempfile ${tempfile}"
</code>

{{tag>bash temporary file}}
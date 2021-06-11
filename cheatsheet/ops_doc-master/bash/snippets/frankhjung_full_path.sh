====== Get fully qualified path ======

Use [[http://unixhelp.ed.ac.uk/CGI/man-cgi?readlink|readlink(1)]]:

<file bash>
directory=.
echo $directory
echo $(readlink -f $directory)
# .
# /home/frank/bin
</file>

===== Current Path =====

To get the current path, just use the in-built variable ''PWD''.
c.f. Previous path is ''OLDPWD''.

{{tag>bash path readlink}}
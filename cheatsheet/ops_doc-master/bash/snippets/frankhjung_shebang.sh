====== Hash bang ======

Hash Bang, also known as [[wp>Shebang_(Unix)]] is used to indicate the
interpreter program to run. So when a script with a Shebang is run as a program,
the program loader parses the rest of the script is initial line as an
interpreter directive; the specified interpreter program is run instead, passing
to it as an argument the path that was initially used when attempting to run the
script.

===== Examples =====

Using Shebang to run a script using Bourne Shell

<file bash>
#!/bin/sh
</file>

Alternatively, To run a script using the Python interpreter you can use

<file bash>
#!/usr/bin/env python

# python code follows ...
</file>

{{tag>bash shebang}}
====== Set options ======

This page provides some recommended Bash script options.

===== Login shell =====

Test if in a login shell with

<code bash>
bash --login
shopt login_shell
</code>
  login_shell    	on

<code bash>
bash
shopt login_shell
</code>
  login_shell    	off

===== -e exit on non-true return value =====

This will exit in error if any command returns a non-true return value.
Set with 

<file bash>
set -e
# same as
set -o errexit
</file>

===== -u un-initialised variable =====

This will exit the script in failure if an un-initialised variable is used.
Set with 

<file bash>
set -u
# same as
set -o nounset
</file>

===== -x xtrace =====

This will set trace on (debug).
Set with 

<file bash>
set -x
# same as
set -o xtrace
</file>

===== $@ parameters =====

Always quote the ''$@'' variable. This is to avoid incorrectly expanding words that contain a space.


===== Start Bash with new environment =====

To start Bash with a new, clean environment (for example without proxy settings) use

<file bash>
env -i bash
</file>

{{tag>bash set option shopt}}
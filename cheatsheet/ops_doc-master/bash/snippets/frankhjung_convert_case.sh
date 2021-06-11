====== Convert string case ======

To convert a string to an alternate case there are two methods:

===== Bash string function =====

The best way to do this is using the
[[http://www.gnu.org/software/bash/manual/bashref.html|bash]] (version 4+)
inbuilt string function:

  * To convert to lower-case use, ''${astring,,}''
  * To convert to upper-case use, ''${astring^^}''.
  * To toggle case use, ''${astring~~}''.

<file bash Example>
astring="Hello World"

# upper-case
echo ${astring^^}
HELLO WORLD

# lower-case
echo ${astring,,}
hello world

# toggle case
echo ${astring~~}
hELLO wORLD
</file>

===== Translate string =====

Convert string to lower-case using translate, [[http://linux.die.net/man/1/tr|tr(1)]]

<file bash>
# convert to lower-case
astring="HELLO WORLD"
tr [A-Z] [a-z] <<< "$astring"
hello world
# same as
tr [:upper:] [:lower:] <<< "$astring"
</file>

To convert to upper-case reverse translation sets.

==== Delete from string ====

To delete characters from a string using translate use

<file bash>
# delete characters from string
astring="HELLO WORLD"
tr -d [A-F] <<< "$astring"
HLLO WORL
</file>

==== Compliment a string ====

Compliment: characters not in ''set1'' are replaced by ''set2''

<file bash>
astring="HELLO WORLD"
tr -c 'A-Z' '\n' <<< "$astring"
HELLO
WORLD
# split by 'O' character boundary
tr -c ' A-NP-Z' '\n' <<< "$astring"
HELL
 W
RLD
</file>

{{tag>bash string case translate convert}}
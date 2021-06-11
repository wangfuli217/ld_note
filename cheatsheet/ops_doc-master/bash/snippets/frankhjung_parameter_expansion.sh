====== Parameter expansion ======

The following are examples I have used for shell property file expansion.

===== Change file suffix =====

Convert ''wav'' audio files:

<code bash>
# wav to raw
for w in *.wav; do sox $w ${w%wav}raw; done

# wav to mp3
for w in *.wav; do lame -h $w ${w%wav}mp3; done
</code>

===== Copy directories preserving structure =====

The following will copy from one location a subset of directories and files into
another location preserving the directory structure:

<code bash>
# copy jenkins jobs config.xml
echo Updating jobs ...
pushd ${JOBS_DIR}
for f in */config.xml; do
    mkdir -p ${WORKSPACE}/jenkins/jobs/$(dirname $f)
    cp -pr $f ${WORKSPACE}/jenkins/jobs/${f##*/jobs/};
done
popd
</code>

===== Create temporary file =====

Using a combination of current program and current process id to create a
temporary file:

<file bash>
# create a unique temporary file
tempfile=/tmp/${0##*/}.$$
echo "Using tempfile ${tempfile}"
</file>

===== Default value =====

If the variable has not yet been set, provide a [[http://wiki.bash-hackers.org/syntax/pe#assign_a_default_value|default value]]:

<file bash>
# set default log location as current path
LOG=${LOG:-$PWD/report.log}
</file>

===== Number range =====

To print a range of integers from 1 to 10:

<code bash>
echo {1..10}
</code>

Which can be used in a for-loop:

<code bash>
for i in {1..10}
do
  echo $i
done
</code>

Same as:

<code bash>
i=0
while ((i++<10))
do
  echo $i
done
</code>

===== Match regular expression =====

The following will return the first matching group:

<code bash>
# given a date string
adate='2013-05-26'

# find month using regular expression
echo $(expr ${adate} : '.*-\(.*\)-.*')

# returns
05

# which is the same as
echo $(expr match ${adate} '.*-\(.*\)-.*')
</code>

==== Match regular expression - version numbering ====

To match version numbering, try:

<code bash match-versions.sh>
#!/usr/bin/env bash

# test reg-exp to match version numbering
PATTERN="^[[:digit:]]+(\.[[:digit:]]+)*$"

# test cases
GOOD=('123' '1.2' '1.2.3' '1.2.3.4')
BAD=('.123' '123.' 'abc' 'a.b' )

echo testing good use cases
for v in ${GOOD[*]}; do
    printf "good $v = " && [[ ${v} =~ ${PATTERN} ]] && echo PASS || echo FAIL
done

echo testing bad use cases
for v in ${BAD[*]}; do
    printf "bad $v = " && [[ ! ${v} =~ ${PATTERN} ]] && echo PASS || echo FAIL
done
</code>

  $ ./match-versions.sh
  testing good use cases
  good 123 = PASS
  good 1.2 = PASS
  good 1.2.3 = PASS
  good 1.2.3.4 = PASS
  testing bad use cases
  bad .123 = PASS
  bad 123. = PASS
  bad abc = PASS
  bad a.b = PASS

===== Remove from beginning =====

The following show how to remove characters matched at the //beginning// of a
string.

<code bash>
astring=123AB25CD456

# remove shortest matching part from beginning
echo ${astring#1*2}
3AB25CD456

# remove longest matching part from beginning
echo ${astring##1*2}
5CD456

astring=YYYY-MM-DD

echo ${astring#Y*-}
MM-DD

echo ${astring##Y*-}
DD
</code>

===== Remove from inside =====

In this example we remove characters from a property.

<code bash>
# given a date string
adate='2013-05-26'

# convert from YYYY-MM-DD to YYYMMDD
echo ${adate//-/}

# returns
20130526
</code>

===== Remove from end =====

The following show how to remove characters matched at the //end// of a string.

<code bash>
astring=123AB25CD456

# remove shortest matching part from the end
echo ${astring%2*6}
123AB

# remove longest matching part from the end
echo ${astring%%2*6}
1

astring=YYYY-MM-DD

echo ${astring%-*D}
YYYY-MM

echo ${astring%%-*D}
YYYY
</code>

===== Sub-string of property =====

Given a property, retrieve a sub-string:

<code bash>
# given a property
foobar='FOBAFOOBARFBFOBABARFOOR'

# return a substring of 6 characters from position 4 (starts from 0)
echo "${foobar:4:6}"

# returns
FOOBAR
</code>

===== Trim whitespace =====

To trim leading and trailing spaces use:

<code bash>
trimmed=$(echo ${var}|xargs)
</code>

For example:

  $ var="  1234   "
  $ echo "[$var]"
  $ echo "[$(echo $var|xargs)]";
  [  1234   ]
  [1234]

====== See Also ======

  * [[frank:bash:convert_case|]]

{{tag>bash parameter regexp}}
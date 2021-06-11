====== Count source lines ======

To efficiently count lines of source code try:

<file bash>
# this will print out just a one-line result
( find ./ -name '*.java' -print0 | xargs -0 cat ) | wc -l

# alternatively, this will sum for each file
find ./ -name '*.java' -print0 | wc -l --files0-from=-

# to show just the line total
find ./ -name '*.java' -print0 | wc -l --files0-from=- | tail -1

# for each top level directory
for f in $(ls); do echo -n $f= ; ( find $f -name '*.java' -print0 | xargs -0 cat ) | wc -l ; done

# to exclude empty lines from the count
for f in $(ls); do echo -n $f= ; ( find $f -name '*.java' -print0 | xargs -0 cat | grep -v '^\s*$' ) | wc -l ; done
</file>

If using a recent version of Bash (I'm using 4.2), then this can be done using extended globs with:

<file bash>
shopt -s globstar
wc -l **/*.java
</file>

{{tag>bash source count}}
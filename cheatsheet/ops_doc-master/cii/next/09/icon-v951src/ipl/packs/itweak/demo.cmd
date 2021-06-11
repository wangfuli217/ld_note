# Annotated debugging commands for the demo debugging session.
# $Id: demo.cmd,v 2.21 1996/10/04 03:45:37 hs Rel $
#
# After seeing the 'automatic' debugging session you may want to repeat
# some of the commands manually in a new interactive session.

#
# The following commands use a liberal amount of 'fprint' to make the output
# more readable.
# The first few commands are spelled out fully. Then we start using
# abbreviations.
#

# When you get the first prompt you are somewhere in anonymous initialization
# code. Enter 'next' to step into a real source file. This is not necessary,
# but may allow you to omit the file name in 'breakpoint' commands.
next

# What source files do we have?
info files

# Let's find out what globals the program contains...
fprint "--- Globals:\n"
info global

# ...and the locals of the current procedure:
fprint "--- Locals in %1:\n"; &proc
info locals

# Set a breakpoint in the main loop.
break 88
goon

# Got the first break.
print word
goon

# Next break.
pr word

# Boring to 'print word' every time. Add this command to the
# breakpoint.  Note that when a breakpoint has commands the usual
# prelude is not printed when a breakpoint is reached. Thus add some
# extra printing. Note that 'fprint' does not automatically output a
# newline.
do .
fprint "--- Break in %1 line %2: "; &proc; &line
print word
end

go
go
go

# Attach a condition to the breakpoint. This time we use the explicit
# breakpoint id (1).
cond 1 word == "buffer"
go

# Let's examine a compound variable.
fprint "--- Examining 'resword'.\n"
pr resword
# It's a list. Try 'eprint' to see all elements.
eprint !resword
# 'eprint' prints 'every' value generated by an expression.

# Try another one.
pr prec
# A list again. Prints its elements,
epr !prec
# Only one element which is a record.
pr prec[1].pname
epr !prec[1]

# We may even invoke one of the target program's procedures.
# Here we invoke 'addword' to add a bogus entry in the cross reference.
# We use global 'linenum' to provide the line number.
pr addword("ZORRO", "nowhere", linenum)

# Examine globals again.
fprint "--- Globals one more time:\n"
inf gl
fprint "--- WHAT??!!! The program has modified 'proc' -- bad manners!\n"
# It's good to have a robust debugger. Let's examine the new value.
pr proc; type(proc)

# Examine the current breakpoint.
fprint "--- The current breakpoint:\n"
info br .

# Let's set a breakpoint i procedure 'addword'...
br 150
# ...and delete the first breakpoint.
clear br 1
go

# This is the way to find out where we are (the procedure call chain):
where
# It is possible to examine any of the frames in the call chain.
frame 1

# Let the program work along for a while.
# Ignore the 280 next breaks.
fprint "--- Ignoring the next 280 breaks...\n"
ign . 280
go
# Find out about the word "word":
pr var["word"]
# It's a table. Examine its keys and entries.
epr key(var["word"])
epr !var["word"]
# The entries are lists. Let's look at the "addword" entry.
epr !var["word"]["addword"]
# That's a lot of typing. Let's try a macro.
mac var
eprint !var["word"]["addword"]
fprint "That was %1 items.\n"; *var["word"]["addword"]
end

# Try the macro (which has now become a new command):
var

# Now we've tried the most common commands.
# Let the program run to completion undisturbed. The following is an
# abbreviation of 'goon nobreak'.
fpr "--- Now let the program produce its normal output...\n\n"
go no

# We will se the normal output of the program: a cross reference listing
# (in this case applied to its own source code).
# Note the bogus 'ZORRO' variable we entered by calling 'addword'.

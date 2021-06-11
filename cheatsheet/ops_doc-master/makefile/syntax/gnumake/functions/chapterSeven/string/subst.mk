# Replace string FROM ==> TO in TEXT
# $(subst FROM,TO,TEXT)

subst:
	echo $(subst foo,bar,foofoo)
	echo $(subst foo,bar,foo foo1 foo2)


# ID must > 0 , from 1 to ...
#make -f word.mk ID=5
SOURCES := one two three four five six
ID := 3
# wordlist [FROM,TO]
FROM := 2
TO := 4

# words, count

# firstword
all :
	@echo "Index $(ID) in Sources is $(word $(ID),$(SOURCES))"
	@echo "Index $(FROM)-$(TO) in Sources is $(wordlist $(FROM),$(TO),$(SOURCES))"
	@echo "words is $(words $(SOURCES))"
	@echo "firstword is $(firstword $(SOURCES))"

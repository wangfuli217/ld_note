# (1) --- *
object = *.c
count = $(words $(object))

# (2) -- *
main : *.c
	@echo $^
	@echo $?
	cc *.c   -o main

# (3) ----- *
test :
	@echo object = $(object)
	@echo count = $(count)

clean:
	rm main

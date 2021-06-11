# 1) no param
# $ make -f errorMakeTest.mk 
# $mkdir: cannot create directory ‘test’: File exists
# $make: *** [one] Error 1

# 2) -k
# $make -f errorMakeTest.mk -k
# $mkdir: cannot create directory ‘test’: File exists
# $make: *** [one] Error 1
# $Hello three
# $make: Target `two' not remade because of errors.

# 3) -i
# $make -f errorMakeTest.mk -i
# $mkdir: cannot create directory ‘test’: File exists
# $make: [one] Error 1 (ignored)
# $Hello one
# $Hello three
# $Hello Two

two : one three
	@echo "Hello Two"

one :
	@mkdir test
	@echo "Hello one"

three :
	@echo "Hello three"

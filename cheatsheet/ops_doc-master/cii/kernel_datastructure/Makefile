include base.mk
.PHONY:test lib clean
test:lib
	make -C $(TEST) all
lib:
	make -C $(LIB) lib
clean:
	make -C $(LIB) clean
	make -C $(TEST) clean

list1 := foo bar hei
list2 := .c .s .o
list3 := .c .s .o .h

all : 
	@echo "list1=$(list1)"
	@echo "list2=$(list2)"
	@echo "list2=$(list3)"
	@echo "list1+list2=$(join $(list1),$(list2))"
	@echo "list1+list3=$(join $(list1),$(list3))"

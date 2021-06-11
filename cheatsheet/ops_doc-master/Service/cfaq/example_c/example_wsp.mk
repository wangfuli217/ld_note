.PHONY: clean All

All:
	@echo "----------Building project:[ class_method - Debug ]----------"
	@cd "class_method" && $(MAKE) -f  "class_method.mk"
clean:
	@echo "----------Cleaning project:[ class_method - Debug ]----------"
	@cd "class_method" && $(MAKE) -f  "class_method.mk" clean

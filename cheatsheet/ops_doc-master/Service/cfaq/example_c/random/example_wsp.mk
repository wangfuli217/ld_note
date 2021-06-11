.PHONY: clean All

All:
	@echo ----------Building project:[ random - Debug ]----------
	@cd "random" && "$(MAKE)" -f "random.mk"
clean:
	@echo ----------Cleaning project:[ random - Debug ]----------
	@cd "random" && "$(MAKE)" -f "random.mk" clean

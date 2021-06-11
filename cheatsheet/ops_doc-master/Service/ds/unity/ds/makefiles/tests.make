# tests
# ----------------------------------------------------------------------------
# compiler

TESTS_CFLAGS = $(CC_CFLAGS) \
               -I$(BUILD_UNITY_DIR)

TESTS_LDFLAGS = $(CC_LDFLAGS) \
                -L$(BUILD_UNITY_DIR) -lunity

# ----------------------------------------------------------------------------
# commands

TESTS_SOURCES := $(wildcard $(TESTS_DIR)/*.c)
TESTS_OBJECTS := $(patsubst %, $(BUILD_TESTS_DIR)/%, $(notdir $(TESTS_SOURCES:.c=.o)))
TESTS_TARGETS := $(patsubst %, $(BUILD_TESTS_DIR)/%, $(notdir $(TESTS_OBJECTS:.o=)))

run_tests:
	@echo "$(RED) run tests:$(NC)"
	$(foreach test, $(TESTS_TARGETS), \
          $(test) | grep "FAIL"; \
          echo "$(GREEN) TEST $(test)$(NC)";)	
	
build_tests: $(TESTS_TARGETS)

$(BUILD_TESTS_DIR)/% : $(BUILD_TESTS_DIR)/%.o
	@echo "$(RED)Linking $@ $(NC)"
	$(CC) -o $@ $^ $(SRC_OBJECTS) $(TESTS_CFLAGS) $(TESTS_LDFLAGS)

$(BUILD_TESTS_DIR)/%.o : $(TESTS_DIR)/%.c
	@echo "$(RED)Compiling $< $(NC)"
	$(CC) -c $< -o $@ $(TESTS_CFLAGS)


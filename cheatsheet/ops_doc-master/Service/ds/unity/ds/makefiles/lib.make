# lib
# ----------------------------------------------------------------------------
# unity

LIB_UNITY = libunity.a
UNITY_DIR = $(LIB_DIR)/unity
BUILD_UNITY_DIR = $(BUILD_LIB_DIR)/unity

UNITY_SOURCES := $(wildcard $(UNITY_DIR)/*.c)
UNITY_OBJECTS := $(patsubst %, $(BUILD_UNITY_DIR)/%, $(notdir $(UNITY_SOURCES:.c=.o)))


$(BUILD_UNITY_DIR)/$(LIB_UNITY) : $(UNITY_OBJECTS)
	@echo "$(RED)Linking $@ $(NC)"
	$(AR) cr $@ $^ 
	@echo "$(RED)$(LIB_UNITY) is saved at $(BUILD_UNITY_DIR)/$(LIB_UNITY)$(NC)"
	@$(AR) -t $(BUILD_UNITY_DIR)/$(LIB_UNITY)


$(BUILD_UNITY_DIR)/%.o : $(UNITY_DIR)/%.c
	@echo "$(RED)Compiling $< $(NC)"
	$(CC) $(CC_CFLAGS) -c $< -o $@

# ----------------------------------------------------------------------------
# commands

lib_init:
	cp -r $(LIB_DIR)/* $(BUILD_LIB_DIR)/

lib: lib_init $(BUILD_UNITY_DIR)/$(LIB_UNITY)

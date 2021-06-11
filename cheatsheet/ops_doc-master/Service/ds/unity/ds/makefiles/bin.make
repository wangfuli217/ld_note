# bin
# ----------------------------------------------------------------------------
# compiler

BIN_CFLAGS = $(CC_CFLAGS) 

BIN_LDFLAGS = $(CC_LDFLAGS) 

# ----------------------------------------------------------------------------
# commands

BIN_SOURCES := $(wildcard $(BIN_DIR)/*.c)
BIN_OBJECTS := $(patsubst %, $(BUILD_BIN_DIR)/%, $(notdir $(BIN_SOURCES:.c=.o)))
BIN_TARGETS := $(patsubst %, $(BUILD_BIN_DIR)/%, $(notdir $(BIN_OBJECTS:.o=)))

build_bin: $(BIN_TARGETS)

$(BUILD_BIN_DIR)/% : $(BUILD_BIN_DIR)/%.o
	@echo "$(RED)Linking $@ $(NC)"
	$(CC) -o $@ $^ $(SRC_OBJECTS) $(BIN_CFLAGS) $(BIN_LDFLAGS)

$(BUILD_BIN_DIR)/%.o : $(BIN_DIR)/%.c
	@echo "$(RED)Compiling $< $(NC)"
	$(CC) -c $< -o $@ $(BIN_CFLAGS)


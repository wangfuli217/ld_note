# src
# ------------------------------------------------------------------------------------------------

SRC_SOURCES := $(wildcard $(SRC_DIR)/*.c)
SRC_OBJECTS := $(patsubst %, $(BUILD_SRC_DIR)/%, $(notdir $(SRC_SOURCES:.c=.o)))

build_srcs: $(SRC_OBJECTS)

$(BUILD_SRC_DIR)/%.o : $(SRC_DIR)/%.c
	@echo "$(RED)Compiling $< $(NC)"
	$(CC) $(CC_CFLAGS) -c $< -o $@


# GEMM
# ----------------------------------------------------------------------------
# directories

# project dirs
PROJECT_DIR = ds
LIB_DIR = $(PROJECT_DIR)/lib
BIN_DIR = $(PROJECT_DIR)/bin
INC_DIR = $(PROJECT_DIR)/inc
SRC_DIR = $(PROJECT_DIR)/src
TESTS_DIR = $(PROJECT_DIR)/tests

# build dirs
BUILD_DIR = _build
BUILD_LIB_DIR = $(BUILD_DIR)/lib
BUILD_BIN_DIR = $(BUILD_DIR)/bin
BUILD_INC_DIR = $(BUILD_DIR)/inc
BUILD_SRC_DIR = $(BUILD_DIR)/src
BUILD_TESTS_DIR = $(BUILD_DIR)/tests

# ----------------------------------------------------------------------------
# include

include makefiles/lib.make
include makefiles/bin.make
include makefiles/inc.make
include makefiles/src.make
include makefiles/tests.make

# ----------------------------------------------------------------------------
# compiler

CC = gcc

CC_CFLAGS = -I$(INC_DIR) 
CC_LDFLAGS = 

# ----------------------------------------------------------------------------
# console

RED = \033[1;31m
GREEN = \033[1;32m
BLUE = \033[1;34m
YELLOW = \033[1;33m
NC = \033[1;0m

# ----------------------------------------------------------------------------
# commands

init:
	mkdir -p $(BUILD_DIR)
	mkdir -p $(BUILD_LIB_DIR)
	mkdir -p $(BUILD_UNITY_DIR)
	mkdir -p $(BUILD_BIN_DIR)
	mkdir -p $(BUILD_INC_DIR)
	mkdir -p $(BUILD_SRC_DIR)
	mkdir -p $(BUILD_TESTS_DIR)

help:
	@echo "$(RED)Command List:$(NC)"
	@echo "- $(GREEN)all$(NC): run all steps"
	@echo "- $(GREEN)clean$(NC): clean up the build dir"
	@echo "- $(GREEN)dummy$(NC): for testing make commands"


all: clean init inc lib build run

build: build_srcs build_tests build_bin

run: run_tests

clean:
	rm -rf $(BUILD_DIR)

dummy: help
	

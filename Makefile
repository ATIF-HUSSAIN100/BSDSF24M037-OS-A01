# ============================================================
# Makefile for Multi-file Project (Part 2)
# ============================================================

CC = gcc
CFLAGS = -Wall -Wextra -g -Iinclude
LDFLAGS = 

SRC_DIR = src
INC_DIR = include
OBJ_DIR = obj
BIN_DIR = bin

TARGET = $(BIN_DIR)/client

SRCS = $(wildcard $(SRC_DIR)/*.c)
OBJS = $(SRCS:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)

all: $(TARGET)

$(TARGET): $(OBJS)
	@mkdir -p $(BIN_DIR)
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)
	@echo "✓ Built: $@"

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@
	@echo "✓ Compiled: $< -> $@"

run: all
	./$(TARGET)

clean:
	rm -f $(OBJ_DIR)/*.o $(TARGET)
	@echo "✓ Cleaned"

.PHONY: all run clean

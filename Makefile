# ============================================================
# Makefile for Dynamic Library Build (Part 4)
# ============================================================

CC = gcc
CFLAGS = -Wall -Wextra -g -Iinclude
CFLAGS_PIC = -Wall -Wextra -g -Iinclude -fPIC
AR = ar
ARFLAGS = rcs
LDFLAGS =
LDFLAGS_SO = -shared

SRC_DIR = src
INC_DIR = include
OBJ_DIR = obj
BIN_DIR = bin
LIB_DIR = lib

STATIC_LIB = $(LIB_DIR)/libmyutils.a
STATIC_TARGET = $(BIN_DIR)/client_static

DYNAMIC_LIB = $(LIB_DIR)/libmyutils.so
DYNAMIC_TARGET = $(BIN_DIR)/client_dynamic

LIB_SRCS = $(filter-out $(SRC_DIR)/main.c, $(wildcard $(SRC_DIR)/*.c))
LIB_OBJS = $(LIB_SRCS:$(SRC_DIR)/%.c=$(OBJ_DIR)/%.o)
LIB_OBJS_PIC = $(LIB_SRCS:$(SRC_DIR)/%.c=$(OBJ_DIR)/%_pic.o)
MAIN_OBJ = $(OBJ_DIR)/main.o

all: $(STATIC_TARGET) $(DYNAMIC_TARGET)

$(STATIC_LIB): $(LIB_OBJS)
	@mkdir -p $(LIB_DIR)
	$(AR) $(ARFLAGS) $@ $^
	@echo "✓ Created static library: $@"

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c
	@mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@
	@echo "✓ Compiled: $< -> $@"

$(STATIC_TARGET): $(MAIN_OBJ) $(STATIC_LIB)
	@mkdir -p $(BIN_DIR)
	$(CC) $(CFLAGS) -o $@ $(MAIN_OBJ) -L$(LIB_DIR) -lmyutils $(LDFLAGS)
	@echo "✓ Linked static: $@"

$(DYNAMIC_LIB): $(LIB_OBJS_PIC)
	@mkdir -p $(LIB_DIR)
	$(CC) $(LDFLAGS_SO) -o $@ $^
	@echo "✓ Created dynamic library: $@"

$(OBJ_DIR)/%_pic.o: $(SRC_DIR)/%.c
	@mkdir -p $(OBJ_DIR)
	$(CC) $(CFLAGS_PIC) -c $< -o $@
	@echo "✓ Compiled (PIC): $< -> $@"

$(DYNAMIC_TARGET): $(MAIN_OBJ) $(DYNAMIC_LIB)
	@mkdir -p $(BIN_DIR)
	$(CC) $(CFLAGS) -o $@ $(MAIN_OBJ) -L$(LIB_DIR) -lmyutils $(LDFLAGS)
	@echo "✓ Linked dynamic: $@"

run-static: $(STATIC_TARGET)
	./$(STATIC_TARGET)

run-dynamic: $(DYNAMIC_TARGET)
	LD_LIBRARY_PATH=$(LIB_DIR) ./$(DYNAMIC_TARGET)

analyze: all
	@echo "=== File sizes ==="
	ls -lh $(BIN_DIR)/
	@echo ""
	@echo "=== ldd on client_dynamic ==="
	ldd $(DYNAMIC_TARGET) || true
	@echo ""
	@echo "=== nm -D on libmyutils.so ==="
	nm -D $(DYNAMIC_LIB)

clean:
	rm -f $(OBJ_DIR)/*.o $(STATIC_LIB) $(DYNAMIC_LIB) $(STATIC_TARGET) $(DYNAMIC_TARGET)
	@echo "✓ Cleaned"

.PHONY: all run-static run-dynamic analyze clean install uninstall
# --- Install ---
PREFIX = /usr/local
BINDIR = $(PREFIX)/bin
MANDIR = $(PREFIX)/share/man/man3

install: $(DYNAMIC_TARGET)
	@echo "Installing client to $(BINDIR)..."
	install -d $(DESTDIR)$(BINDIR)
	install -m 755 $(DYNAMIC_TARGET) $(DESTDIR)$(BINDIR)/client
	@echo "Installing man pages to $(MANDIR)..."
	install -d $(DESTDIR)$(MANDIR)
	install -m 644 man/man3/*.3 $(DESTDIR)$(MANDIR)/
	@echo "✓ Installation complete"

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/client
	rm -f $(DESTDIR)$(MANDIR)/*.3
	@echo "✓ Uninstalled"

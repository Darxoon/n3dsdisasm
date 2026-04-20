CAPSTONE_DIR := capstone

$(info $(OS))
ifeq ($(OS), Windows_NT)
CAPSTONE_LIB := $(CAPSTONE_DIR)/capstone.lib
else
CAPSTONE_LIB := $(CAPSTONE_DIR)/libcapstone.a
endif
$(info $(CAPSTONE_LIB))

DEBUG ?= 0
CAPSTONE_DEBUG ?= 0

CC := gcc
CFLAGS := -isystem $(CAPSTONE_DIR)/include -Wall -Wextra -Wpedantic -Wno-missing-field-initializers
ifeq ($(DEBUG),1)
CFLAGS += -O0 -g -fsanitize=address
else
CFLAGS += -O3
endif
PROGRAM := n3dsdisasm
SOURCES := main.c disasm.c
LIBS := $(CAPSTONE_LIB)

ifeq ($(CAPSTONE_DEBUG),1)
CAPSTONE_CFLAGS := -O1 -g -fcanon-prefix-map -ffile-prefix-map="$(shell pwd)"=. -fdebug-prefix-map="$(shell pwd)"=.
endif

# Compile the program
$(PROGRAM): $(SOURCES) $(CAPSTONE_LIB)
	$(CC) $(CFLAGS) $^ -o $@

# Build libcapstone
$(CAPSTONE_LIB): $(CAPSTONE_DIR)
	make -C $(CAPSTONE_DIR) CAPSTONE_STATIC=yes CAPSTONE_SHARED=no CAPSTONE_ARCHS="arm" CAPSTONE_BUILD_CORE_ONLY=yes CAPSTONE_CFLAGS='$(CAPSTONE_CFLAGS)'

clean:
	$(RM) $(PROGRAM) $(PROGRAM).exe

distclean: clean
	make -C $(CAPSTONE_DIR) clean

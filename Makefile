LINUX_CXX := clang++
LINUX_CC  := clang
LINUX_AR  := llvm-ar

ifneq ($(OS),Windows_NT)
	WINDOWS_CXX := x86_64-w64-mingw32-g++
	WINDOWS_CC  := x86_64-w64-mingw32-gcc
	WINDOWS_AR  := x86_64-w64-mingw32-ar
else
	WINDOWS_CXX := g++
	WINDOWS_CC  := gcc
	WINDOWS_AR  := ar
endif

FLAGS_DEBUG_COMMON    := -g -Wall -O0 -D DEBUGGING
FLAGS_DEBUG_LINUX     := -fsanitize=address
FLAGS_DEBUG_WINDOWS   := # Nothing yet
FLAGS_RELEASE_COMMON  := -O3
FLAGS_RELEASE_WINDOWS := # Nothing yet
FLAGS_RELEASE_LINUX   := # Nothing yet
FLAGS_CXX_COMMON      := -std=c++20
FLAGS_CC_COMMON       := # Nothing yet
FLAGS_WINDOWS         := -mwindows -static
FLAGS_LINUX           := # Nothing yet
LDFLAGS_LINUX         := # Nothing yet
LDFLAGS_WINDOWS       := # Nothing yet
DYNAMIC_FLAGS_LINUX   := -shared
DYNAMIC_FLAGS_WINDOWS := -shared --out-implib

INCLUDE := -I src

DIR_ROOT    := build
DIR_LINUX   := Linux
DIR_WINDOWS := Windows
DIR_STATIC  := Static
DIR_DYNAMIC := Dynamic
DIR_OBJS    := .objs

NAME_BASE := getargs

# LINUX
ifneq ($(OS),Windows_NT)
	export BINARY_NAME   ?= $(NAME_BASE)_example
	export STATIC_NAME   ?= lib$(NAME_BASE).a
	export DYNAMIC_NAME  ?= lib$(NAME_BASE).so
	export BUILD_ARCH    ?= $(DIR_LINUX)
	export DEBUG_FLAGS   ?= $(FLAGS_DEBUG_COMMON) $(FLAGS_DEBUG_LINUX)
	export RELEASE_FLAGS ?= $(FLAGS_RELEASE_COMMON) $(FLAGS_RELEASE_LINUX)
	export CXX_FLAGS     ?= $(FLAGS_CXX_COMMON) $(FLAGS_LINUX)
	export CC_FLAGS      ?= $(FLAGS_CC_COMMON) $(FLAGS_LINUX)
	export LD_FLAGS      ?= $(LDFLAGS_LINUX)
	export CXX_COMPILER  ?= $(LINUX_CXX)
	export C_COMPILER    ?= $(LINUX_CC)
	export AR_BUILDER    ?= $(LINUX_AR)
	export DYNAMIC_FLAGS ?= $(DYNAMIC_FLAGS_LINUX)
else # WINDOWS
	export BINARY_NAME   ?= $(NAME_BASE)_example.exe
	export STATIC_NAME   ?= lib$(NAME_BASE).a
	export DYNAMIC_NAME  ?= lib$(NAME_BASE).dll
	export BUILD_ARCH    ?= $(DIR_WINDOWS)
	export DEBUG_FLAGS   ?= $(FLAGS_DEBUG_COMMON) $(FLAGS_DEBUG_WINDOWS)
	export RELEASE_FLAGS ?= $(FLAGS_RELEASE_COMMON) $(FLAGS_RELEASE_WINDOWS)
	export CXX_FLAGS     ?= $(FLAGS_CXX_COMMON) $(FLAGS_WINDOWS)
	export CC_FLAGS      ?= $(FLAGS_CC_COMMON) $(FLAGS_WINDOWS)
	export LD_FLAGS      ?= $(LDFLAGS_WINDOWS)
	export CXX_COMPILER  ?= $(WINDOWS_CXX)
	export C_COMPILER    ?= $(WINDOWS_CC)
	export AR_BUILDER    ?= $(WINDOWS_AR)
	export DYNAMIC_FLAGS ?= $(DYNAMIC_FLAGS_WINDOWS)
endif

export BUILD_VERSION ?= $(DIR_STATIC)
export VERSION_FLAGS ?= $(RELEASE_FLAGS)

export BUILD_DIR  ?= $(DIR_ROOT)/$(BUILD_ARCH)/$(BUILD_VERSION)
export BUILD_OBJS ?= $(BUILD_DIR)/$(DIR_OBJS)

export NAME ?= $(STATIC_NAME)

VPATH := $(SRC_DIRS)

SRC := src

SRC_DIRS := $(SRC)/argument_parser

CC_SRCS  := $(foreach directory,$(SRC_DIRS),$(wildcard $(directory)/*.c))
CXX_SRCS := $(foreach directory,$(SRC_DIRS),$(wildcard $(directory)/*.cpp))

export CC_OBJS  ?= $(addprefix $(BUILD_OBJS)/,$(subst .c,.o,$(CC_SRCS:$(SRC)/%=%)))
export CXX_OBJS ?= $(addprefix $(BUILD_OBJS)/,$(subst .cpp,.obj,$(CXX_SRCS:$(SRC)/%=%)))

BINARY_SRC_DIR := $(SRC)/example_main

BINARY_SRCS := $(foreach directory,$(BINARY_SRC_DIR),$(wildcard $(directory)/*.cpp))
BINARY_OBJS := $(addprefix $(BUILD_OBJS)/,$(subst .cpp,.obj,$(BINARY_SRCS:$(SRC)/%=%)))

export RESET   ?= \\x1b[0m
export BLACK   ?= \\x1b[1;30m
export RED     ?= \\x1b[1;31m
export GREEN   ?= \\x1b[1;32m
export YELLOW  ?= \\x1b[1;33m
export BLUE    ?= \\x1b[1;34m
export MAGENTA ?= \\x1b[1;35m
export CYAN    ?= \\x1b[1;36m
export WHITE   ?= \\x1b[1;37m
export DEFAULT ?= \\x1b[1;39m

.PHONY: build static_example dynamic_example static dynamic linux windows build_dir clean disable_colors

build:
	@ printf "$(DEFAULT)::Architecture - $(BLUE)$(BUILD_ARCH)$(RESET)\n"
	@ printf "$(DEFAULT)::Version - $(BLUE)$(BUILD_VERSION)$(RESET)\n"
	@ printf "$(DEFAULT)::Target Binary - $(BLUE)$(BUILD_DIR)/$(NAME)$(RESET)\n"
	@ printf "$(DEFAULT)::C Compile Command - $(YELLOW)$(C_COMPILER) $(CC_FLAGS) $(VERSION_FLAGS) $(INCLUDE)$(RESET)\n"
	@ printf "$(DEFAULT)::C++ Compile Command - $(YELLOW)$(CXX_COMPILER) $(CXX_FLAGS) $(VERSION_FLAGS) $(INCLUDE)$(RESET)\n"
	@ printf "$(DEFAULT)::Static Library Building Command - $(YELLOW)$(AR_BUILDER) cr $(RESET)\n"
	@ printf "$(DEFAULT)::Dynamic Library Building Command - $(YELLOW)$(CXX_COMPILER) $(CXX_FLAGS) $(LD_FLAGS)$(RESET)\n"
	@ $(MAKE) -s $(BUILD_DIR)/$(NAME)
	@ printf "$(DEFAULT)::Program Location - $(GREEN)$(DIR_ROOT)/$(BUILD_ARCH)/$(BUILD_VERSION)/$(NAME)$(RESET)\n"

static_example:
	$(eval NAME = $(BINARY_NAME))
	@ printf "$(DEFAULT)::Building Example - $(BLUE)$(BUILD_DIR)/$(NAME)$(RESET)\n"

dynamic_example:
	$(eval NAME = $(BINARY_NAME))
	@ printf "$(DEFAULT)::Building Example - $(BLUE)$(BUILD_DIR)/$(NAME)$(RESET)\n"
	$(CXX_COMPILER) $(CXX_FLAGS) $(INCLUDE) $(SRC)/example_main/dedicated_main.cpp -o $(BUILD_DIR)/$(NAME) -L $(BUILD_DIR) -l$(NAME_BASE)
	@ printf "$(DEFAULT)[NOTE] You'll have to copy $(GREEN)$(DYNAMIC_NAME)$(DEFAULT) to $(BLUE)/usr/lib$(DEFAULT) for the app to be able to use the library$(RESET)\n"

static: ;@:
	$(eval FLAGS_CXX_COMMON = -std=c++20)
	$(eval NAME = $(STATIC_NAME))
	$(eval BUILD_VERSION = $(DIR_STATIC))

dynamic: ;@:
	$(eval FLAGS_CXX_COMMON = -std=c++20 -fPIC)
	$(eval NAME = $(DYNAMIC_NAME))
	$(eval BUILD_VERSION = $(DIR_DYNAMIC))

linux: ;@:
	$(eval BINARY_NAME   = $(NAME_BASE))
	$(eval STATIC_NAME   = lib$(NAME_BASE).a)
	$(eval DYNAMIC_NAME  = lib$(NAME_BASE).so)
	$(eval BUILD_ARCH    = $(DIR_LINUX))
	$(eval DEBUG_FLAGS   = $(FLAGS_DEBUG_COMMON) $(FLAGS_DEBUG_LINUX))
	$(eval RELEASE_FLAGS = $(FLAGS_RELEASE_COMMON) $(FLAGS_RELEASE_LINUX))
	$(eval CXX_FLAGS     = $(FLAGS_CXX_COMMON) $(FLAGS_LINUX))
	$(eval CC_FLAGS      = $(FLAGS_CC_COMMON) $(FLAGS_LINUX))
	$(eval LD_FLAGS      = $(LDFLAGS_LINUX))
	$(eval CXX_COMPILER  = $(LINUX_CXX))
	$(eval C_COMPILER    = $(LINUX_CC))
	$(eval AR_BUILDER    = $(LINUX_AR))
	$(eval DYNAMIC_FLAGS = $(DYNAMIC_FLAGS_LINUX))

windows: ;@:
	$(eval BINARY_NAME   = $(NAME_BASE).exe)
	$(eval STATIC_NAME   = lib$(NAME_BASE).a)
	$(eval DYNAMIC_NAME  = lib$(NAME_BASE).dll)
	$(eval BUILD_ARCH    = $(DIR_WINDOWS))
	$(eval DEBUG_FLAGS   = $(FLAGS_DEBUG_COMMON) $(FLAGS_DEBUG_WINDOWS))
	$(eval RELEASE_FLAGS = $(FLAGS_RELEASE_COMMON) $(FLAGS_RELEASE_WINDOWS))
	$(eval CXX_FLAGS     = $(FLAGS_CXX_COMMON) $(FLAGS_WINDOWS))
	$(eval CC_FLAGS      = $(FLAGS_CC_COMMON) $(FLAGS_WINDOWS))
	$(eval LD_FLAGS      = $(LDFLAGS_WINDOWS))
	$(eval CXX_COMPILER  = $(WINDOWS_CXX))
	$(eval C_COMPILER    = $(WINDOWS_CC))
	$(eval AR_BUILDER    = $(WINDOWS_AR))
	$(eval DYNAMIC_FLAGS = $(DYNAMIC_FLAGS_WINDOWS))

build_dir:
	@ -mkdir -p $(BUILD_DIR) $(BUILD_OBJS)

clean:
	@ -rm -rf $(DIR_ROOT)
	@ printf "::Cleaned $(RED)$(DIR_ROOT)/$(RESET)\n"

disable_colors:
	$(eval RESET   := "")
	$(eval BLACK   := "")
	$(eval RED     := "")
	$(eval GREEN   := "")
	$(eval YELLOW  := "")
	$(eval BLUE    := "")
	$(eval MAGENTA := "")
	$(eval CYAN    := "")
	$(eval WHITE   := "")
	$(eval DEFAULT := "")
	@ printf "::Output colors disabled\n"

# C++ Object Files
$(BUILD_OBJS)/%.obj: $(SRC)/%.cpp | build_dir
	@ printf "::Compiling $(BLUE)$@$(RESET)\n"
	@ -mkdir -p $(dir $@)
	$(CXX_COMPILER) $(CXX_FLAGS) $(VERSION_FLAGS) $(INCLUDE) -c $< -o $@

# C Object Files (unused)
$(BUILD_OBJS)/%.o: $(SRC)/%.c | build_dir
	@ printf "::Compiling $(BLUE)$@$(RESET)\n"
	@ -mkdir -p $(dir $@)
	$(C_COMPILER) $(CC_FLAGS) $(VERSION_FLAGS) $(INCLUDE) -c $< -o $@

# Dynamic Library
$(BUILD_DIR)/$(DYNAMIC_NAME): $(CC_OBJS) $(CXX_OBJS)
	@ printf "::Building $(CYAN)$@$(RESET)\n"
	$(CXX_COMPILER) $(CXX_FLAGS) $(DYNAMIC_FLAGS) $^ -o $@ $(LD_FLAGS)

# Static Library
$(BUILD_DIR)/$(STATIC_NAME): $(CC_OBJS) $(CXX_OBJS)
	@ printf "::Building $(CYAN)$@$(RESET)\n"
	$(AR_BUILDER) cr $@ $^

# Example Binary
$(BUILD_DIR)/$(BINARY_NAME): $(SRC)/example_main/dedicated_main.cpp
	$(CXX_COMPILER) $(CXX_FLAGS) $(INCLUDE) $< -o $(BUILD_DIR)/$(NAME) -L $(BUILD_DIR) -l$(NAME_BASE)

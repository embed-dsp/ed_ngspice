
# Copyright (c) 2022-2024 embed-dsp, All Rights Reserved.
# Author: Gudmundur Bogason <gb@embed-dsp.com>


PACKAGE_NAME = ngspice
PACKAGE_VERSION = 42
PACKAGE = $(PACKAGE_NAME)-$(PACKAGE_VERSION)

# ==============================================================================

# Determine system.
SYSTEM = unknown
ifeq ($(findstring Linux, $(shell uname -s)), Linux)
	SYSTEM = linux
endif
ifeq ($(findstring MINGW32, $(shell uname -s)), MINGW32)
	SYSTEM = mingw32
endif
ifeq ($(findstring MINGW64, $(shell uname -s)), MINGW64)
	SYSTEM = mingw64
endif

# Determine machine.
MACHINE = $(shell uname -m)

# Architecture.
ARCH = $(SYSTEM)_$(MACHINE)

# ==============================================================================

# Set number of simultaneous jobs (Default 8)
ifeq ($(J),)
	J = 8
endif

#   sudo dnf install libXaw-devel
# --enable-openmp
# --enable-adms
# --enable-oldapps
# --enable-relpath

CONFIGURE_FLAGS = --disable-debug --enable-xspice

# Configuration for linux system.
ifeq ($(SYSTEM),linux)
	# Compiler.
	CC = /usr/bin/gcc
	CXX = /usr/bin/g++

	ifeq ($(LIB),)
		CONFIGURE_FLAGS += --with-readline=yes --with-x
	else
		CONFIGURE_FLAGS += --with-ngshared
	endif

	# Installation directory.
	INSTALL_DIR = /opt
endif

# FIXME: Configuration for mingw64 system.
# ifeq ($(SYSTEM),mingw64)
# 	# Compiler.
# 	CC = /mingw64/bin/gcc
# 	CXX = /mingw64/bin/g++
# 	# Installation directory.
# 	INSTALL_DIR = /c/opt
# 	CONFIGURE_FLAGS = --with-wingui
# endif

# Installation directory.
# PREFIX = $(INSTALL_DIR)/$(PACKAGE_NAME)/$(PACKAGE)
PREFIX = $(INSTALL_DIR)/$(PACKAGE_NAME)/$(ARCH)/$(PACKAGE)

ifeq ($(LIB),)
else
PREFIX := $(PREFIX)-lib
endif

# EXEC_PREFIX = $(PREFIX)/$(ARCH)

# ==============================================================================

all:
	@echo "ARCH        = $(ARCH)"
	@echo "PREFIX      = $(PREFIX)"
#	@echo "EXEC_PREFIX = $(EXEC_PREFIX)"
	@echo ""
	@echo "## Get Source Code"
	@echo "make download"
	@echo ""
	@echo "## Build"
	@echo "make prepare"
	@echo "make configure [LIB=1]"
	@echo "make compile [J=...]"
	@echo ""
	@echo "## Install"
	@echo "[sudo] make install"
	@echo ""
	@echo "## Cleanup"
	@echo "make clean"
	@echo "make distclean"
	@echo ""


.PHONY: download
download:
	-mkdir src
	cd src && wget -nc https://sourceforge.net/projects/ngspice/files/ng-spice-rework/$(PACKAGE_VERSION)/$(PACKAGE).tar.gz


.PHONY: prepare
prepare:
	-mkdir build
	cd build && tar zxf ../src/$(PACKAGE).tar.gz


.PHONY: configure
configure:
	cd build/$(PACKAGE) && ./configure CC=$(CC) --prefix=$(PREFIX) $(CONFIGURE_FLAGS)
#	cd build/$(PACKAGE) && ./configure CC=$(CC) --prefix=$(PREFIX) --exec_prefix=$(EXEC_PREFIX) $(CONFIGURE_FLAGS)


.PHONY: compile
compile:
	cd build/$(PACKAGE) && make -j$(J)


.PHONY: install
install:
	cd build/$(PACKAGE) && make install


.PHONY: clean
clean:
	cd build/$(PACKAGE) && make clean


.PHONY: distclean
distclean:
	cd build/$(PACKAGE) && make distclean


# Compile and Install of the Ngspice circuit simulator

This repository contains a **make** file for easy compile and install of [Ngspice](https://ngspice.sourceforge.io).

Ngspice is the open source spice simulator for electric and electronic circuits.

This **make** file can build the Ngspice tool on the following systems:
* Linux


# Get Source Code

## ed_ngspice

```bash
git clone https://github.com/embed-dsp/ed_ngspice.git
```

## Ngspice

```bash
# Enter the ed_ngspice directory.
cd ed_ngspice

# Edit the Makefile for selecting the Ngspice source version.
vim Makefile
PACKAGE_VERSION = 38
```

```bash
# Download Ngspice source package into src/ directory.
make download
```


# Build

```bash
# Unpack source code into build/ directory.
make prepare
```

```bash
# Configure source code.
make configure

# Configure source code for a shared library instead of an application.
make configure LIB=1
```

```bash
# Compile source code.
make compile
```


# Install

```bash
# Install build products.
sudo make install
```

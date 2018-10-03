# Binary Checker

**Binary Checker** (or **BinCheck**) is a tool made to check if your 
**Sega Dreamcast** homebrew binary in `.BIN` format is in scrambled or
unscrambled state.

It was firstly released on **July 10, 2005**.

# Introduction

A `.BIN` file is a compiled program for your **Sega Dreamcast**, it's those
that you can get most of time in packages labeled "plain files". Scrambled state
files are used when the binary is meant to be booted from a **CD-ROM**, i.e. 
when the homebrew program is started from the bootstrap, often called `IP.BIN`. 

Such bootable programs are commonly named `1ST_READ.BIN`. The unscrambled state
for binaries, meanwhile, is used in all other cases (e.g. a binary executable
started from another binary). Please note the scrambled/unscrambled state notion
is **ONLY** used for homebrews programs, i.e. programs compiled with homemade
toolchains. This notion doesn't apply for binaries produced with the official
**Katana** toolchain.

# Usage

1. Compile the `library` project. This will produces the `bincheck.dll` file.
2. Compile the `checker` project. This will produces the `checker.exe` file.
3. Run the `checker.exe` program then select the `.BIN` file to test, and hit the
`Test!` button.

# Credits

This library/program is a port of the **Visual Studio 6** project made by
**Fackue**/**LyingWake**.
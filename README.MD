# VGA_DEMO

A smattering of code for experimenting with VGA in Assembly. The code is
designed to be run in DOSBox or native 32- or 16-bit hardware running
Windows or DOS.

## Building

NASM and MinGW (for mingw32-make.exe) should be in the path.

ALINK is used for linking and should be copied into ALINK directory one
level up from the code checkout. Otherwise update MAKEFILE to use a
different linker or ALINK in a different location.

## Standards

Functions are generally built to take inputs in AX or AH/AL. Where that
is impossible, the stack is used.

The callee is responsible for cleaning up the stack before returning,
in the case that it accepts data on the stack.

When a function returns a value, it will do so in:

* AL for 8-bit values
* AX for 16-bit values or near pointers
* DX:AX for far pointers

AX, CX, and DX are considered volatile. The callee must preserve all
other registers.
# VGA_DEMO

A smattering of code for experimenting with VGA in Assembly. The code is
designed to be run in DOSBox or native 16- or 32-bit hardware running
Windows or DOS.

## Building

NASM and MinGW (for mingw32-make.exe) should be in the path.

[ALINK][alink-download] is used for linking and should be copied into
ALINK directory one level up from the code checkout. Otherwise update
[Makefile](Makefile) to use a different linker or ALINK in a different
location.

Some linker recommendations are given in the [NASM Docs][nasm-linker].
Any linker which can produce a 16-bit DOS EXE from .obj files should
work.

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

[alink-download]: http://alink.sourceforge.net/download.html
[nasm-linker]: https://www.nasm.us/xdoc/2.14.02/html/nasmdoc8.html#section-8.1.1

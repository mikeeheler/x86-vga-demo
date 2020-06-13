VGA_DEMO_SRCS=$(wildcard VGA*.ASM)
VGA_DEMO_OBJS=$(VGA_DEMO_SRCS:%.ASM=%.OBJ)

.PHONY: all clean

all: VGA_DEMO.EXE

clean:
    del /F *.EXE *.OBJ

VGA_DEMO.EXE: $(VGA_DEMO_OBJS)
    ../ALINK/ALINK.EXE -oEXE -o $@ $(VGA_DEMO_OBJS)

%.OBJ: %.ASM
    nasm -fobj -gborland -I. -o $@ $<

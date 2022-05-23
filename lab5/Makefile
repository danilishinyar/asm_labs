CROSS_COMPILE ?= aarch64-linux-gnu-

PREFIX = /opt/gcc-linaro-7.5.0-2019.12-x86_64_aarch64-linux-gnu
LIBPATH = -L $(PREFIX)/lib/gcc/aarch64-linux-gnu/7.5.0 -L $(PREFIX)/aarch64-linux-gnu/libc/usr/lib
OBJPATH = $(PREFIX)/aarch64-linux-gnu/libc/usr/lib
LIBS = -lgcc -lgcc_eh -lc
PREOBJ = $(OBJPATH)/crt1.o $(OBJPATH)/crti.o
POSTOBJ = $(OBJPATH)/crtn.o

CC = $(CROSS_COMPILE)gcc
AS = $(CROSS_COMPILE)as
LD = $(CROSS_COMPILE)ld

CCFLAGS = -g -c -O3
ASFLAGS = -g
LDFLAGS = -g -static

SRCS = lab5asm.s lab5c.c
HEAD = lab5.h
OBJS = lab5asm.o lab5c.o

EXE = prog

all: $(SRCS) $(EXE)

clean:
	rm -rf $(EXE) $(OBJS)

$(OBJS): $(HEAD)

$(EXE): $(OBJS)
	$(LD) $(LDFLAGS) $(LIBPATH) $(PREOBJ) $(OBJS) $(POSTOBJ) -\( $(LIBS) -\) -o $@ -lm

.c.o:
	$(CC) $(CCFLAGS) $< -o $@ -lm

.s.o:
	$(AS) $(ASFLAGS) $< -o $@

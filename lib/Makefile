CROSS_COMPILE ?= aarch64-linux-gnu-

AS = $(CROSS_COMPILE)as
LD = $(CROSS_COMPILE)ld

ASFLAGS = -g
LDFLAGS = -g -r -o

SRCS = $(wildcard *.s)
OBJS = $(SRCS:.s=.o)

all: $(OBJS)
	$(LD) $(LDFLAGS) lib.o $(OBJS)

.s.o:
	$(AS) $(ASFLAGS) $< -o $@

clean:
	rm -f $(OBJS) lib.o

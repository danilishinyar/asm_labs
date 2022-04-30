CROSS_COMPILE ?= aarch64-linux-gnu-

AS = $(CROSS_COMPILE)as
LD = $(CROSS_COMPILE)ld

ASFLAGS = -g -r
LDFLAGS = -r -o

SRCS = $(wildcard *.s)
OBJS = $(SRCS:.s=.o)

all: $(OBJS)
	$(LD) $(LDFLAGS) lib.o $(OBJS)

$(OBJS):
	$(AS) $(ASFLAGS) $(patsubst %.o,%.s,$@) -o $(patsubst %.s, %.o, $@)

clean:
	rm -f $(OBJS) lib.o

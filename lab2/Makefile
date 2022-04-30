CROSS_COMPILE ?= aarch64-linux-gnu-

AS = $(CROSS_COMPILE)as
LD = $(CROSS_COMPILE)ld
flag = 0


ifeq ($(flag), inc)
	ASFLAGS = -g -defsym order=1
	LDFLAGS = -g -static
else
	ifeq ($(flag), dec)
		ASFLAGS = -g -defsym order=0
		LDFLAGS = -g -static
	else
$(error Use flag=inc or flag=dec to sort in ascending or descending order respectively)
	endif
endif


SRCS = prog2.s
OBJS = $(SRCS:.s=.o)

EXE = prog2

all: $(SRCS) $(EXE)

.PHONY: clean

clean:
	rm -rf $(EXE) $(OBJS)

$(EXE): $(OBJS)
	$(LD) $(LDFLAGS) $(OBJS) -o $@

.s.o:
	$(AS) $(ASFLAGS) $< -o $@

SRCS = defs.cc graph.cc partition.cc orbit.cc uintseqhash.cc heap.cc
SRCS += timer.cc utils.cc bliss_C.cc bliss.cc

OBJS = $(addsuffix .o, $(basename $(SRCS)))

CLEAN_TARGETS = bliss.exe bliss $(OBJS)

ifeq ($(OS),Windows_NT)
	CFLAGS = /EHsc
	CFLAGS += /I.
	CC = cl
	LINK = link

	COMPILE_CMD = $(CC) $(CFLAGS) /c $< /Fo$@
	LINK_CMD = $(LINK) /Out:bliss.exe $(OBJS)
	CLEAN_CMD = del $(CLEAN_TARGETS) 2>NUL
else
	CFLAGS = -I.
	CFLAGS += -g
	CFLAGS += -Wall
	CFLAGS += --pedantic
	CFLAGS += -O9
	CFLAGS += -fPIC
	CC = g++
	LINK = g++

	COMPILE_CMD = $(CC) $(CFLAGS) -c -o $@ $<
	LINK_CMD = $(LINK) $(CFLAGS) -o bliss $(OBJS)
	CLEAN_CMD = rm -f $(CLEAN_TARGETS)
endif

all:: bliss

%.o: %.cc
	$(COMPILE_CMD)

bliss: $(OBJS)
	$(LINK_CMD)

clean:
	$(CLEAN_CMD)

# DO NOT DELETE

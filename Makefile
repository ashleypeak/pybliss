include Makefile.common

CFLAGS = -I.
CFLAGS += -g
CFLAGS += -Wall
CFLAGS += --pedantic
CFLAGS += -O9
CFLAGS += -fPIC
CC = g++
LINK = g++
RANLIB = ranlib
AR = ar

all:: lib bliss

%.o: %.cc
	$(CC) $(CFLAGS) -c -o $@ $<

lib: $(OBJS_LIB)
	rm -f $(BLISSLIB)
	$(AR) cr $(BLISSLIB) $(OBJS_LIB)
	$(RANLIB) $(BLISSLIB)

bliss: $(OBJS_EXE)
	$(LINK) $(CFLAGS) -o bliss $(OBJS_EXE)

clean:
	rm -f $(CLEAN_TARGETS)

# DO NOT DELETE

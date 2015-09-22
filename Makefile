#! /usr/bin/make

.NULL: .exe

SOURCES = $(wildcard *.cpp)   # $(wildcard *.c)
HEADERS = $(wildcard *.h)
TARGETS = $(basename $(SOURCES))

INIT_SHADER = ../../Common/InitShader.o

uname_S := $(shell sh -c 'uname -s 2>/dev/null || echo not')

# Linux (default)
#LDLIBS = -lglut -lGL -lXmu -lX11  -lm
LDDIRS = -L.
LDLIBS = -lassimp -lGLEW -lglut -lGL -lXmu -lX11  -lm -Wl,-rpath,. #-rpath,../../lib/linux

#windows 
ifneq (,$(findstring MINGW,$(uname_S)))
	CXXDEFS = -DFREEGLUT_STATIC -DGLEW_STATIC
	LDDIRS = -L../../lib/windows
	LDLIBS = -lassimp -lfreeglut_static -lglew32 -lopengl32 -lgdi32 -lwinmm -Wl,--subsystem,windows 
endif

CXXINCS = -I../../include -I../../assimp-3.1.1/include
CXXFLAGS = $(CXXOPTS) $(CXXDEFS) $(CXXINCS) -Wall -fpermissive -O3 -g
LDFLAGS = $(LDOPTS) $(LDDIRS) $(LDLIBS)

DIRT = $(wildcard *.o *.i *~ */*~ *.log *.exe)

#-----------------------------------------------------------------------------

.PHONY: Makefile gnatidread.h

default all: $(TARGETS)

$(TARGETS): $(INIT_SHADER)

%: %.cpp gnatidread.h
	$(CXX) $(CXXFLAGS) $@.cpp $(INIT_SHADER) bitmap.c $(LDFLAGS) -o $@


%: %.c 
	gcc $(CXXFLAGS) $^ $(LDFLAGS) -o $@

#-----------------------------------------------------------------------------

%.i: %.cpp
	$(CXX) -E $(CXXFLAGS) $< | uniq > $@

#-----------------------------------------------------------------------------

clean:
	$(RM) $(DIRT)

rmtargets:
	$(RM) $(TARGETS) $(INIT_SHADER)

clobber: clean rmtargets

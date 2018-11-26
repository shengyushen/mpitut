EXECS = hello.exe sendrecv.exe barrier.exe bcast.exe scatter.exe gather.exe
MPICC?=mpicc

.DEFAULT_GOAL := all

all: ${EXECS}

%.exe : %.c
	${MPICC} -o $@ $<

.PHONY: clean

clean:
	rm -f ${EXECS}

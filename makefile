EXECS = hello.exe sendrecv.exe barrier.exe bcast.exe scatter.exe gather.exe reduce.exe mpiomp.exe mpionly.exe mpi2mpi.exe mpi2mpi_vader.exe
MPICC?=mpicc

.DEFAULT_GOAL := all

all: ${EXECS}

%.exe : %.c
	${MPICC} -fopenmp -o $@ $<

.PHONY: clean

clean:
	rm -f ${EXECS}

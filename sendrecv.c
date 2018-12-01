// Author: Wes Kendall
// Copyright 2011 www.mpitutorial.com
// This code is provided freely with the tutorials on mpitutorial.com. Feel
// free to modify it for your own use. Any distribution of the code must
// either provide a link to www.mpitutorial.com or keep this header intact.
//
// An intro MPI hello world program that uses MPI_Init, MPI_Comm_size,
// MPI_Comm_rank, MPI_Finalize, and MPI_Get_processor_name.
//
#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char** argv) {
  // Initialize the MPI environment. The two arguments to MPI Init are not
  // currently used by MPI implementations, but are there in case future
  // implementations might need the arguments.
  MPI_Init(NULL, NULL);

  // Get the number of processes
  int world_size;
  MPI_Comm_size(MPI_COMM_WORLD, &world_size);
	//printf("process number %d\n",world_size);

  // Get the rank of the process
  int world_rank;
  MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);
	//printf("current process %d\n",world_rank);

  // Get the name of the processor
  char processor_name[MPI_MAX_PROCESSOR_NAME];
  int name_len;
  MPI_Get_processor_name(processor_name, &name_len);


	if(world_size != 2) {
		printf("Fatal : world size is not 2\n");
		MPI_Abort(MPI_COMM_WORLD ,1);
	}

	int token;
	printf("before send %s\n",processor_name);
	if( world_rank == 0) {
		//this is the root
		MPI_Send(&token,1,MPI_INT,1,0,MPI_COMM_WORLD);
		printf("rank %d send token %d\n",world_rank,token);
	} else {
		MPI_Recv(&token,1,MPI_INT,0,0,MPI_COMM_WORLD,MPI_STATUS_IGNORE);
		printf("rank %d receive token %d\n",world_rank,token);
	}

  // Finalize the MPI environment. No more MPI calls can be made after this
  MPI_Finalize();
}

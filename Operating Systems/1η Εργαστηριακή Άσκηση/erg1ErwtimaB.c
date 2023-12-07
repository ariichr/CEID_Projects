#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <unistd.h>
#include <stdio.h>
#include <sys/wait.h>
#include <stdlib.h>
#include <errno.h>
#include <fcntl.h>
#include <errno.h>
#include <string.h>
#define TRUE    1
#define FALSE   0

int n;
int *choosing;
int *number;


void tickets(int i );
void exitCriticalSection(int i);


int main()
{
 int i;                        /* loop */
 int t;
 int w;
 int j;
 key_t shmkey;                 /* shared memory key         */
 int shmid;                    /* shared memory id          */
 pid_t pid;                    /* fork pid                  */


     shmkey = ftok ("/dev/null", 5);
     shmid = shmget (shmkey, sizeof (int), 0666 | IPC_CREAT);
    if (shmid < 0)
     {
         perror ("shmget\n");
         exit (1);
     }

    printf ("How many children do you want to fork?---");
    scanf  ("%d", &n);


int *SA[n];
choosing = malloc(sizeof(int) * n);
number = malloc(sizeof(int) * n);
memset(choosing, 0, sizeof(int)*n);
memset(number, 0, sizeof(int)*n);
 for(w=0; w<n; w++){ 
    SA[w]  = (int *) shmat (shmid, NULL, 0);
    *SA[w] = 0;
   }
    /* fork child processes */
    for (i = 0; i < n; i++)
    {
        pid = fork ();

	    if (pid < 0) {

            printf ("Fork error.\n");


        }
        else if (pid == 0) /* child processes */
            break;
    }


    if (pid > 0)
	{

        while (pid = waitpid (-1, NULL, 0))
        {
            if (errno == ECHILD)
                break;
        }


        shmdt (SA[i]);
        shmctl (shmid, IPC_RMID, 0);


    }

    else
	{

        tickets( i ); /* enter critical section*/
        
        printf (" Child(%d) enters the critical section.\n", i);
        t = *SA[i];         /*increase table SA*/
        t=i;

        *SA[i] = t;
        printf (" Increasing SA[%d]\n",i);
        exitCriticalSection(i); /* exit critical section*/
		printf (" Child(%d) exits the critical region\n", i);
		printf (" new value of SA[%d]=%d.\n\n\n",i, *SA[i]);

        }


    exit (0);

}

void tickets(int process ){
   int j=0;
   int k=0;
   choosing[process]=TRUE;
   int max_num=0;
   for(j=0; j<n; j++){
      if(max_num < number[j]){
         max_num=number[j];
      }
   }

    number[process]=max_num+1;
    choosing[process]=FALSE;
    for(k=0; k<n; k++){
       while(choosing[k]==TRUE){};
       while(choosing[k]!=0 && (number[k]<number[process] || ( number[k]==number[process] && k<process))){};
    }

}
void exitCriticalSection(int process){
    number[process]=0;
}



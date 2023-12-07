#include <stdio.h>          /* printf()                 */
#include <sys/types.h>      /* key_t, sem_t, pid_t      */
#include <semaphore.h>      /* sem_open(), sem_destroy(), sem_wait().. */
#include <fcntl.h>
#include <stdlib.h>
#include<time.h>
#include <sys/shm.h>

#define true 1
#define N 2
typedef sem_t Semaphore;
Semaphore *sellerSem;
Semaphore *smokerSem[2];

void proccessSeller(int** Smoker);
void processSmoker(int** Smoker);
void DecideWhichMaterialsToSell(int** Smoker);
void TakeMaterialsFromTable(int**Smoker);





        //*Smoker[0] rollingPaper
        //*Smoker[1] tobacco
        //*Smoker[2]  matches



int main(int argc, char *argv[]){
    int i;
    int k;
    key_t shmkey;
     int shmid;
    int *SmokerMaterials[N];

printf("-\n");



    shmkey = ftok ("/dev/null", 5);
     shmid = shmget (shmkey,N* sizeof (int), 0644 | IPC_CREAT);
    printf("--\n");
    if (shmid < 0)
    {   printf("---\n");
        perror ("shmget\n");
        exit (1);
    }
    //open Semaphore
    sellerSem= sem_open ("Sem1", O_CREAT | O_EXCL, 0644, 1);
    smokerSem[0]= sem_open ("Sem2", O_CREAT | O_EXCL, 0644, 0);
    smokerSem[1]= sem_open ("Sem3", O_CREAT | O_EXCL, 0644, 0);
    smokerSem[2]= sem_open ("Sem4", O_CREAT | O_EXCL, 0644, 0);


     for(i=0; i<N; i++){
    SmokerMaterials[i]  = (int *) shmat (shmid, NULL, 0);
    *SmokerMaterials[i] = 0;
   }


   proccessSeller(SmokerMaterials);
   processSmoker(SmokerMaterials);
   for(k=0; k<N; k++){
    shmdt (SmokerMaterials[k]);
    shmctl (shmid, IPC_RMID, 0);
    }
      //close Semaphore
        sem_unlink ("Sem1");
        sem_close(sellerSem);
        sem_unlink ("Sem2");
        sem_close(smokerSem[0]);
        sem_unlink ("Sem3");
        sem_close(smokerSem[1]);
        sem_unlink ("Sem4");
        sem_close(smokerSem[2]);


}

void proccessSeller(int** Smoker){
    while(true){
      DecideWhichMaterialsToSell(Smoker);

     if(*Smoker[0]==1 && *Smoker[1]==1){   /* rollingPaper and tobacco */
        sem_post (smokerSem[0]);
     }
     else if(*Smoker[1]==1 && *Smoker[2]==1 ){  /*  tobacco and matches */
         sem_post (smokerSem[1]);
     }
     else if (*Smoker[0]==1 && *Smoker[2]==1) /* rollingPaper and  matches */
         sem_post (smokerSem[2]);
    }
}
void processSmoker(int **Smoker){
    while(true){
    int j;
    for(j=0;j<=N;j++)
    sem_wait (smokerSem[j]);
    TakeMaterialsFromTable(Smoker);

    sem_post (sellerSem);
    }
}
void DecideWhichMaterialsToSell(int **Smoker){
    int c;
    int t=0;
    srand(time(0));
    c=rand()%2;
    printf("%d",c);
    switch(c){
        case 0:
           *Smoker[0]=1; //rollingPaper
           *Smoker[1]=1; //tobacco
        break;
        case 1:
           *Smoker[1]=1; //tobacco
           *Smoker[2]=1;  //matches
        break;
        case 2:
           *Smoker[0]=1; //rollingPaper
           *Smoker[2]=1;//matches
        break;
        default:
        printf("error!");
    }

}
void TakeMaterialsFromTable(int **Smoker){
    if(*Smoker[0]==1 && *Smoker[1]==1){
        printf("Smoker  waiting to smoke (has matches)\n");
          *Smoker[0]=0; //rollingPaper
          *Smoker[1]=0; //tobacco

     }
     else if(*Smoker[1]==1 && *Smoker[2]==1 ){
           printf("Smoker waiting to smoke (has paper)\n");
           *Smoker[1]=0; //tobacco
           *Smoker[2]=0;  //matches
     }
     else if (*Smoker[0]==1 && *Smoker[2]==1){
           printf("Smoker waiting to smoke (has tobacco)\n");
           *Smoker[0]=0; //rollingPaper
           *Smoker[2]=0;//matches
     }
    }


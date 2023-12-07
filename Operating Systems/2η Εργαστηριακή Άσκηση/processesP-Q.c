#include <stdio.h>          /* printf()                 */
#include <sys/types.h>      /* key_t, sem_t, pid_t      */
#include <semaphore.h>      /* sem_open(), sem_destroy(), sem_wait().. */
#include <fcntl.h>          /* O_CREAT, O_EXEC          */


typedef sem_t Semaphore; 

void display(char *str);


								
Semaphore *synch1;
Semaphore *synch2;

int main (int argc, char **argv)
{
    pid_t pid;     
       
	

	
    synch1 = sem_open ("Sem1", O_CREAT | O_EXCL, 0644, 0); 
    synch2 = sem_open ("Sem2", O_CREAT | O_EXCL, 0644, 0);     
    
    


   pid=fork();

    if (pid > 0)
	{
        system("ls -l");  //E1
        sem_post (synch1);           
         //wait(NULL);

		                 
		system("ls -l");  // E5
        sem_post (synch1);
        
        system("ls -l");  //E8
        system("ls -l");  //E9
        //wait(NULL);
       sem_wait (synch2);
       system("ls -l");  // E7
        sem_post (synch1);
    }
    else if (pid== 0)
	{
		sem_wait (synch1);           
        system("ls -l");  //E2
        display("I am E3\n");  //E3
		
		
        sem_wait (synch1); 
        system("ls -l");  //E6
        sem_post (synch2);
        sem_wait (synch1);
        system("ls -l");  //E4
       
            
    }
    else 
	{
        /*close Semaphore*/
        sem_unlink ("Sem1");   
        sem_close(synch1);  
        sem_unlink ("Sem2");   
        sem_close(synch2); 
        
        printf ("Fork error.\n");
    }
wait(NULL);
        
        sem_unlink ("Sem1");   
        sem_close(synch1);  
        sem_unlink ("Sem2");   
        sem_close(synch2);
    exit (0);

}


void display(char *str)
{
  char *p;
  
  for (p=str; *p; p++)
  {
    write(1, p, 1);
    usleep(100);
  }
}
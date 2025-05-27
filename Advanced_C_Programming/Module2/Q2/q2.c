//I have taken the time of Threads B and C to be of 15 seconds each. Changing the value from 15 to 100 yields same result but with longer time

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>
#include <signal.h>
#include <time.h>

void interHandler(){
    printf("\nInterrupt detected, program not stopped\n");
}

int checkPrime(int n){
    if (n == 0 || n == 1)
        return 0;
    for(int i = 2; i<n; i++){
        if (n%i == 0)
            return 0;
    }
    return 1;
}

void *prime_numbers(void *arg){
    int *n_ptr = (int *) arg;
    int n = *n_ptr;
    int i, j, sum=0;
    int count=0, curr_num=2;;
    
    while(count<n){
        if (checkPrime(curr_num)){
            sum+=curr_num;
            // printf("Current: %d\n", curr_num);
            count++;
        }
        curr_num++;
    }
    
    printf("\nTHE SUM = %d\n", sum);
    pthread_exit(NULL);
    return NULL;
}

void *two_seconds(){
    time_t start, end;
    double diff;
    int stop = 1;
    start = time(NULL);
    while(stop){
        printf("\nThread 1 running");
        end = time(NULL);
        diff = difftime(end, start);
        if (diff >= 15.00)
            stop=0;
        sleep(2);
    }
    
    return NULL;
}

void *three_seconds(){
    time_t start, end;
    double diff;
    int stop = 1;
    
    start = time(NULL);
    while(stop){
        printf("\nThread 2 running");
        end = time(NULL);
        diff = difftime(end, start);
        if (diff >= 15.00)
            stop=0;
        sleep(3);
    }
    
    return NULL;
}
int main()
{  
    int n;
    
    printf("\nEnter the number of prime numbers: ");
    scanf("%d", &n);
    
    signal(SIGINT, interHandler);
    
    time_t start, end;
    
    start = time(NULL);
    pthread_t threadA, threadB, threadC;
    pthread_create(&threadA, NULL, prime_numbers, &n);
    pthread_create(&threadB, NULL, two_seconds, NULL);
    pthread_create(&threadC, NULL, three_seconds, NULL);
    
    pthread_join(threadA, NULL);
    pthread_join(threadB, NULL);
    pthread_join(threadC, NULL);
    
    end = time(NULL);
    
    double diff = difftime(end, start);
    
    printf("\nTime taken for execution = %lf", diff);
    return 0;
}

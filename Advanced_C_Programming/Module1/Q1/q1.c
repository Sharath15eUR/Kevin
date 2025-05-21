#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct taskDay{
    char dayName[20];
    char tasks[3][20];
};

int main()
{
    struct taskDay taskCal[7];
    strcpy(taskCal[0].dayName,"Monday");
    strcpy(taskCal[1].dayName,"Tuesday");
    strcpy(taskCal[2].dayName,"Wednesday");
    strcpy(taskCal[3].dayName,"Thursday");
    strcpy(taskCal[4].dayName,"Friday");
    strcpy(taskCal[5].dayName,"Saturday");
    strcpy(taskCal[6].dayName,"Sunday");
    char day[20];
    printf("Enter the day to enter tasks: ");
    scanf("%s", day);
    int n, i, j;
    printf("\nEnter the number of tasks: ");
    scanf("%d", &n);
    while (getchar() != '\n');
    for(i=0;i<7;i++)
        for(j=0; j<3; j++)
            strcpy(taskCal[i].tasks[j],"");

    for(i=0; i<n && i<3; i++){
        char task[20];
        printf("Enter the task: ");
        fgets(task, 20, stdin);
        j=0;
        while(strcmp(day, taskCal[j].dayName))
            j++;
        strcpy(taskCal[j].tasks[i],task);
    }

    for(i=0; i<7; i++){
        printf("\n%s\n", taskCal[i].dayName);
        j=0;
        while (j<3){
            printf("\t*%s\n", taskCal[i].tasks[j]);
            j++;
        }
    }
}

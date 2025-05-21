#include <stdio.h>
#include <stdlib.h>

void arrayOpt(int *ptr, int n);
void rightShift(int *beg, int n);

int main()
{
    int n;
    printf("Enter the number of elements: ");
    scanf("%d", &n);
    int arr[n];
    for(int i = 0; i<n; i++){
        printf("\nEnter the element: ");
        scanf("%d", &arr[i]);
    }

    printf("\nUNORDERED\n");
    for(int i = 0; i<n ;i++){
        printf("%d\n", arr[i]);
    }

    arrayOpt(arr, n);

    printf("\nORDERED\n");
    for(int i = 0; i<n; i++){
        printf("%d\n", arr[i]);
    }
    return 0;
}


void arrayOpt(int *ptr, int n){
    int i, j;
    for(i=0; i<n-1; i++){
        for(j=i+1; j<n; j++){
            if (*(ptr+j)%2 == 0){
                rightShift(ptr+i, j-i+1);
                break;
            }
        }
    }
}

void rightShift(int *beg, int n){
    int major_temp = *(beg+n-1);
    for (int i = 0; i<n; i++){
        //printf("\nCurr: %d", *(beg+i));
        //printf("\nMaj Temp: %d", major_temp);
        int temp = *(beg+i);
        *(beg+i) = major_temp;
        major_temp = temp;
        //printf("\nNew MAJ TEMP: %d", major_temp);
    }
}

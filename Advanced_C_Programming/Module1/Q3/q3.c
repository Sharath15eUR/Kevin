#include <stdio.h>
#include <stdlib.h>

#define MAX 100

void printArray(int arr[][100], int n);
int binarySearch(int arr[], int n, int key);
int twoDimensionSearch(int arr[][100], int n, int key);

int main()
{
    printf("Enter the dimension of array: ");
    int n;
    scanf("%d", &n);

    int arr[MAX][MAX];
    for(int i = 0; i<n; i++){
        for(int j = 0; j<n; j++){
            printf("\nEnter the element: ");
            scanf("%d", &arr[i][j]);
        }
    }
    printf("\nEnter the key to search: ");
    int k;
    scanf("%d", &k);

    printf("\nArray\n");
    printArray(arr, n);
    if (twoDimensionSearch(arr, n, k))
        printf("\nElement is found!");
    else
        printf("\nNo such element found");

    return 0;
}


void printArray(int arr[][100], int n){
    for(int i=0; i<n; i++){
        for(int j = 0; j<n; j++){
            printf("%d\t", arr[i][j]);
        }
        printf("\n");
    }
}

int binarySearch(int arr[], int n, int key){
    int start = 0;
    int end = n-1;
    while (start <= end){
        int mid = start+(end-start)/2;

        if (arr[mid] == key)
            return 1;
        if (arr[mid] < key)
            start = mid+1;
        else
            end=mid-1;
    }

    return 0;
}


int twoDimensionSearch(int arr[][100], int n, int key){
    for(int i = 0; i<n; i++){
        if (arr[i][0] <= key && key <= arr[i][n-1])
            return binarySearch(arr[i],n,key);
    }
    return 0;
}

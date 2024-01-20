#include <stdio.h>
#include <math.h>
#include <complex.h>
#include <stdlib.h>
#include <string.h>

#define N 8
#define BITS 16
#define PI 3.14159265f

#define print_arr(x) for(int i=0; i<BITS; i++){ \
		    printf("%i ", x[i]); \
		 }			 \
		 printf("\n");
#define printc(val) printf("%f + j%f\n", creal(val), cimag(val));
#define print(real, imag) printf("%f + j%f\n", real, imag);

int* convert(float value){
	int i = 0, neg = 0;

	if(value < 0){ neg = 1; }
	value = fabs(value);

	int integer = floor(value);
	float fractional = value - (float)integer;

	int* binary_arr = malloc(sizeof(int)*BITS);
	memset(binary_arr, 0x00, BITS*sizeof(int));

	// integer to binary
	while(integer){
		int rem = integer % 2;
		integer = integer >> 1;
		binary_arr[i++] = rem;
	}	

	// reverse bits
	for(int i=0; i<BITS/4; i++){
		int temp = binary_arr[i];
		binary_arr[i] = binary_arr[BITS/2-1-i];
		binary_arr[BITS/2-1-i] = temp;
	}

	// fraction to binary
	i = 8;
	while(fractional && i < 16){
		fractional = fractional*2;
		binary_arr[i] = floor(fractional);		
		fractional = fractional - binary_arr[i];
		i++;
	}

	// 2's complement
	if(neg){
		int carry = 1;
		for(int i=0; i<BITS; i++){ binary_arr[i] = binary_arr[i]? 0: 1; }
		for(int i=0; i<BITS; i++){
			binary_arr[BITS - 1 - i] ^= carry;
			carry = (~binary_arr[BITS-1-i]) & 0x1;
			if(!carry){ break; }
		}
	}

	return binary_arr;
}

int main(){

	int** bin_arr = malloc(sizeof(N/2));

	FILE* fp;
	fp = fopen("twiddle_factors.txt", "w");

	for(int i=0; i<N; i++){
		complex val = cexpf(-I*2*PI*i/(N));

		int* real = convert(creal(val));
		int* imag = convert(cimag(val));

		for(int i=0; i<BITS; i++){
			fwrite(&real[i], sizeof(int), BITS, fp);
		}
	}

	return 0;
}
